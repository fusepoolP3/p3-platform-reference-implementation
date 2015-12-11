#Virtuoso Database Initialization for the FP3 Platform

When using Virtuoso as an LDP backend for the the FP3 Platform, the Virtuoso database must be preconfigured before the platform itself is initialized. 

The database and LDP root folder must both be created, and CORS enabled on the LDP root and /sparql endpoint. It is not possible to do this as part of the platform initialization.

These notes detail the required preconfiguration steps.

## Preconfiguration 
Pull the VOS (Virtuoso Open Source Edition) Docker image from the Docker registry.

 * `docker pull openlink/virtuoso_opensource:vos`
 
The image is configured to host the database in the host file system. The database location on the host should reflect the installation directory assumed by the image. 

Create directory /opt/virtuoso-opensource/var/lib/virtuoso/db in the host file system and copy in the provided template configuration file virtuoso.fp3_template.ini.

* `sudo mkdir -p /opt/virtuoso-opensource/var/lib/virtuoso/db`
* `sudo cp ./virtuoso.fp3_template.ini /opt/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini`
* `sudo chmod a+w /opt/virtuoso-opensource/var/lib/virtuoso/db`

Edit the virtuoso.ini file, setting the DefaultHost hostname appropriately, similar to the example extract below. The DefaultHost port must be 8181. This is required to ensure that null relative LDP URIs, when expanded, use the FP3 Transforming Proxy as the authority, rather than the LDP server host.

    [URIQA]
    DynamicLocal = 0
    ;DefaultHost  = fp3.myhost.com:8890
    ; DefaultHost must match the FP3 Proxy host/port 
    ; so null relative LDP URIs when expanded are rooted 
    ; to the proxy not the LDP server host.
    DefaultHost  = fp3.myhost.com:8181`

Launch the VOS Docker image

* `docker run --name vos -d -v /opt/virtuoso-opensource/var/lib/virtuoso/db:/opt/virtuoso-opensource/var/lib/virtuoso/db -p 1111:1111 -p 8890:8890 openlink/virtuoso_opensource:vos`

VOS will create a new database when started for the first time.

A Virtuoso/PL script is needed to create the LDP root directory and enable CORS:

* Edit p3_vos_setup.template.sql, replacing fp3.myhost.com with the correct hostname.
* Login to Virtuoso's Conductor UI via http://fp3.myhost.com:8890 (Default username and password: 'dba', 'dba') then paste in and execute the above script in Conductor's isql console.

Shutdown and remove the VOS container:

* `docker kill vos`
* `docker rm vos`

The required one-time initialization of Virtuoso for FP3 should now be complete, ready for launching the FP3 Platform.  

