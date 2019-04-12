## Network packet capture example

* Run a docker swarm service scaled to 2 replicas
* Use tcpdump to capture network trafic between docker service load balancer and the the 2 replicas
* Use tcpdump to capture network trafic for HttpClient making requests to the docker service
* network packet capture saved to tests/dumps/ folder
* Use Wireshark to to inspect the network packets captured tests/dumps/

### Running capture

`tests/runs.ps1`

**Points of interest**
* Kestrel webserver is configured with a KeepAliveTimeout of 20 seconds
* HttpClientFactory is managing the HttpClient and the lifetime of the underlying http connection

**Observations**

* Kestrel issues a FIN-ACK after TCP connection remains idle after 20 seconds
* Subsequent requests from the HttpClient on the same TCP connection/session are NOT load balanced over containers making up a service
    * in other words docker will NOT load balance http requests to a service VIP on the same TCP connection
* HttpClient reuses existing connection
* HttpClient does NOT reuse existing connection once connection closed
    * observed that after a FIN-ACK sent from server, that connection is NOT reused
    * on a subsequent request, HttpClient will create a new connection (issue a SYN request)
* HttpClient sends a FIN-ACK on any connection that is still open when client app closes
