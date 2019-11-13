# Review: Putting it all together

We have covered many Kubernetes concepts in the chapters so far. Before we continue, let's have a short look at what we did so far.

![Review](img/review.png?raw=true "Review")

We started out with the creation of simple Pods to host our Containers. Each Pod can host one or more containers, even though we haven't used the capability of hosting multiple containers in a Pod yet. On its own, a Pod is not particularily useful though.

We wanted to scale our application, to handle higher demand. Thus, we added ReplicaSets, which are tasked with creating a specific amount of copies from a Pod template. To support this, we added Labels to our Pods. The ReplicaSet constently checks if there are enough Pods with the correct Label. If there are not enough Pods, or if there are too many Pods, the ReplicaSet will increase or decrease the number of Pods respectively. This also means that the ReplicaSet can start a new Pod, in case one dies.

To enable application upgrades, we added Deployments on top of ReplicaSets. This allows us to switch from one ReplicaSet version to another version, and back, without having to deal with the underlying process. What we haven't mentioned in this chart is the ability to perform auto-scaling on the Deployment and ReplicaSet.

With all of these components in place, we have made our application easy to manage, while also providing the necessary scalability and resiliency. We have multiple Pods now though, and we want a way to simply access them as a group, instead of having to deal with individual IP addresses. Services provide that capability. We can have a single address which can be used by other applications, or external users to access the Pods.

Services are already quite capable, but to improve things for end users, we add an Ingress in front of our Kubernetes cluster to provide loadbalancing, as well as some other services such as TLS for our application.

With an understanding of all of these components, we can create applications on Kubernetes. There are more concepts to learn, which we will go into in the following chapters, but all of them build on top of these basic constructs.
