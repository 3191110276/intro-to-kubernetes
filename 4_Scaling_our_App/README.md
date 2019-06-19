# Scaling our application

In the previous chapter we already learned how we can create a simple application via the pod construct in Kubernetes. If we want to scale an application in a VM-based environment, we might want to scale up our VM by adding some additional CPU and memory. In the Kubernetes world, many applications are architected to scale out, thus we would want to add more pods.

This is someting that we likely do not want to take care of manually, as this might mean that we need to spin up 10 copies of a pod one by one. Luckily, Kubernetes offers a very powerful element for handling the creation of multiple pods, called ReplicaSets.

![K8S ReplicaSets](img/replicaset.png?raw=true "K8S ReplicaSets")












Folders:
code
solutions
