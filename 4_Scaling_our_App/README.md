# Scaling our application

In the previous chapter we already learned how we can create a simple application via the pod construct in Kubernetes. If we want to scale an application in a VM-based environment, we might want to scale up our VM by adding some additional CPU and memory. In the Kubernetes world, many applications are architected to scale out, thus we would want to add more pods.

This is someting that we likely do not want to take care of manually, as this might mean that we need to spin up 10 copies of a pod one by one. Luckily, Kubernetes offers a very powerful element for handling the creation of multiple pods, called ReplicaSet.

Essentially, ReplicaSets wrap around a pod definition, and define how many copies of a pod definition we would like to see. The ReplicaSet then takes care of spinning up the desired amount of copies. If we increase or decrease the number of desired pods, the ReplicaSet will take care of creating new copies, or deleting surplus copies.

![K8S ReplicaSet](img/replicaset.png?raw=true "K8S ReplicaSet")







It gets even better: the ReplicaSet constantly monitors the pods that belong to it. If a pod should vanish for any reason whatsoever, the ReplicaSet will take care of spinning up a new copy. For example, if a node fails during the middle of the night, the ReplicaSet will simply create a new copy of the pod on another node.








Folders:
code
solutions
