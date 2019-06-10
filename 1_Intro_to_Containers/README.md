# Introduction to Containers

Containers have been a hot topic in the last few years. What are they though? Essentially, containers are a method of packaging everything that is required for an application into a single package, which can then be deployed. This means that a container will consist of application code, but it will also include dependencies used by the application. Similar to Virtual Machines, containers do provide some packaging, which makes it possible to move them from one environment to another.

## Application deployment methods
Compared to traditional application deployment methods, containers are also a lot faster. We can spin up a new container in seconds, which makes it possible to dynamically react to increased demand. Compare that to Virtual Machines, which can take minutes to start. The increased speed opens up many new options for administrators.

PIC

There is one more method, which we will not discuss in this training: FaaS, short for Function-as-a-Service. This deployment method allows us to run individual functions based on an incoming request. Each request would get its own function, which would typically be discarded after the request is finished. This makes it very easy to scale applications, but it also comes with its own downsides.

## Virtualization options
One big difference between Contaienrs and Virtual Machines is how the virtualization is achieved. A Virtual Machine will run on top of a hypervisor layer. Each Virtual Machine will then have its own operation system. Having one operating system per Virtual Machine will require a lot of additional resources. Containers do away with the hypervisor layer, and only use a single operating system per host. Virtualization is then done inside the operating system. Each application can still have its own bins/libs though, while sharing a common operating system.

PIC

## Working with containers

## Building your own container


## Container options
