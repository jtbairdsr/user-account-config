#!/usr/bin/python
# encoding: utf-8
#
# Copyright © 2015 deanishe@deanishe.net
#
# MIT Licence. See http://opensource.org/licenses/MIT
#
# Created on 2015-02-03
#

"""
toggle_alfred_theme.py [-v|-q] [-d|--dark <theme>] [-l|--light <theme>]

    **You must first edit this script (or the accompanying bash wrapper)
    to set your location!**

    These scripts (Python script and bash wrapper) live at:
    https://gist.github.com/deanishe/ce442c3a768adedc9c39

    Change Alfred's theme depending on whether it's dark outside. Theme
    is changed immediately when the script is run and the script will
    also call itself again at sunrise and sunset (via launchd) to change
    Alfred's theme. It's works well together with F.lux, which can
    switch to Yosemite's dark mode at sunset.

    Just run the script *once* with your preferred themes:

        python toggle_alfred_theme.py --dark 'Dark Theme' --light 'Light Theme'

    or if you're using the wrapper:

        toggle-alfred-theme.bash --dark 'Dark Theme' --light 'Light Theme'

    and it will ensure Alfred's theme is changed every day at sunrise
    and sunset.

    To change your preferred themes, just run the script again.

    Note: Because the script calls itself via launchd, if you move the
    script, it will stop working until you run it again.

Usage:

    toggle_alfred_theme.py (-h|--help)
    toggle_alfred_theme.py --timezones
    toggle_alfred_theme.py (-t|--times)
    toggle_alfred_theme.py [-n] [-v|-q] [--dark <theme>] [--light <theme>]

Options:
    -h, --help           Show this help message
    -n, --nothing        Show what would be set, but make no changes
    -t, --times          Show sunrise and sunset times for next 7 days
    --timezones          Show a list of (>500) supported timezones
    -l, --light <theme>  Alfred theme to use after sunrise
    -d, --dark <theme>   Alfred theme to use after sunset
    -v, --verbose        Show debugging info
    -q, --quiet          Only show warnings and errors

Installation & Setup:

    This script requires the `astral` and `pytz` libraries. Install with:

        pip install astral

    It's better to install them in the same directory as this script (or
    use a virtualenv), in order not to muck up your Python installation
    or break other software:

        pip install --target=/directory/where/this/script/is astral

    Adjust the settings at the top of this script in the CONFIG section
    (or in the bash wrapper) to match your location.

    `TZ_NAME` must be one of the timezones recognised by `pytz`. To see
    a list of all supported timezones, run this script with the
    --timezones option. (Note there are over 500 timezones.)

    You can usually find your town's latitude, longitude and elevation
    on its Wikipedia page.

How it works:

    When run, the script will immediately set Alfred's theme according
    to whether it's light or dark out, then tell OS X to run the script
    again at the next sunset/sunrise. Even if your computer is off/asleep
    when the script is supposed to run, it will be run immediately on
    boot/wake.

    Note: Yosemite has some issues with running LaunchAgents on wake. If
    the script isn't running when it's supposed to on Yosemite, but the
    script reports the correct times, it's a problem with Yosemite, not
    this script.

    The script has to fork into the background (i.e. exit successfully
    immediately) because `launchctl` doesn't like the script updating
    the Launch Agent while it's running it.

"""

from __future__ import print_function, unicode_literals, absolute_import

#                            .8888b oo
#                            88   "
# .d8888b. .d8888b. 88d888b. 88aaa  dP .d8888b.
# 88'  `"" 88'  `88 88'  `88 88     88 88'  `88
# 88.  ... 88.  .88 88    88 88     88 88.  .88
# `88888P' `88888P' dP    dP dP     dP `8888P88
#                                           .88
#                                       d8888P
#
# Change these settings to match your location. You can get the
# latitude, longitude and elevation from the Wikipedia page for
# your town/city.
# TZ_NAME must be one of the timezones understood by `pytz`
# Run this script with the option --timezones to see a list.

