# IT process changes due to Kubernetes

As previously discussed, Kubernetes offers us virtualization, just like traditional Virtual Machines. There are some major differences in the architecture of Kubernetes compared to Virtual Machines though. Both developers and infrastructure owners can take advantage of these differences. If we look at some statistics, we can see that this is already happening. While the data below is not 100% representative of all Kubernetes users, it is a good start.

![Application Lifecycle](img/lifecycle.png?raw=true "Application Lifecycle")
<sub>Source: 2018, [Docker usage report](https://sysdig.com/blog/2018-docker-usage-report/ "Docker usage report")</sub>

AS you can see here, 95% of containers have a lifespan of less than a single week. This would be unthinkable in a VM world, where most workloads are running without changes for weeks, months, or potentially even years. The Kubernetes model is different, because we usually want to run multiple Pods, thus the death of a single Pod is not a big deal. This means that application developers can easily do application upgrades without causing downtime. This aligns very well with the continuing trend for faster release cycles.

Almost 70% of containers are updated every week, which goes to show that applications that are running on Kubernetes will likely take advantage of this model. This is not just beneficial to application developers though. It also offers new options for infrastructure teams. Because we have multiple copies of a Pod, it does not matter if one Pod dies. Thus, you could go ahead and just kill your Pods whenever you want, and Kubernetes will start a new copy of it. This can be useful for several reasons. For example, if a Pod runs into some kind of error after a certain amount of runtime, you can just kill it and start with a fresh copy. You could also kill Pods if you think that they are compromised, or even just on a regular basis to make it more difficult for attackers.

With Pods being re-started all the time, we can't communicate with individual Pods though, which is why Services are a very popular concept. Services tend to live more than a week, and they provide the long-term endpoint that other application components can communicate with. Usually you don't want to change Services too often, only the Deployments that are taking advantage of them.

This is just a short overview of how the Kubernetes world is different from the VM world. Let's have a look at how this can affect IT processes by looking at an example of how Kubernetes could be run in an organization.

![K8s process](img/process.png?raw=true "K8s process")

Developers will still be writing the code for applications, but we also need to create Kubernetes manifests that support these applications. This can be done by the K8s admin, by the developer, or by a combination of both. The code and the manifests can then be store in a repository (usually Git). This means that we can easily version the entire application, including the K8s components of it. If we want to jump back to a previous version we don't need to search for the K8s files and app files, because they are all together in a single location.

When we do a new commit to Git, our CI/CD tool can pick up those changes and trigger all necessary steps. This will likely include tests of the application code, but also building a container that can be deployed, and storing it in our local container registry. Finally, we can then deploy our application on a Kubernetes cluster for testing.

Once we are satisfied with our application, we can promote a specific version/branch of it to staging, and later on to production. This makes managing multiple releases relatively easy, because most parts of the process are automarted, and the developers only need to decice when they want to move an application version from one tier to the next.
