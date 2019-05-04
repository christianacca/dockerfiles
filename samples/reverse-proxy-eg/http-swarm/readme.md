## Getting started

### Run sample

* `up.ps1`
* browse to app: http://whoami.docker.localhost:81/
* browse to traefik health endpoint: http://localhost:81/ping
* browse to traefic UI: http://traefik.docker.localhost:81/
    * username: docker
    * password: Pn7-x6C@4xvP9,g

To cleanup: `down.ps1`

## Network packet capture example

* Run a docker swarm service scaled to 2 replicas
* Use tcpdump to capture network trafic between traefik proxy container and the 2 replicas of whoami service
* Use tcpdump to capture network trafic received by the 2 replicas of whoami service
* Use tcpdump to capture network trafic for HttpClient making requests to the traefik proxy
* network packet capture saved to tests/dumps/ folder
* Use Wireshark to to inspect the network packets captured tests/dumps/

### Running capture

`tests/runs.ps1`

**Points of interest**
* Kestrel webserver is configured with a KeepAliveTimeout of 30 seconds
* Traefik respondingTimeouts.idleTimeout set to 10 seconds
* HttpClientFactory is managing the HttpClient and the lifetime of the underlying http connection

## Traefik load balance behaviour

* HttpClient maintains a connection to Traefik until Traefik closes connection
* HttpClient reuses existing connection to Traefik when making subsequent requests
* Traefik closes connection to HttpClient (sends a FIN-ACK to HttpClient) when connection between HttpClient and Traefik is idle longer that it's respondingTimeouts.idleTimeout setting
	* ie Traefik is in charge of the connection between HttpClient and itself
* Traefik will maintain a connection to backend container until Kestrel closes connection
	* the first request to Traefik will result in Traefik opening a connection to one of the backend containers
	* the second request (within the respondingTimeouts.idleTimeout setting) will result in Traefik opening a connect to another backend container
	* this occurs until there is an open connection for every container in the backend pool
* Kestrel will close connection to Traefik (sends a FIN-ACK to Traefik) when connection between Traefik and Kestrel is idle longer that it's KestrelServerLimits.KeepAliveTimeout setting
	* ie Kestrel is in charge of the connection between Traefik and itself
* Traefik will maintain a pool of open connections to backend containers to serve requests from *seperate* client connections to Traefik
	* **every** request is load balanced across this pool of open connections (round-robin the default strategy)
	* consequence: subsequent requests made over the *same* connection between HttpClient and Traefik WILL hit different containers ie keep-alive between HttpClient and Traefik cannot be relied upon as some kind of sticky session to the same server
	* consequence: load balancing over containers is broken when configuring Traefik to delegate load balancing to docker over service VIP
		* this is because Traefik maintains just one connection and docker only load balances between containers when a connection is first created
		* in effect ALL requests will be served from one container until that connection is closed due to inactivity
* subsequent requests to Traefik can be made sticky using a session cookie issued by Traefik:
	* this ensures requests made from different tcp connections to Traefik will hit the same container so long as those request have the session cookie
	* this is useful strategy for server-rendered html clients
	* this is a poor strategy for API clients which will not necessarily maintain the state of the cookie between seperate connections
	* note: it might be OK for a SPA client as it will using the browser built-in object (eg XHR and fetch) which will send cookies between seperate connections
	* todo: verify that the session cookie works across multiple instances of Traefik