CITY = 'Essen'
COUNTRY = 'Germany'
LATITUDE = 51.450833
LONGITUDE = 7.013056
TZ_NAME = 'Europe/Berlin'
ELEVATION = 116  # In metres!


# ---------------------------------------------------------
# You probably don't need to touch the settings below

# Default light and dark Alfred themes. The light theme will be set at
# sunrise, the dark theme at sunset The default settings ('Light' and
# 'Dark') are built-in Alfred themes.
#
# There is no real need to use these options: you can specify the
# themes on the command line with -l and -d and those choices will
# be preserved. These are just to ensure the script works even if
# you don't specify a theme on the command line.
LIGHT_THEME = 'Light'
DARK_THEME = 'Dark'

# Python interpreter to run this script with (when called from the
# Launch Agent). If you want to use a Homebrew Python, change this to
# `/usr/local/bin/python`
PYTHON_INTERPRETER = '/usr/bin/python'

# Seconds to wait after reloading the Launch Agent. If the script
# appears to be constantly running on your machine, increase this number
PAUSE_AFTER_RELOAD = 3  # seconds

# Set to `True` to capture STDOUT/STDERR of Launch Agent and set
# DEBUG logging level. The output of STDOUT & STDERR are saved to
# net.deanishe.alfred-toggle-theme.launch-agent.stdXXX.log files
# in ~/Library/Logs, alongside the log file.
DEBUG = False


#                         dP
#                         88
# .d8888b. .d8888b. .d888b88 .d8888b.
# 88'  `"" 88'  `88 88'  `88 88ooood8
# 88.  ... 88.  .88 88.  .88 88.  ...
# `88888P' `88888P' `88888P8 `88888P'


##################################################################
# DON'T CHANGE ANYTHING BELOW UNLESS YOU KNOW WHAT YOU'RE DOING!
##################################################################

from contextlib import contextmanager
from datetime import datetime, timedelta
import getopt
import logging
import logging.handlers
import os
import plistlib
import stat
import subprocess
import sys
import time

from astral import Location
import pytz

# The Launch Agent that'll be saved in ~/Library/LaunchAgents. The
# script uses the Launch Agent to call itself at sunrise/-set to change
# the theme. A great feature of launchd is that if the computer is
# off/asleep when an agent is supposed to run, it'll run the agent on
# boot/wake instead.
LAUNCH_AGENT_NAME = 'net.deanishe.alfred-toggle-theme'
LAUNCH_AGENT_PATH = os.path.expanduser(
    '~/Library/LaunchAgents/{0}.plist'.format(LAUNCH_AGENT_NAME))

PID_FILE = '/tmp/{0}.pid'.format(LAUNCH_AGENT_NAME)

# AppleScript to tell Alfred to switch theme
ALFRED_SCRIPT = 'tell application "Alfred 2" to set theme "{theme}"'

THIS_SCRIPT = os.path.abspath(__file__)

# Default parameters to save to the Launch Agent .plist
LAUNCH_AGENT = {
    'Label': 'Toggle Alfred theme at sunrise and sunset',
    'ProgramArguments': [],
    'StartCalendarInterval': {},
    'EnvironmentVariables': {},
    'RunAtLoad': True,
}


# dP                            oo
# 88
# 88 .d8888b. .d8888b. .d8888b. dP 88d888b. .d8888b.
# 88 88'  `88 88'  `88 88'  `88 88 88'  `88 88'  `88
# 88 88.  .88 88.  .88 88.  .88 88 88    88 88.  .88
# dP `88888P' `8888P88 `8888P88 dP dP    dP `8888P88
#                  .88      .88                  .88
#              d8888P   d8888P               d8888P

log = logging.getLogger('alfred-theme')
logging.basicConfig(format='%(levelname)-8s  %(message)s')
log.setLevel(logging.INFO)

