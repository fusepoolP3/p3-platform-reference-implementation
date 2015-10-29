function P3BackendConfigurator() {
}

P3BackendConfigurator.prototype

P3BackendConfigurator.prototype.initialize = function(platformEntryConfigurator) {
	return platformEntryConfigurator.ifUnconfigured(this.unconditionedInitialize);
}

P3BackendConfigurator.prototype.unconditionedInitialize = function(platformEntryConfigurator) {
    var host = window.location.hostname;
	var configurator = this;
	var getLdpRoot = new Promise(function(resolve, reject) {
		resolve("http://"+host+":8181/ldp");
	});    
	return getLdpRoot.then(function(baseURI) { 
		var irldpcUri = baseURI + '/uir';
		var putIrldpcRequest = $.ajax({type: 'PUT',
	        url: irldpcUri,
	        headers: {'Content-Type': 'text/turtle'},
	        data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
	                ' <http://www.w3.org/2000/01/rdf-schema#label> "Interaction Request Container"@en ; ' +
	                ' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains Interaction Requests"@en . ',
	        async: true
	    });
	
		var registrations = [];
		registrations.push(putIrldpcRequest.then(function () {
			return platformEntryConfigurator.registerIRLDPC(irldpcUri);
		}));
		
		var tfrUri = baseURI + '/tfr';
		var putTfrRequest = $.ajax({type: 'PUT',
            url: tfrUri,
            headers: {'Content-Type': 'text/turtle'},
            data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
                    ' <http://www.w3.org/2000/01/rdf-schema#label> "Transformer Factory Registry"@en ; ' +
                    ' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains Transformer Factories"@en . ',
            async: true
        });
		
		registrations.push(putTfrRequest.then(function () {
			return platformEntryConfigurator.registerTFR(tfrUri);
		}));
		
		var trUri = baseURI + '/tr';
		var putTrRequest = $.ajax({type: 'PUT',
            url: trUri,
            headers: {'Content-Type': 'text/turtle'},
            data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
                    ' <http://www.w3.org/2000/01/rdf-schema#label> "Transformer Registry"@en ; ' +
                    ' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains Transformers"@en . ',
            async: true
        });
		
		registrations.push(putTrRequest.then(function () {
			return platformEntryConfigurator.registerTR(trUri);
		}));
		
		var dcrUri = baseURI + '/dcr';
		var putDcrRequest = $.ajax({type: 'PUT',
            url: dcrUri,
            headers: {'Content-Type': 'text/turtle'},
            data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
                    ' <http://www.w3.org/2000/01/rdf-schema#label> "Dashboard Config Registry"@en ; ' +
                    ' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains dashboard configurations"@en . ',
            async: true
        });
		
		registrations.push(putDcrRequest.then(function () {
			return platformEntryConfigurator.registerDCR(dcrUri);
		}));
		
		
		registrations.push(platformEntryConfigurator.registerSparql("http://"+host+":8181/sparql/select"));
		
		registrations.push(platformEntryConfigurator.registerLdpRoot("http://"+host+":8181/ldp/"));
		
		registrations.push(platformEntryConfigurator.registerDashboard("http://"+host+":8200/?platformURI="+window.location));
		registrations.push(platformEntryConfigurator.registerApplication("http://"+host+":8205/?platformURI="+window.location, 
				"P3 Resource GUI",
				"This is a graphical user interface to deal with Linked-Data-Platform-Collections."));
		
		/* Add later: registrations.push(platformEntryConfigurator.registerApplication("http://"+host+":8151/?transformer=http%3A%2F%2F"+host+"%3A8301%2F%3Ftaxonomy%3Dhttp%3A%2F%2Fdata.nytimes.com%2Fdescriptors.rdf&resource=http://www.bbc.com/news/science-environment-30005268", 
				"Transformer web client",
				"With the provided parameter it transforms the resource at <code>http://www.bbc.com/news/science-environment-30005268</code> using the transformer at <code>http://<span class="host"></span>:8301/?taxonomy=http%3A%2F%2Fdata.nytimes.com%2Fdescriptors.rdf</code>"));*/
	
		var platformPreparation = Promise.all(registrations);
		return platformPreparation.then(function() {
			return P3Platform.getPlatform(window.location).then(function(platform) {
				platform.transformerRegistry.registerTransformer("http://"+host+":8303/", "Any23 Transformer", "Transform data using Apache Any23");
				platform.transformerFactoryRegistry.registerTransformerFactory(
                        "http://"+host+":8201/?transformerBase=http://"+host+":8300&platformURI="+window.location, "Pipeline UI", "Allows to create pipeline transformers.");
                platform.transformerFactoryRegistry.registerTransformerFactory(
                        "http://"+host+":8202/?transformerBase=http://"+host+":8301&platformURI="+window.location, "Dictionary Matcher UI", "Allows to create dictionary matcher transformers.");
                platform.transformerFactoryRegistry.registerTransformerFactory(
                        "http://"+host+":8203/?transformerBase=http://"+host+":8310&platformURI="+window.location, "Batchrefine UI", "Allows to create transformers using Openrefine configurations.");
                platform.transformerFactoryRegistry.registerTransformerFactory(
                        "http://"+host+":8204/?transformerBase=http://"+host+":8307&platformURI="+window.location, "XSLT Transformer UI", "Allows to create XSLT transformers.");
			});
		});

	});
};