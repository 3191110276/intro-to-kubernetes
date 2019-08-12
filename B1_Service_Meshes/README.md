# Basics of Service Meshes

Kubernetes is very leightweight and allows us to run many more workloads per host, compared to Virtual Machines. This makes it ideal for microservices, which might consist of 100s or 1000s of components. In a traditional world, we might have had a single large application, which manages all processes inside a single VM. In a microservice, the same application might consist of many different Pods and Services. This has many advantages from a development and maintenance point of view, but we also run into some challenges.

An end user of the application should not notice any difference between a monolithic application, and a microservice-based application. Service Meshes help us with creating a coherent application, out of many individual components. There are many different Service Meshes out there, but let's look at some features that they usually have.

![Service Meshes](img/service_meshes.png?raw=true "Service Meshes")



![Options](img/options.png?raw=true "Options")

![Istio](img/istio.png?raw=true "Istio")