logdir = os.path.expanduser('~/Library/Logs')
LOG_PATH = os.path.join(logdir, '{0}.log'.format(LAUNCH_AGENT_NAME))

logfile = logging.handlers.RotatingFileHandler(
    LOG_PATH,
    maxBytes=1024**2,
    backupCount=1,
    encoding='utf-8')

logfile.setFormatter(logging.Formatter(
    '%(asctime)s %(levelname)-8s [%(name)s] %(message)s',
    datefmt='%d/%m %H:%M:%S'))

logging.getLogger().addHandler(logfile)


# .d8888b. 88d888b. dP   .dP dP   .dP .d8888b. 88d888b. .d8888b.
# 88ooood8 88'  `88 88   d8' 88   d8' 88'  `88 88'  `88 Y8ooooo.
# 88.  ... 88    88 88 .88'  88 .88'  88.  .88 88             88
# `88888P' dP    dP 8888P'   8888P'   `88888P8 dP       `88888P'

TRUE_STRINGS = ('1', 'true', 'yes', 'on', 'ja', 'oui')
FALSE_STRINGS = ('0', 'false', 'no', 'off', 'nein', 'non')

# Override script settings with environmental variables
CITY = os.getenv('CITY', CITY)
COUNTRY = os.getenv('COUNTRY', COUNTRY)
LATITUDE = float(os.getenv('LATITUDE', LATITUDE))
LONGITUDE = float(os.getenv('LONGITUDE', LONGITUDE))
TZ_NAME = os.getenv('TZ_NAME', TZ_NAME)
ELEVATION = int(os.getenv('ELEVATION', ELEVATION))

LIGHT_THEME = os.getenv('LIGHT_THEME', LIGHT_THEME)
DARK_THEME = os.getenv('DARK_THEME', DARK_THEME)

PYTHON_INTERPRETER = os.getenv('PYTHON_INTERPRETER', PYTHON_INTERPRETER)

PAUSE_AFTER_RELOAD = int(os.getenv('PAUSE_AFTER_RELOAD', PAUSE_AFTER_RELOAD))

env_debug = os.getenv('DEBUG', None)
if env_debug is not None:
    if env_debug.lower() in TRUE_STRINGS:
        DEBUG = True
    elif env_debug.lower() in FALSE_STRINGS:
        DEBUG = False
    else:  # wtf did they enter?
        log.warning(
            "Ignoring incomprehensible environmental DEBUG value : {}".format(
                env_debug))


#       dP          dP                                  oo
#       88          88
# .d888b88 .d8888b. 88d888b. dP    dP .d8888b. .d8888b. dP 88d888b. .d8888b.
# 88'  `88 88ooood8 88'  `88 88    88 88'  `88 88'  `88 88 88'  `88 88'  `88
# 88.  .88 88.  ... 88.  .88 88.  .88 88.  .88 88.  .88 88 88    88 88.  .88
# `88888P8 `88888P' 88Y8888' `88888P' `8888P88 `8888P88 dP dP    dP `8888P88
#                                          .88      .88                  .88
#                                      d8888P   d8888P               d8888P

if DEBUG:
    # Also capture STDOUT/STDERR of Launch Agent and save it to
    # ~/Library/Logs
    STDOUT_PATH = os.path.join(logdir,
                               '{0}.launch-agent.stdout.log'.format(
                                   LAUNCH_AGENT_NAME))
    STDERR_PATH = os.path.join(logdir,
                               '{0}.launch-agent.stderr.log'.format(
                                   LAUNCH_AGENT_NAME))

    # if os.path.exists(LOG_PATH):
    #     os.chmod(LOG_PATH, stat.S_IRUSR | stat.S_IWUSR)

    log.setLevel(logging.DEBUG)

    # Capture STDOUT/STDERR from Launch Agent
    LAUNCH_AGENT['StandardOutPath'] = STDOUT_PATH
    LAUNCH_AGENT['StandardErrorPath'] = STDERR_PATH
    # Helpful with debugging, but adds a lot of complexity.
    # Should probably remove this.
    # LAUNCH_AGENT['RunAtLoad'] = True


