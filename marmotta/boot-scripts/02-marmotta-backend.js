/* global P3BackendConfigurator */

(function() {
    var host = window.location.hostname;
    P3BackendConfigurator.prototype.serviceHost = host;
    
    P3BackendConfigurator.prototype.getLdpRoot = function() {
        return new Promise(function(resolve, reject) {
            resolve("http://"+host+":8181/ldp");
        });
    };
})();
