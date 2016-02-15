host = db.serverStatus().host.split('.')[0];
prompt = function() {
	return db + '@' + host + '      Documents:' + db.stats().objects + '\n> ';
};