# dP                dP
# 88                88
# 88d888b. .d8888b. 88 88d888b. .d8888b. 88d888b. .d8888b.
# 88'  `88 88ooood8 88 88'  `88 88ooood8 88'  `88 Y8ooooo.
# 88    88 88.  ... 88 88.  .88 88.  ... 88             88
# dP    dP `88888P' dP 88Y888P' `88888P' dP       `88888P'
#                      88
#                      dP

class AttrDict(dict):
    """Allow dict keys to be accessed as attributes"""

    def __getattr__(self, attr):
        if attr in self:
            return self[attr]
        else:
            raise AttributeError('{0!r}'.format(attr))


# ---------------------------------------------------------
# Processes

def daemonise(stdin='/dev/null', stdout='/dev/null', stderr='/dev/null'):
    """Fork the current process into a background daemon.

    :param stdin: where to read input
    :type stdin: filepath
    :param stdout: where to write stdout output
    :type stdout: filepath
    :param stderr: where to write stderr output
    :type stderr: filepath

    """

    # Do first fork.
    try:
        pid = os.fork()
        if pid > 0:
            sys.exit(0)  # Exit first parent.
    except OSError as e:
        log.critical('fork #1 failed: (%s) %s', e.errno, e.strerror)
        sys.exit(1)
    # Decouple from parent environment.
    os.chdir(os.path.dirname(THIS_SCRIPT))
    os.umask(0)
    os.setsid()
    # Do second fork.
    try:
        pid = os.fork()
        if pid > 0:
            sys.exit(0)  # Exit second parent.
    except OSError as e:
        log.critical('fork #2 failed: (%d) %s', e.errno, e.strerror)
        sys.exit(1)
    # Now I am a daemon!
    # Redirect standard file descriptors.
    si = open(stdin, 'r', 0)
    so = open(stdout, 'a+', 0)
    se = open(stderr, 'a+', 0)
    if hasattr(sys.stdin, 'fileno'):
        os.dup2(si.fileno(), sys.stdin.fileno())
    if hasattr(sys.stdout, 'fileno'):
        os.dup2(so.fileno(), sys.stdout.fileno())
    if hasattr(sys.stderr, 'fileno'):
        os.dup2(se.fileno(), sys.stderr.fileno())


@contextmanager
def pidfile(path=PID_FILE):
    """Context manager to save the PID of the current process to `path`

    Automatically deletes `path` on `__exit__`

    """

    with open(path, 'wb') as fp:
        fp.write(str(os.getpid()))
    log.debug('Wrote PID (%s) file : %s', os.getpid(), path)
    yield
    if os.path.exists(pidfile):
        os.unlink(pidfile)
        log.debug('Deleted own PID file : %s', path)


def already_running():
    """Return `True` if a copy of this script is already running"""

    if not os.path.exists(PID_FILE):
        return False

    with open(PID_FILE) as fp:
        pid = fp.read().strip()

    if not pid.isdigit():
        os.unlink(PID_FILE)
        return False

    pid = int(pid)

    try:
        os.kill(pid, 0)
    except OSError:
        if os.path.exists(PID_FILE):
            os.unlink(PID_FILE)
            log.debug('Deleted stale PID file : %s', PID_FILE)
        return False

    log.debug('Script already running with PID : %s', pid)
    return True


#                     dP                                       dP
#                     88                                       88
# .d8888b. dP.  .dP d8888P .d8888b. 88d888b. 88d888b. .d8888b. 88
# 88ooood8  `8bd8'    88   88ooood8 88'  `88 88'  `88 88'  `88 88
# 88.  ...  .d88b.    88   88.  ... 88       88    88 88.  .88 88
# `88888P' dP'  `dP   dP   `88888P' dP       dP    dP `88888P8 dP

