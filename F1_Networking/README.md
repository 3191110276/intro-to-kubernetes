# Kubernetes networking

In all of our previous chapters, we let our Pods talk with each other, and with the outside world, and networking just worked. That is not a feature of Kubernetes though. Setting up networking for Kubernetes from scratch is actually quite challenging. In this chapter, we will be looking at how networking works for Kubernetes, and what we can configure.

There are four basic types of network communication that Kubernetes has to deal with. We can see all of them in the picture below.

![Communication Patterns](img/communication_patterns.png?raw=true "Communication Patterns")

As you already know, one Pod can consist of multiple Containers. Communication between them can just happen on a localhost basis, and there is nothing we have to worry about. If we want to communicate from one Pod to another Pod, we need to somehow provide the connectivity though. More on that below.

Finally, the last two types of communication are Pod to Service and Service to External communication. Both of these are Kubernetes-native concepts, which we already explored in previous chapters. There is nothing else we have to configure to make them work.

This means that the only thing left to discuss is Pod to Pod communication. There is no Kubernetes-native way to handle this, thus we need to provide this ourselves. There are many networking plugins out there though, which make this job much easier. Due to the large amount of plugins, and the constantly changing ecosystem, it is difficult to provide a list of all plugins. See below for some popular choices.

![Networking plugins](img/network_plugins.png?raw=true "Networking plugins")

The job of a networking plugin is always going to be the same though. They have to provide connectivity between all the Pods in Kubernetes, independent of which Node they are connected to. All networking plugins follow two basic rules:
* Pods on a Node can communicate with all Pods on all Nodes without NAT
* Agents on a Node (for example system deamons) can communicate with all Pods on that Node

There is, of course, much more to this topic, and we could look at packet walks inside the Kubernetes world. For now, this basic level of knowledge will be enough for you though. We will be exploring on example networking plugin in the next chapter to get some hands-on.
