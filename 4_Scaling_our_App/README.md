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

Let's have a look at the ReplicaSet we just created:

```
kubectl get ReplicaSet
```

This command provides us the list of all ReplicaSets that are currently created. We can also see information about how many pods there should be created (desired), as well as how many pods there are right now (current). If we had many ReplicaSets, we could also look for the specific ReplicaSet we want through the following command:

```
kubectl get rs/rs-hello-cisco
```

ReplicaSet is shortened to 'rs', and we then add the name of the ReplicaSet to query for the specific element. One more thing: we mentioned before that the ReplicaSet selects the pods based on the label. So, let's have a look at the pods, as well as the labels that are applied to them:

```
kubectl get pods --show-labels
```

We can see that the name of the pod has been derived from the name of the ReplicaSet. Additionally, we can also see the label that has been applied to the pod, and we can thus confirm that it matches the label in our ReplicaSet definition.

Now that we went through the basics of ReplicaSets, it's time for you to have a look at this yourself in the following challenge.

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

In the challenge, we just saw how the ReplicaSet reacts to changes in the number of running pods. The underlying concept is referred to as the desired state. The desired state simply means the number of pods that we want to have running at the same time. If we change the number of replicas in our definition, the number of desired pods will change, and thus the ReplicaSet will apply changes to bring the current state in line with the desired state.

![Desired state](img/desired_state.png?raw=true "Desired state")

Let's put our knowledge to the test with some more challenges.

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")
[Click here for the solution](./solutions/challenge2 "Click here for the solution")

![Challenge 3](img/challenge3.png?raw=true "Challenge 3")
[Click here for the solution](./solutions/challenge3 "Click here for the solution")

You should have a basic understanding of ReplicaSets now. Our ReplicaSets have one major issue so far though: we always need to scale them based on the maximum demand. Let's think about this with an example. We might have an application that is used by our employees when they log into their workstation. Thus, the application would likely experience a lot of traffic in the morning, and around lunch time. During the rest of the day, we are likely going to receive relatively few requests. We would still have to provide enough pods to handle the spikes though.

This means that for the majority of the time, we are running a lot more pods than would be needed. To accomodate for changes in demand, Kubernetes offers autoscaling capabilities. This can save us a lot of money, especially if we are running in a cloud environment.

How do we create this feature in our Kubernetes environment? ReplicaSets already provide the scaling capabilities that we need, but they do not automatically scale based on demand. To achieve that, we will need an additional element, the so-called 'Horizontal Pod Autoscaler'. This element basically controls the amount of replicas a ReplicaSet should produce.

![Auto-scaling](img/autoscaler.png?raw=true "Auto-scaling")

We can scale our pods based on different metrics, such as CPU or memory. For example, let's imagine that we would like our pods to use 100m CPU on average. If they are using 200m CPU on average, this would mean that we are double the desired metric. Thus, the Horizontal Pod Autoscaler would double the amount of copies that the ReplicaSet should produce.

One small note regarding CPU and memory metrics in Kubernetes. CPUs resources are measured in cpu units, which would correspond to one Hyperthread on a bare metal server, though the exact measurement varies between environments. 100m would correspond to 0.1 cpu units. Memory is measured in bytes.

This could be quite dangerous, both due to application errors, as well as due to possible attacks. If our autoscaling had no limit, Kubernetes would continue creating more and more pods. In a private data center, this would simply mean that we might run out of other compute resources. In a public cloud, this could result in a huge bill. Luckily, the Horizontal Pod Autoscaler also allows us to set minimum and maximum values for the amount of copies. The minimum copies should be able to deal with sudden spikes in demand, before new pods can be spun up, and the maximum copies assure us that we are never going to spin up too many copies.

Now that we have talked about how autoscaling works, let's look at an example for our ReplicaSet:

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
   name: scaling-hello-cisco
spec:
   scaleTargetRef:
      apiVersion: apps/v1
      kind: ReplicaSet
      name: rs-hello-cisco
   minReplicas: 1
   maxReplicas: 10
   metrics:
   - type: Resource
     resource:
        name: cpu
        target:
           type: Utilization
           averageUtilization: 50
```

As you can see here, we have introduced a new element, aside from the Pod and the ReplicaSet.






![Challenge 4](img/challenge4.png?raw=true "Challenge 4")
[Click here for the solution](./solutions/challenge4 "Click here for the solution")

![Challenge 5](img/challenge5.png?raw=true "Challenge 5")
[Click here for the solution](./solutions/challenge5 "Click here for the solution")