def set_theme(theme):
    """Set Alfred theme to theme with name `theme`"""

    script = ALFRED_SCRIPT.format(theme=theme)

    retcode = subprocess.call([b'osascript', b'-e', script.encode('utf-8')])
    if retcode != 0:
        log.critical('AppleScript command failed. '
                     'osascript exited with %s', retcode)
    else:
        log.info('Alfred theme set to `%s`', theme)

    return retcode


def update_launch_agent(dt, dark_theme, light_theme, verbose=False):
    """Rewrite the launch agent to run at datetime `dt`

    `dt` should be a local time, not UTC

    - Unload Launch Agent
    - Rewrite Launch Agent
    - Load Launch Agent

    """

    if os.path.exists(LAUNCH_AGENT_PATH):
        retcode = subprocess.call(['launchctl', 'unload', LAUNCH_AGENT_PATH])
        if retcode != 0:
            log.warning('Error unloading Launch Agent. '
                        'launchctl exited with {0}'.format(retcode))

    params = LAUNCH_AGENT.copy()
    cmd = [PYTHON_INTERPRETER, THIS_SCRIPT,
           '--dark', dark_theme,
           '--light', light_theme]
    if verbose:
        cmd.append('-v')
    params['ProgramArguments'] = cmd
    # Start date for launch agent
    d = {
        'Month': dt.month,
        'Day': dt.day,
        'Hour': dt.hour,
        'Minute': dt.minute,
    }
    params['StartCalendarInterval'] = d

    env = {
        'CITY': CITY,
        'COUNTRY': COUNTRY,
        'LATITUDE': str(LATITUDE),
        'LONGITUDE': str(LONGITUDE),
        'TZ_NAME': TZ_NAME,
        'ELEVATION': str(ELEVATION),
        'PYTHON_INTERPRETER': PYTHON_INTERPRETER,
        'PAUSE_AFTER_RELOAD': str(PAUSE_AFTER_RELOAD),
        'DEBUG': ('0', '1')[DEBUG],
        'LIGHT_THEME': LIGHT_THEME,
        'DARK_THEME': DARK_THEME,
    }

    params['EnvironmentVariables'] = env

    with open(LAUNCH_AGENT_PATH, 'wb') as fp:
        plistlib.writePlist(params, fp)

    # Ensure correct permissions
    os.chmod(LAUNCH_AGENT_PATH, stat.S_IRUSR | stat.S_IWUSR)

    retcode = subprocess.call(['launchctl', 'load', LAUNCH_AGENT_PATH])

    if retcode != 0:
        log.critical('Error loading Launch Agent. '
                     'launchctl exited with %s', retcode)

    else:
        log.info('Updated and reloaded Launch Agent `%s`', LAUNCH_AGENT_PATH)

    return retcode


# ---------------------------------------------------------
# Dates and times and sunrises and sunsets

def format_delta(delta):
    """Make a `datetime.timedelta` human readable"""
    output = []
    seconds = delta.seconds
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    days, hours = divmod(hours, 24)

    # I think the next sunrise/-set can be more than 24 hours away in
    # Alaska and Iceland...
    if days > 0:
        output.append('{0} day{1}'.format(days, 's'[days == 1:]))
    if hours > 0:
        output.append('{0} hour{1}'.format(hours, 's'[hours == 1:]))
    if minutes > 0:
        output.append('{0} minute{1}'.format(minutes, 's'[minutes == 1:]))

    return ', '.join(output)


def round_datetime(dt):
    """Remove seconds and microseconds from `datetime`

    Rounds down to minute

    """

    delta = timedelta(seconds=dt.second, microseconds=dt.microsecond)
    return dt - delta


def get_location():
    """Return `astral.Location` for wherever you are"""
    return Location((CITY, COUNTRY, LATITUDE, LONGITUDE, TZ_NAME,
                     ELEVATION))


