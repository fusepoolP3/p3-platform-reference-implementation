/* global P3BackendConfigurator */

(function() {
    var host = window.location.hostname;
    P3BackendConfigurator.prototype.serviceHost = host;
    
    P3BackendConfigurator.prototype.getLdpRoot = function() {
        return new Promise(function(resolve, reject) {
            resolve("http://"+host+":8181/DAV/home/fusepool/ldp/");
        });
    };

    P3BackendConfigurator.prototype.registerBackendfeatures = function(ldpRoot) {
	var registrations = [];
	registrations.push(this.platformEntryConfigurator.registerSparql("http://"+this.serviceHost+":8181/sparql"));
	registrations.push(this.platformEntryConfigurator.registerLdpRoot(ldpRoot));
	return Promise.all(registrations);
    };
})();