# Basics of Service Meshes

Kubernetes is very leightweight and allows us to run many more workloads per host, compared to Virtual Machines. This makes it ideal for microservices, which might consist of 100s or 1000s of components. In a traditional world, we might have had a single large application, which manages all processes inside a single VM. In a microservice, the same application might consist of many different Pods and Services. This has many advantages from a development and maintenance point of view, but we also run into some challenges.

An end user of the application should not notice any difference between a monolithic application, and a microservice-based application. Service Meshes help us with creating a coherent application, out of many individual components. There are many different Service Meshes out there. The features below are some common examples, but they might not be present in every Service Mesh.

![Service Meshes](img/service_meshes.png?raw=true "Service Meshes")

Lod balancing between for a specific tier in the application is a very interesting feature. This does not necessarily mean balancing traffic between individual Pods, but rather balancing traffic between different Services. We could have two (or more) versions of a Service, and then forward users based on some criteria. One interesting example would be application upgrades. We can have both the old and new version of a Service running in parallel, and we can then gradually shift the traffic from one Service to the other.

In a microservice, different parts of an application might be on different servers. If this is a critical application, we want to make sure that the communication is secured, and that the Service can only be used by specific other application components. This is why authentication and encryption can be useful to have in a Service Mesh. They basically replicate the single logical unit of a monolith in terms of security.

Security is not the only concern though. We also want to make sure that our application is reliable. A Service might experience a temporary failure on a single Pod, but if we can do a retry, we can continue with the execution, without having to handle this failure somewhere in the application.

Circuit Breaker

![Options](img/options.png?raw=true "Options")

![Istio](img/istio.png?raw=true "Istio")
