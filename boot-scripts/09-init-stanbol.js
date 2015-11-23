/* global P3BackendConfigurator, Promise */

(function() {
    var configureStanbol = function (stanbolBase, platform) {
        var attemptsCounter = 0;
        var main = this;
        return new Promise(function (resolve, reject) {
            var attempt = function() {

                var getRequest = $.ajax({method: 'POST',
                    url: stanbolBase + "fusepool/config/",
                    data: {fusepool: platform},
                    async: true
                });
                getRequest.done(function() {
                   resolve(main); 
                });
                getRequest.fail(function() {
                    if (attemptsCounter++ > 20) {
                        reject(Error("Have been waiting for stanbol too long"));
                    } else {
                        console.log("Stanbol request failed, retrying....");
                        setTimeout(function(){ 
                            attempt();
                        }, 1000);
                    }
                });
            };
            attempt();
        });
    };
    var origFunction = P3BackendConfigurator.prototype.registerTransfomersAndFactories;
    P3BackendConfigurator.prototype.registerTransfomersAndFactories = function(platform) {
        var stanbolBase = "http://"+this.serviceHost+":8304/";
        return Promise.all([
                configureStanbol(stanbolBase , platform.getPlatformURI().toString()),
                origFunction.call(this, platform)
        ]);
    };
})();

