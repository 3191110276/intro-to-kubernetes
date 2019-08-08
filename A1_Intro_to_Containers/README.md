# Introduction to Containers

Containers have been a hot topic in the last few years. What are they though? Essentially, containers are a method of packaging everything that is required for an application into a single package, which can then be deployed. This means that a container will consist of application code, but it will also include dependencies used by the application. Similar to Virtual Machines, containers do provide some packaging, which makes it possible to move them from one environment to another.

## Application deployment methods
Compared to traditional application deployment methods, containers are also a lot faster. We can spin up a new container in seconds, which makes it possible to dynamically react to increased demand. Compare that to Virtual Machines, which can take minutes to start. The increased speed opens up many new options for administrators.

![Deployment methods overview](img/deployment_methods.png?raw=true "Deployment methods overview")

There is one more method, which we will not discuss in this training: FaaS, short for Function-as-a-Service. This deployment method allows us to run individual functions based on an incoming request. Each request would get its own function, which would typically be discarded after the request is finished. This makes it very easy to scale applications, but it also comes with its own downsides.

## Virtualization options
One big difference between Contaienrs and Virtual Machines is how the virtualization is achieved. A Virtual Machine will run on top of a hypervisor layer. Each Virtual Machine will then have its own operation system. Having one operating system per Virtual Machine will require a lot of additional resources. Containers do away with the hypervisor layer, and only use a single operating system per host. Virtualization is then done inside the operating system. Each application can still have its own bins/libs though, while sharing a common operating system.

![Virtualization options](img/virtualization_options.png?raw=true "Virtualization options")

## Working with containers
As mentioned before, containers include all required application components. To achieve this, containers are built out of different layers. Additional layers are then added on top of this base layer, until all needed components are packaged into the application. There are many publically available images for these base layers, but we can also build our own. Building our own base image would enable us to package all of our usual application components, which means that we do not have to specify them for each individual application.

The layers of the container are then based on Linux commands, as well as some container-specific commands. As an example, we might first install Python, followed by upgrading pip (a Python package manager), which we then use to install all dependencies for our application. In a final step, we can then copy our own application code into the container.

![Docker build process](img/docker_build.png?raw=true "Docker build process")

These application layers, and thus the individual build steps, are specified in a so-called Dockerfile (when using Docker). Below, we can see one example of how this might look like for the application described above. We start from a base image using the popular Alpine Linux, and then add new layers step by step.

![Dockerfile](img/dockerfile.png?raw=true "Dockerfile")

You can have a look at the Dockerfile in the [/code](code/ "/code") folder. To build a container image from the file, execute the following command inside the folder that contains the Dockerfile:
~~~~
docker build -t hello-cisco .
~~~~

Now that the images is created, we can run it to get a working container. In our case, we are running a web server on port 5000 inside the container. We might want to run multiple applications, potentially even multiple of the same application though, thus we can't guarantee that port 5000 will be available on our host. This means that we will map the port inside the container to a unique external port. 

![Docker execution](img/docker_run.png?raw=true "Docker execution")

To start the container, and to perform the mapping, we can run the following command:
~~~~
docker run -p 4674:5000 hello-cisco
~~~~

Now the container is up and running, and the webserver inside the container can serve requests on port 4674. You can access the web application on 0.0.0.0:4674/index.html. Keep the challenge of managing ports in mind, as this is one of the reasons why containers are usually run with an orchestration system.

## Container options
The example above is based on Docker containers specifically, but Docker is not hte only option for containers. In fact, it has been losing in popularity recently. It is still the most popular container option, by far. While it is not possible to get completely accurate numbers, a large majority of containers are still based on Docker. The remaining parts of this training will be based on Docker, and most of the training applies equally to other container options.

![Container options](img/container_options.png?raw=true "Container options")
<sub>Source: 2018, [Docker usage report](https://sysdig.com/blog/2018-docker-usage-report/ "Docker usage report")</sub>