def get_sunrise_sunset(days=7):
    """Return sunrise and sunset times for coming days

    Returns a list of `(sunrise, sunset)` tuples of `datetime` objects.

    `datetimes` are in local timezone

    """

    results = []
    location = get_location()
    utc = pytz.utc
    tz = pytz.timezone(TZ_NAME)
    now = utc.localize(datetime.utcnow())
    day = now.astimezone(tz)

    for i in range(days):
        sunrise = location.sunrise(day, local=True)
        sunset = location.sunset(day, local=True)
        results.append((sunrise, sunset))
        day += timedelta(days=1)

    return results


def next_change():
    """Get UTC datetime of next sunset/sunrise

    Returns a tuple `(utc_dt, is_sunset)`

    """

    location = get_location()
    now = day = pytz.utc.localize(datetime.utcnow())

    while True:
        sunrise = location.sunrise(day, local=False)
        if sunrise > now:
            return (sunrise, False)

        sunset = location.sunset(day, local=False)
        if sunset > now:
            return (sunset, True)

        day += timedelta(days=1)


def is_dark(utc_dt):
    """Return True if `utc_dt` is after sunset"""
    location = get_location()
    sunset = round_datetime(location.sunset(utc_dt, local=False))
    sunrise = round_datetime(location.sunrise(utc_dt, local=False))

    if utc_dt >= sunrise and utc_dt < sunset:
        log.debug(utc_dt.strftime('light at %Y-%m-%d %X %Z'))
        return False

    log.debug(utc_dt.strftime('dark at %Y-%m-%d %X %Z'))
    return True


#                     dP   oo
#                     88
# .d8888b. .d8888b. d8888P dP .d8888b. 88d888b. .d8888b.
# 88'  `88 88'  `""   88   88 88'  `88 88'  `88 Y8ooooo.
# 88.  .88 88.  ...   88   88 88.  .88 88    88       88
# `88888P8 `88888P'   dP   dP `88888P' dP    dP `88888P'

# ---------------------------------------------------------
# Parse command-line options

def get_options(args=None):
    """Returns (options, args). if `args` is `None`, uses `sys.argv[1:]`"""
    # Use getopt as argparse isn't available in Python 2.6 on Snow Leopard :(

    # Use tuples instead of dict to preserve order. Otherwise, there's
    # no way to know whether `times` or `timezones` will grab the
    # -t option.
    defaults = (
        ('dark=', DARK_THEME),
        ('light=', LIGHT_THEME),
        ('help', False),
        ('verbose', False),
        ('quiet', False),
        ('nothing', False),
        ('times', False),
        ('timezones', False),
    )

    # Map options to formats, e.g. {'-d': 'dark=', '--dark': 'dark='}
    opt_format_map = {}

    opts_short = ''
    # Do this all the long way round, so we know which long option
    # 'won' the short option
    for fmt, default in defaults:
        name = fmt.rstrip('=')
        opt_format_map['--' + name] = fmt
        c = name[0]
        if c not in opts_short:  # Don't overwrite existing short option
            opts_short += c
            opt_format_map['-' + c] = fmt
            if fmt.endswith('='):
                opts_short += ':'
    try:
        opts, args = getopt.getopt(sys.argv[1:],
                                   opts_short,
                                   [t[0] for t in defaults])
    except getopt.GetoptError as err:
        usage(str(err))
        sys.exit(2)

    parsed = dict(opts)

    # ---------------------------------------------------------
    # Populate options

    # Initialise with defaults
    options = AttrDict([(k.rstrip('='), v) for (k, v) in defaults])

    # Update options from CLI arguments
    for opt in parsed:
        fmt = opt_format_map.get(opt)
        if not fmt:
            log.error('Unknown option : %s', opt)
            continue
        name = fmt.rstrip('=')
        value = parsed[opt]
        # Set flag options to True
        if not fmt.endswith('=') and value is not None:
            value = True

        options[name] = value

    return (options, args)


# ---------------------------------------------------------
# Other script actions

