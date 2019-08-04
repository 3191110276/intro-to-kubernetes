# Kubernetes networking

In all of our previous chapters, we let our Pods talk with each other, and with the outside world, and networking just worked. That is not a feature of Kubernetes though. Setting up networking for Kubernetes from scratch is actually quite challenging. In this chapter, we will be looking at how networking works for Kubernetes, and what we can configure.

There are four basic types of network communication that Kubernetes has to deal with. We can see all of them in the picture below.

![Communication Patterns](img/communication_patterns.png?raw=true "Communication Patterns")

As you already know, one Pod can consist of multiple Containers. Communication between them can just happen on a localhost basis, and there is nothing we have to worry about. If we want to communicate from one Pod to another Pod, we need to somehow provide the connectivity though. This is not something provided by Kubernetes natively, which is why we will be using a networking plugin. More on that below.

Finally, the last two types of communication are Pod to Service and Service to External communication. Both of these are Kubernetes-native concepts, which we already explored in previous chapters. There is nothing else we have to configure to make them work.



![Networking plugins](img/network_plugins.png?raw=true "Networking plugins")
