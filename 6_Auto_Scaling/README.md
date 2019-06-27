# Auto-scaling applications

You should have a basic understanding of deploying (Pod), scaling (ReplicaSet), and exposing (Service) applications now.
 now. Our current way of scaling with ReplicaSets has one major issue though: we always need to scale based on the maximum demand. Let's think about this with an example. We might have an application that is used by our employees when they log into their workstation. Thus, the application would likely experience a lot of traffic in the morning, and around lunch time. During the rest of the day, we are likely going to receive relatively few requests. We would still have to provide enough pods to handle the spikes though.

This means that for the majority of the time, we are running a lot more pods than would be needed. To accomodate for changes in demand, Kubernetes offers autoscaling capabilities. This can save us a lot of money, especially if we are running in a cloud environment.

How do we create this feature in our Kubernetes environment? ReplicaSets already provide the scaling capabilities that we need, but they do not automatically scale based on demand. To achieve that, we will need an additional element, the so-called 'Horizontal Pod Autoscaler'. This element basically controls the amount of replicas a ReplicaSet should produce.

![Auto-scaling](img/autoscaler.png?raw=true "Auto-scaling")

We can scale our pods based on different metrics, such as CPU or memory. For example, let's imagine that we would like our pods to use 100m CPU on average. If they are using 200m CPU on average, this would mean that we are double the desired metric. Thus, the Horizontal Pod Autoscaler would double the amount of copies that the ReplicaSet should produce.

One small note regarding CPU and memory metrics in Kubernetes. CPUs resources are measured in cpu units, which would correspond to one Hyperthread on a bare metal server, though the exact measurement varies between environments. 100m would correspond to 0.1 cpu units. Memory is measured in bytes.

We could then just scale the application depending on the requests that are coming in. This could be quite dangerous though, both due to application errors, as well as due to possible attacks. If our autoscaling had no limit, Kubernetes would continue creating more and more pods. In a private data center, this would simply mean that we might run out of other compute resources. In a public cloud, this could result in a huge bill. Luckily, the Horizontal Pod Autoscaler also allows us to set minimum and maximum values for the amount of copies. The minimum copies should be able to deal with sudden spikes in demand, before new pods can be spun up, and the maximum copies assure us that we are never going to spin up too many copies.

Now that we have talked about how autoscaling works, let's look at an example:

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

As you can see here, we have introduced a new element, aside from the Pod and the ReplicaSet. The HorizontalPodAutoscaler element allows us to change the scale number in a different element, in this case a ReplicaSet. As mentioned above, we can specify a minimum amount of copies (minReplicas), as well as a maximum amount of copies (maxReplicas). To change the scale, we can specify metrics. In our case, we want to create a new copy if the average CPU utilization is larger than 50%.

Let's roll this example out, by executing the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f autoscale.yml
```







add resource limits to the pod

![Challenge 4](img/challenge4.png?raw=true "Challenge 4")
[Click here for the solution](./solutions/challenge4 "Click here for the solution")

![Challenge 5](img/challenge5.png?raw=true "Challenge 5")
[Click here for the solution](./solutions/challenge5 "Click here for the solution")