def list_timezones():
    """Print the names of all supported timezones"""
    for tzname in pytz.all_timezones:
        print(tzname)


def list_times():
    """Show sunrise and sunset times for the next 7 days"""

    print('Date        Sunrise    Sunset')
    print('----------  ---------  ---------')
    for (sunrise, sunset) in get_sunrise_sunset():
        print('{0}  {1}  {2}'.format(sunrise.strftime('%Y-%m-%d'),
                                     sunrise.strftime('%H:%M %Z'),
                                     sunset.strftime('%H:%M %Z')))


def usage(msg=None):
    """Show help"""
    if msg:
        print(msg + '\n')
    print(__doc__)


# ---------------------------------------------------------
# Main script entry point

def main():

    o, _ = get_options()

    if o.verbose:
        log.setLevel(logging.DEBUG)
    elif o.quiet:
        log.setLevel(logging.WARNING)

    log.debug('Started with options : %s', o)

    # ---------------------------------------------------------
    # Alternate actions

    if o.help:
        usage()
        return 0
    elif o.timezones:
        list_timezones()
        return 0
    elif o.times:
        list_times()
        return 0

    # The script basically works by running itself via launchd, so to
    # prevent endless loops, exit here in the case that the script was
    # indirectly called by another running copy of itself.
    if already_running():
        log.info('Script is already running. Exiting.')
        return 0

    # ---------------------------------------------------------
    # Set Alfred's theme and load Launch Agent to run the script
    # again at the next sunrise/-set

    # UTC dates and times are used internally. Localtime is only
    # used for user output and the Launch Agent
    utc = pytz.utc
    local_tz = pytz.timezone(TZ_NAME)
    # Ensure `now` has UTC timezone
    now = utc.localize(datetime.utcnow())

    # ---------------------------------------------------------
    # Set theme right now

    if is_dark(now):
        current_theme = o.dark
    else:
        current_theme = o.light

    if not o.nothing:
        log.info('Light theme : %s', o.light)
        log.info('Dark theme  : %s', o.dark)
        # There's no simple way to determine which theme Alfred is
        # currently sporting, so just set theme regardless
        set_theme(current_theme)
    else:
        print('Light theme : {0}'.format(o.light))
        print('Dark theme  : {0}'.format(o.dark))
        print('Would set current theme to `{0}`'.format(current_theme))

    # ---------------------------------------------------------
    # Update Launch Agent to call script at next sunrise/-set

    utc_dt, is_sunset = next_change()
    local_dt = utc_dt.astimezone(local_tz)
    delta = utc_dt - now
    event = ('sunrise', 'sunset')[is_sunset]
    next_theme = (o.light, o.dark)[is_sunset]

    msg = 'Next change : Theme `{0}` at {1} in {2} at {3}'.format(
        next_theme,
        event,
        format_delta(delta),
        local_dt.strftime('%H:%M %Z'))

    if o.nothing:
        print(msg)
    else:
        log.info(msg)

    retcode = 0
    if not o.nothing:  # Update Launch Agent in background

        log.debug('Forking into background ...')
        daemonise()

        with pidfile():
            log.debug('[background] Running in background')
            # Wait for launchctl to finish loading the Launch Agent
            time.sleep(2)

            # Set script to run 1 minute after sunrise/-set just to
            # be on the safe side
            retcode = update_launch_agent(local_dt + timedelta(minutes=1),
                                          o.dark, o.light,
                                          o.verbose)

            # Wait for a few seconds to give launchctl a chance to load
            # the Launch Agent and (possibly) run this script (which
            # will exit immediately). If this script exits before any
            # "grandchild", an infinite loop may ensue...
            log.debug('[background] Pausing for %d seconds before exiting ...',
                      PAUSE_AFTER_RELOAD)
            time.sleep(PAUSE_AFTER_RELOAD)
            log.debug('[background] Done ' + '-' * 32)

    return retcode


if __name__ == '__main__':
    sys.exit(main())
