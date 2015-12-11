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

    P3BackendConfigurator.prototype.registerRegistries = function(ldpRoot) {
      var ldpBaseURI = ldpRoot.endsWith('/') ? ldpRoot : ldpRoot+'/';
      var self = this;
      var irldpcUri = ldpBaseURI + 'uir/';
      var putIrldpcRequest = $.ajax({type: 'PUT',
	url: irldpcUri,
	headers: {'Content-Type': 'text/turtle', 'Link': "<http://www.w3.org/ns/ldp#BasicContainer>; rel='type'"},
	data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
	      ' <http://www.w3.org/2000/01/rdf-schema#label> "Interaction Request Container"@en ; ' +
	      ' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains Interaction Requests"@en . ',
	async: true
      });

      var ldpDependetRegistrations = [];
      ldpDependetRegistrations.push(putIrldpcRequest.then(function () {
	return self.platformEntryConfigurator.registerIRLDPC(irldpcUri);
      }));

      var tfrUri = ldpBaseURI + 'tfr/';
      var putTfrRequest = $.ajax({type: 'PUT',
	url: tfrUri,
	  headers: {'Content-Type': 'text/turtle', 'Link': "<http://www.w3.org/ns/ldp#BasicContainer>; rel='type'"},
	  data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
		' <http://www.w3.org/2000/01/rdf-schema#label> "Transformer Factory Registry"@en ; ' +
		' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains Transformer Factories"@en . ',
	  async: true
      });

      ldpDependetRegistrations.push(putTfrRequest.then(function () {
	return self.platformEntryConfigurator.registerTFR(tfrUri);
      }));

	var trUri = ldpBaseURI + 'tr/';
	var putTrRequest = $.ajax({type: 'PUT',
	  url: trUri,
	  headers: {'Content-Type': 'text/turtle', 'Link': "<http://www.w3.org/ns/ldp#BasicContainer>; rel='type'"},
	  data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
		' <http://www.w3.org/2000/01/rdf-schema#label> "Transformer Registry"@en ; ' +
		' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains Transformers"@en . ',
	  async: true
	});

	ldpDependetRegistrations.push(putTrRequest.then(function () {
	    return self.platformEntryConfigurator.registerTR(trUri);
	}));

	var dcrUri = ldpBaseURI + 'dcr/';
	var putDcrRequest = $.ajax({type: 'PUT',
	  url: dcrUri,
	  headers: {'Content-Type': 'text/turtle', 'Link': "<http://www.w3.org/ns/ldp#BasicContainer>; rel='type'"},
	  data: '<> a <http://www.w3.org/ns/ldp#BasicContainer> ; ' +
		' <http://www.w3.org/2000/01/rdf-schema#label> "Dashboard Config Registry"@en ; ' +
		' <http://www.w3.org/2000/01/rdf-schema#comment> "Contains dashboard configurations"@en . ',
	  async: true
	});

	ldpDependetRegistrations.push(putDcrRequest.then(function () {
	  return self.platformEntryConfigurator.registerDCR(dcrUri);
	}));

	return Promise.all(ldpDependetRegistrations).catch( function(error) {
	  if (error.status === 428) {
	    // we assume the precondition failed because it's alrteady there and do nothing
	  } else {
	    throw error;
	  }
	});
    };

})();
