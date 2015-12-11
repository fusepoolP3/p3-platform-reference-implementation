-- Assumes virtuoso.ini contains:
-- DefaultHost = fp3.myhost.com:8181

DB.DBA.USER_CREATE ('SPARQL_ADMIN', uuid());
DB.DBA.EXEC_STMT ('grant SPARQL_UPDATE to SPARQL_ADMIN', 0);
DB.DBA.RDF_DEFAULT_USER_PERMS_SET ('SPARQL_ADMIN', 15, 0);
DB.DBA.RDF_DEFAULT_USER_PERMS_SET ('SPARQL_ADMIN', 15, 1);

--
-- Set up LDP root folder for FP3 Platform
--
XML_SET_NS_DECL ('ldp','http://www.w3.org/ns/ldp#',2);
DB.DBA.DAV_COL_CREATE ('/DAV/home/fusepool/', '111111111R', 'dav','administrators', 'dav', 'dav');
DB.DBA.DAV_COL_CREATE ('/DAV/home/fusepool/ldp/', '111111111R', 'dav','administrators', 'dav', 'dav');
DB.DBA.DAV_PROP_SET ('/DAV/home/fusepool/ldp/', 'LDP', 'ldp:BasicContainer', 'dav','dav', 1);
TTLP ('@prefix ldp: <http://www.w3.org/ns/ldp#> .
<> a ldp:BasicContainer .', 'http://fp3.myhost.com:8181/DAV/home/fusepool/ldp/', 'http://fp3.myhost.com:8181/DAV/home/fusepool/ldp/');

DB.DBA.VHOST_REMOVE (
	 lhost=>'*ini*',
	 vhost=>'*ini*',
	 lpath=>'/DAV/home/fusepool/ldp');

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'*ini*',
	 lpath=>'/DAV/home/fusepool/ldp',
	 ppath=>'/DAV/home/fusepool/ldp/',
	 is_dav=>1,
	 def_page=>'',
	 is_brws=>1,
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('browse_sheet', '', 'cors', '*'),
	 is_default_host=>0
);

--
-- Enable CORs on /sparql endpoint
--
create procedure DB.DBA.SPARQL_VHOST_CORS_ENABLE()
{
  declare opts any;
  opts := (select deserialize(HP_OPTIONS) from DB.DBA.HTTP_PATH where HP_LPATH = '/sparql');
  opts := vector_concat (opts, vector ('cors', '*'));
  update DB.DBA.HTTP_PATH set HP_OPTIONS = serialize(opts) where HP_LPATH = '/sparql';
}
;

DB.DBA.SPARQL_VHOST_CORS_ENABLE();

DROP PROCEDURE DB.DBA.SPARQL_VHOST_CORS_ENABLE;

commit work;
