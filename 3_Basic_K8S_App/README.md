# Creating a basic application with Kubernetes

## Deploying apps on Kubernetes
In Kubernetes, the basic building blocks for our applications are called pods. Pods are the sammelst deployable unit. It is important to differentiate pods from containers though: a single pod can contain multiple containers. These containers will always be run at the same time on the same node. This is useful when we want to combine multiple components into a single piece.

![K8S Pod](img/pod.png?raw=true "K8S Pod")

Aside from one or more containers, pods can also include shared storage in the form of volumes. All the components of a pod will also share a single IP address and port space. We are going to start with a basic example that includes only a single container.

