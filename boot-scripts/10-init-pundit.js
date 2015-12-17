(function() {
    var configurePunditTransformer = function (punditTransformerBase, platform) {
        var attemptsCounter = 0;
        var main = this;
        return new Promise(function (resolve, reject) {
            var attempt = function() {

                var getRequest = $.ajax({method: 'POST',
                    url: punditTransformerBase + "fusepool/config/",
                    data: {fusepool: platform},
                    async: true
                });
                getRequest.done(function() {
                   resolve(main); 
                });
                getRequest.fail(function() {
                    if (attemptsCounter++ > 20) {
                        reject(Error("Have been waiting for punditTransformer too long"));
                    } else {
                        console.log("PunditTransformer request failed, retrying....");
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
        var punditTransformerBase = "http://"+this.serviceHost+":8386/";
        return Promise.all([
                configurePunditTransformer(punditTransformerBase , platform.getPlatformURI().toString()),
                origFunction.call(this, platform)
        ]);
    };
})();

