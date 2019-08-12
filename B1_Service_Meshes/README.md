# Basics of Service Meshes

Kubernetes is very leightweight and allows us to run many more workloads per host, compared to Virtual Machines. This makes it ideal for microservices, which might consist of 100s or 1000s of components. In a traditional world, we might have had a single large application, which manages all processes inside a single VM. In a microservice, the same application might consist of many different Pods and Services. This has many advantages from a development and maintenance point of view, but we also run into some challenges.

An end user of the application should not notice any difference between a monolithic application, and a microservice-based application. Service Meshes help us with creating a coherent application, out of many individual components. There are many different Service Meshes out there. The features below are some interesting examples, but they might not be present in every Service Mesh.

![Service Meshes](img/service_meshes.png?raw=true "Service Meshes")

Lod balancing between for a specific tier in the application is a very interesting feature. This does not necessarily mean balancing traffic between individual Pods, but rather balancing traffic between different Services. We could have two (or more) versions of a Service, and then forward users based on some criteria. One interesting example would be application upgrades. We can have both the old and new version of a Service running in parallel, and we can then gradually shift the traffic from one Service to the other.

In a microservice, different parts of an application might be on different servers. If this is a critical application, we want to make sure that the communication is secured, and that the Service can only be used by specific other application components. This is why authentication and encryption can be useful to have in a Service Mesh. They basically replicate the single logical unit of a monolith in terms of security.

Security is not the only concern though. We also want to make sure that our application is reliable. A Service might experience a temporary failure on a single Pod, but if we can do a retry, we can continue with the execution, without having to handle this failure somewhere in the application.

At some point we will experience applicatin failures that we can't simply recover from though. How will we handle those? Service Meshes can use circuit breakers to automatically close the connection to Pods that are experiencing issues. Thus, only healthy Pods will be serving requests, which should improve the overall application health.

These are only some of the featues that a Service Mesh might have. On top of that, Service Meshes will usually also offer metrics and tracing for all of the requests flowing through it. All of this is achieved through some form of control plane, and usually a sidecar proxy that handles the forwarding of requests. We will look at this in more detail with a specific Service Mesh example later on.

There are many choices for Service Meshes out there today. Below, you can find some popular options, but this is not a comprehensive list.

![Options](img/options.png?raw=true "Options")

Out of all of these options, Istio is the most popular Service Mesh today. Thus, our focus will be on this project, but you can also look at any of the other Service Meshes, if they offer features that are interesting for you.

![Istio](img/istio.png?raw=true "Istio")

Istio basically consists of two components. First, the data plane, which is based on proxy containers (Envoy) that are deployed alongside the primary application Pod. This pattern is known as sidecar. The proxies then take care of all the network communication for the main container. Mixer then takes care of access control for all of these communications, as well as providing telemetry. The second part of Istio is the control plane, which manages and configure thes proxies to route the traffic, and it also configures Mixer to enforce policies and collect telemetry.

The three components of the control plane are Pilot, Citadel, and Galley. Pilot takes care of service discovery and all routing decisions, which includes things like retries and circuit breakers. The high level rules are converted to something that the Envoy proxies can use. Citadel is responsible for the authentication and identities. Finally, Galley is Istio's configuration validation, ingestion, processing, and distribution component. It abstracts the details of obtaining user configuration from the underlying platform (Kubernetes).
