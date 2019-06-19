# Scaling our application

In the previous chapter we already learned how we can create a simple application via the pod construct in Kubernetes. If we want to scale an application in a VM-based environment, we might want to scale up our VM by adding some additional CPU and memory. In the Kubernetes world, many applications are architected to scale out, thus we would want to add more pods.

This is someting that we likely do not want to take care of manually, as this might mean that we need to spin up 10 copies of a pod one by one. Luckily, Kubernetes offers a very powerful element for handling the creation of multiple pods, called ReplicaSet.

Essentially, ReplicaSets wrap around a pod definition, and define how many copies of a pod definition we would like to see. The ReplicaSet then takes care of spinning up the desired amount of copies. If we increase or decrease the number of desired pods, the ReplicaSet will take care of creating new copies, or deleting surplus copies.

It gets even better: the ReplicaSet constantly monitors the pods that belong to it. If a pod should vanish for any reason whatsoever, the ReplicaSet will take care of spinning up a new copy. For example, if a node fails during the middle of the night, the ReplicaSet will simply create a new copy of the pod on another node.

![K8S ReplicaSet](img/replicaset.png?raw=true "K8S ReplicaSet")

Let's have a look at the definition of the ReplicaSet. As you can see, the 'kind' property in the yaml file is now changed to 'ReplicaSet', and the spec section now contains the definition of the ReplicaSet. The definition of the pod itself is now located in 'spec/template'. You will notice that the pod definition itself has not changed though. We are still providing the same information, but we have now encapsulated all of that in the ReplicaSet element.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
   name: rs-hello-cisco
spec:
   replicas: 2
   selector:
      matchLabels:
         app: hello-cisco
   template:
      metadata:
         labels:
            app: hello-cisco
      spec:
         containers:
         - name: hello-cisco
           image: mimaurer/hello-cisco:v1
           ports:
           - containerPort: 5000
```

Let's have a closer look at the ReplicaSet before applying this yaml file to our cluster. You will notice that the 'spec' section contains two new values: 'replicas' and 'selector'. The 'replicas' property simply represents the amount of copies that should be created.

The 'selector' property is a bit more complex. Here we define what kind of label the ReplicaSet should be looking for on the pods. The labels in the 'spec/selector' property need to match the labels in 'spec/template/metadata'. If there are not enough pods with a matching label, the ReplicaSet will create new copies. If there are too many pods with a matching label, the ReplicaSet will delete some of them.

This feature of the ReplicaSet has some consequences that we should be ware of. A ReplicaSet can adopt existing pods, if they have the correct label. If we remove the specific label from a pod, the ReplicaSet can no longer find the pod, and it will create a new copy.

Let's have a look at all of this in practice by creating our first ReplicaSet by running the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f rs.yml
```





kubectl get rs/rs-hello-cisco

kubectl get pods –-show-labels

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")


![Desired state](img/desired_state.png?raw=true "Desired state")

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")
[Click here for the solution](./solutions/challenge2 "Click here for the solution")

![Challenge 3](img/challenge3.png?raw=true "Challenge 3")
[Click here for the solution](./solutions/challenge3 "Click here for the solution")

![Auto-scaling](img/autoscaler.png?raw=true "Auto-scaling")

![Challenge 4](img/challenge4.png?raw=true "Challenge 4")
[Click here for the solution](./solutions/challenge4 "Click here for the solution")

![Challenge 5](img/challenge5.png?raw=true "Challenge 5")
[Click here for the solution](./solutions/challenge5 "Click here for the solution")
