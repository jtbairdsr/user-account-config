#compdef docker-machine
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for Docker Machine (http://docs.docker.com/machine/).
#  Adapted from boot2docker completion by hhatto (https://github.com/hhatto)
#  and docker completion by @aeonazaan and @bobmaerten.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * ilkka (https://github.com/ilkka)
#
# ------------------------------------------------------------------------------

# helper function for completing available machines
__machines() {
  declare -a machines_cmd
  machines_cmd=($(docker-machine ls|tail +2|awk '{print $1":"$3"("$4")"}'))
  _describe 'machines' machines_cmd
}

# subcommands
local -a _docker_machine_cmds

_docker_machine_cmds=(
   'active:Get or set the active machine' \
   'create:Create a machine' \
   'config:Print the connection config for machine' \
   'inspect:Inspect information about a machine' \
   'ip:Get the IP address of a machine' \
   'kill:Kill a machine' \
   'ls:List machines' \
   'restart:Restart a machine' \
   'rm:Remove a machine' \
   'env:Display the commands to set up the environment for the Docker client' \
   'ssh:Log into or run a command on a machine with SSH' \
   'start:Start a machine' \
   'stop:Stop a machine' \
   'upgrade:Upgrade a machine to the latest version of Docker' \
   'url:Get the URL of a machine' \
   'help:Shows a list of commands or help for one command'
)

# subcommand completion functions
__active() {
  __machines
}

__help() {
  _values 'Get help for subcommand' \
    'active' \
    'create' \
    'config' \
    'inspect' \
    'ip' \
    'kill' \
    'ls' \
    'restart' \
    'rm' \
    'env' \
    'ssh' \
    'start' \
    'stop' \
    'upgrade' \
    'url' \
    'help'
}

__create() {
  _arguments \
    '--amazonec2-access-key:AWS Access Key:()' \
    '--amazonec2-ami:AWS machine image:()' \
    '--amazonec2-instance-type:AWS instance type:()' \
    '--amazonec2-region:AWS region:()' \
    '--amazonec2-root-size:AWS root disk size (in GB):()' \
    '--amazonec2-secret-key:AWS Secret Key:()' \
    '--amazonec2-security-group:AWS VPC security group:()' \
    '--amazonec2-session-token:AWS Session Token:()' \
    '--amazonec2-subnet-id:AWS VPC subnet id:()' \
    '--amazonec2-vpc-id:AWS VPC id:()' \
    '--amazonec2-zone:AWS zone for instance (i.e. a,b,c,d,e):()' \
    '--azure-docker-port:Azure Docker port:()' \
    '--azure-image:Azure image name. Default is Ubuntu 14.04 LTS x64:()' \
    '--azure-location:Azure location:()' \
    '--azure-password:Azure user password:()' \
    '--azure-publish-settings-file:Azure publish settings file:()' \
    '--azure-size:Azure size:()' \
    '--azure-ssh-port:Azure SSH port:()' \
    '--azure-subscription-cert:Azure subscription cert:()' \
    '--azure-subscription-id:Azure subscription ID:()' \
    '--azure-username:Azure username:()' \
    '--digitalocean-access-token:Digital Ocean access token:()' \
    '--digitalocean-image:Digital Ocean Image:()' \
    '--digitalocean-region:Digital Ocean region:()' \
    '--digitalocean-size:Digital Ocean size:()' \
    '--google-disk-size:GCE Instance Disk Size (in GB):()' \
    '--google-machine-type:GCE Machine Type:()' \
    '--google-project:GCE Project:()' \
    '--google-scopes:GCE Scopes (comma-separated if multiple scopes):()' \
    '--google-username:GCE User Name:()' \
    '--google-zone:GCE Zone:()' \
    '--openstack-auth-url:OpenStack authentication URL:()' \
    '--openstack-endpoint-type:OpenStack endpoint type (adminURL, internalURL or publicURL):()' \
    '--openstack-flavor-id:OpenStack flavor id to use for the instance:()' \
    '--openstack-flavor-name:OpenStack flavor name to use for the instance:()' \
    '--openstack-floatingip-pool:OpenStack floating IP pool to get an IP from to assign to the instance:()' \
    '--openstack-image-id:OpenStack image id to use for the instance:()' \
    '--openstack-image-name:OpenStack image name to use for the instance:()' \
    '--openstack-net-id:OpenStack image name to use for the instance:()' \
    '--openstack-net-name:OpenStack network name the machine will be connected on:()' \
    '--openstack-password:OpenStack password:()' \
    '--openstack-region:OpenStack region name:()' \
    '--openstack-sec-groups:OpenStack comma separated security groups for the machine:()' \
    '--openstack-ssh-port:OpenStack SSH port:()' \
    '--openstack-ssh-user:OpenStack SSH user:()' \
    '--openstack-tenant-id:OpenStack tenant id:()' \
    '--openstack-tenant-name:OpenStack tenant name:()' \
    '--openstack-username:OpenStack username:()' \
    '--rackspace-api-key:Rackspace API key:()' \
    '--rackspace-docker-install:Set if docker have to be installed on the machine:()' \
    '--rackspace-endpoint-type:Rackspace endpoint type (adminURL, internalURL or the default publicURL):()' \
    '--rackspace-flavor-id:Rackspace flavor ID. Default: General Purpose 1GB:()' \
    '--rackspace-image-id:Rackspace image ID. Default: Ubuntu 14.04 LTS (Trusty Tahr) (PVHVM):()' \
    '--rackspace-region:Rackspace region name:()' \
    '--rackspace-ssh-port:SSH port for the newly booted machine. Set to 22 by default:()' \
    '--rackspace-ssh-user:SSH user for the newly booted machine. Set to root by default:()' \
    '--rackspace-username:Rackspace account username:()' \
    '--softlayer-api-endpoint:softlayer api endpoint to use:()' \
    '--softlayer-api-key:softlayer user API key:()' \
    "--softlayer-cpu:number of CPUs for the machine:()" \
    '--softlayer-disk-size:Disk size for machine, a value of 0 uses the default size on softlayer:()' \
    '--softlayer-domain:domain name for machine:()' \
    '--softlayer-hostname:hostname for the machine:()' \
    '--softlayer-hourly-billing:set hourly billing for machine - on by default:()' \
    '--softlayer-image:OS image for machine:()' \
    '--softlayer-local-disk:use machine local disk instead of softlayer SAN:()' \
    '--softlayer-memory:Memory in MB for machine:()' \
    '--softlayer-private-net-only:Use only private networking:()' \
    '--softlayer-region:softlayer region for machine:()' \
    '--softlayer-user:softlayer user account name:()' \
    '--url:URL of host when no driver is selected:()' \
    '--virtualbox-boot2docker-url:The URL of the boot2docker image. Defaults to the latest available version:()' \
    '--virtualbox-disk-size:Size of disk for host in MB:()' \
    '--virtualbox-memory:Size of memory for host in MB:()' \
    '--vmwarefusion-boot2docker-url:Fusion URL for boot2docker image:()' \
    '--vmwarefusion-disk-size:Fusion size of disk for host VM (in MB):()' \
    '--vmwarefusion-memory-size:Fusion size of memory for host VM (in MB):()' \
    '--vmwarevcloudair-catalog:vCloud Air Catalog (default is Public Catalog):()' \
    '--vmwarevcloudair-catalogitem:vCloud Air Catalog Item (default is Ubuntu Precise):()' \
    '--vmwarevcloudair-computeid:vCloud Air Compute ID (if using Dedicated Cloud):()' \
    '--vmwarevcloudair-cpu-count:vCloud Air VM Cpu Count (default 1):()' \
    '--vmwarevcloudair-docker-port:vCloud Air Docker port:()' \
    '--vmwarevcloudair-edgegateway:vCloud Air Org Edge Gateway (Default is <vdcid>):()' \
    '--vmwarevcloudair-memory-size:vCloud Air VM Memory Size in MB (default 2048):()' \
    '--vmwarevcloudair-orgvdcnetwork:vCloud Air Org VDC Network (Default is <vdcid>-default-routed):()' \
    '--vmwarevcloudair-password:vCloud Air password:()' \
    '--vmwarevcloudair-provision:vCloud Air Install Docker binaries (default is true):()' \
    '--vmwarevcloudair-publicip:vCloud Air Org Public IP to use:()' \
    '--vmwarevcloudair-ssh-port:vCloud Air SSH port:()' \
    '--vmwarevcloudair-username:vCloud Air username:()' \
    '--vmwarevcloudair-vdcid:vCloud Air VDC ID:()' \
    '--vmwarevsphere-boot2docker-url:vSphere URL for boot2docker image:()' \
    '--vmwarevsphere-compute-ip:vSphere compute host IP where the docker VM will be instantiated:()' \
    '--vmwarevsphere-cpu-count:vSphere CPU number for docker VM:()' \
    '--vmwarevsphere-datacenter:vSphere datacenter for docker VM:()' \
    '--vmwarevsphere-datastore:vSphere datastore for docker VM:()' \
    '--vmwarevsphere-disk-size:vSphere size of disk for docker VM (in MB):()' \
    '--vmwarevsphere-memory-size:vSphere size of memory for docker VM (in MB):()' \
    '--vmwarevsphere-network:vSphere network where the docker VM will be attached:()' \
    '--vmwarevsphere-password:vSphere password:()' \
    '--vmwarevsphere-pool:vSphere resource pool for docker VM:()' \
    '--vmwarevsphere-username:vSphere username:()' \
    '--vmwarevsphere-vcenter:vSphere IP/hostname for vCenter:()' \
    '--driver:Driver to create machine with.:(amazonec2 azure digitalocean google none openstack rackspace softlayer virtualbox vmwarefusion vmwarevcloudair vmwarevsphere)' \
    '--swarm:Configure Machine with Swarm:()' \
    '--swarm-master:Configure Machine to be a Swarm master:()' \
    '--swarm-discovery:Discovery service to use with Swarm:()' \
    '--swarm-host:ip/socket to listen on for Swarm master:()' \
    '--swarm-addr:addr to advertise for Swarm (default: detect and use the machine IP):()'
}

__config() {
  _arguments \
    '--swarm[Display the Swarm config instead of the Docker daemon]'
  __machines
}

__inspect() {
  __machines
}

__ip() {
  __machines
}

__env() {
  _arguments \
    '--unset[Unset variables instead of setting them]' \
    '--swarm[Display the Swarm config instead of the Docker daemon]'
  __machines
}

__kill() {
  __machines
}

__ls() {
  _arguments \
    '--quiet[Enable quiet mode]'
}

__restart() {
  __machines
}

__start() {
  __machines
}

__stop() {
  __machines
}

__rm() {
  __machines
}

__ssh() {
  __machines
}

__upgrade() {
  __machines
}

__url() {
  __machines
}

# common args
_arguments \
  '--debug[Enable debug mode]' \
  '--storage-path[Configures storage path]:_files' \
  '--tls-ca-cert[CA to verify remotes against]:_files' \
  '--tls-ca-key[Private key to generate certificates]:_files' \
  '--tls-client-cert[Client cert to use for TLS]:_files' \
  '--tls-client-key[Private key used in client TLS auth]:_files' \
  '--help[show help]' \
  '--version[print the version]' \
  '*:: :->command'

# start machines!
if (( CURRENT == 1 )); then
  _describe -t commands 'docker-machine command' _docker_machine_cmds
fi

local -a _command_args
case "$words[1]" in
  active)
    __active ;;
  create)
    __create ;;
  config)
    __config ;;
  inspect)
    __inspect ;;
  ip)
    __ip ;;
  kill)
    __kill ;;
  ls)
    __ls ;;
  restart)
    __restart ;;
  rm)
    __rm ;;
  env)
    __env ;;
  ssh)
    __ssh ;;
  start)
    __start ;;
  stop)
    __stop ;;
  upgrade)
    __upgrade ;;
  url)
    __url ;;
  help)
    __help ;;
esac