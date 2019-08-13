# IT process changes due to Kubernetes

As previously discussed, Kubernetes offers us virtualization, just like traditional Virtual Machines. There are some major differences in the architecture of Kubernetes compared to Virtual Machines though. Both developers and infrastructure owners can take advantage of these differences. If we look at some statistics, we can see that this is already happening. While the data below is not 100% representative of all Kubernetes users, it is a good start.

![Application Lifecycle](img/lifecycle.png?raw=true "Application Lifecycle")
<sub>Source: 2018, [Docker usage report](https://sysdig.com/blog/2018-docker-usage-report/ "Docker usage report")</sub>

AS you can see here, 95% of containers have a lifespan of less than a single week. This would be unthinkable in a VM world, where most workloads are running without changes for weeks, months, or potentially even years. The Kubernetes model is different, because we usually want to run multiple Pods, thus the death of a single Pod is not a big deal. This means that application developers can easily do application upgrades without causing downtime. This aligns very well with the continuing trend for faster release cycles.

Almost 70% of containers are updated every week, which goes to show that applications that are running on Kubernetes will likely take advantage of this model. This is not just beneficial to application developers though. It also offers new options for infrastructure teams. Because we have multiple copies of a Pod, it does not matter if one Pod dies. Thus, you could go ahead and just kill your Pods whenever you want, and Kubernetes will start a new copy of it. This can be useful for several reasons. For example, if a Pod runs into some kind of error after a certain amount of runtime, you can just kill it and start with a fresh copy. You could also kill Pods if you think that they are compromised, or even just on a regular basis to make it more difficult for attackers.

With Pods being re-started all the time, we can't communicate with individual Pods though, which is why Services are a very popular concept. Services tend to live more than a week, and they provide the long-term endpoint that other application components can communicate with. Usually you don't want to change Services too often, only the Deployments that are taking advantage of them.

