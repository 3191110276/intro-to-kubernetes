# Auto-scaling applications

You should have a basic understanding of deploying (Pod), scaling (ReplicaSet), and exposing (Service) applications now.
 now. Our current way of scaling with ReplicaSets has one major issue though: we always need to scale based on the maximum demand. Let's think about this with an example. We might have an application that is used by our employees when they log into their workstation. Thus, the application would likely experience a lot of traffic in the morning, and around lunch time. During the rest of the day, we are likely going to receive relatively few requests. We would still have to provide enough pods to handle the spikes though.

This means that for the majority of the time, we are running a lot more pods than would be needed. To accomodate for changes in demand, Kubernetes offers autoscaling capabilities. This can save us a lot of money, especially if we are running in a cloud environment.

How do we create this feature in our Kubernetes environment? ReplicaSets already provide the scaling capabilities that we need, but they do not automatically scale based on demand. To achieve that, we will need an additional element, the so-called 'Horizontal Pod Autoscaler'. This element basically controls the amount of replicas a ReplicaSet should produce.

![Auto-scaling](img/autoscaler.png?raw=true "Auto-scaling")

We can scale our pods based on different metrics, such as CPU or memory, among others. For example, let's imagine that we would like our pods to use 100m CPU on average. If they are using 200m CPU on average, this would mean that we are double the desired metric. Thus, the Horizontal Pod Autoscaler would double the amount of copies that the ReplicaSet should produce.

We just mentioned 100m and 200m CPU, what does that mean though? Let's have a quick look at how CPU and memory are measured in Kubernetes. CPUs resources are measured in cpu units, which would correspond to one Hyperthread on a bare metal server, though the exact measurement varies between environments. 100m would correspond to 0.1 cpu units. Memory is measured in bytes.

Before we get started with deploying autoscaling, we first need to have metrics for deciding what to do. By default, Kubernetes will not collect these metrics though, thus we will need to set up a metrics server. This is quite a simple process. All the necessary yaml files for the rollout are prepared in the [/code/metrics-server](code/metrics-server "/code/metrics-server") folder. You can have a look at the individual files, but we are just going to apply all yaml files by ececuting the following command from within the [/code](code/ "/code") folder:
 
```
kubectl apply -f ./metrics-server/
```

Now our metrics server will be starting up, and it will periodically collect metrics from our cluster. To avoid wasting time while the metrics server is being set up, we can continue with creating the ReplicaSet that we will be using. Essentially, it will be the same ReplicaSet that we have been using previously, with one small difference. If we want to scale our pod count based on CPU or memory utilization, we will need to have a reference for how much memory the pod is supposed to consume. To do this, we can add a request for CPU resources to the pod template. This will tell Kubernetes what it will typically expect from the Pod.

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
           resources:
              requests:
                 cpu: 80m
```

We are going to create this ReplicaSet, alongside a Service that exposes it on NodePort 30001. We can create the ReplicaSet and the Service by running the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f rs-limit.yml
```

To add the autoscaling capabilitgies, we can now create a new element, the Horizontal Pod Autoscaler. The Horizontal Pod Autoscaler allows us to change the scale number in a different element, in this case a ReplicaSet. As mentioned before, we are going to base the scaling of the Pod on CPU utilization. Thus, if we receive more requests and use more CPU, more Pods will be created. If less requests come in, less CPU will be consumed, and Pods will be removed again. This could be quite dangerous though, for example due to an attack on our application that sends a huge amount of requests. To keep up with the demand, autoscaling would create more and more Pods.

In a private data center, this would simply mean that we might run out of other compute resources. In a public cloud, this could result in a huge bill. Either way, we probably want to avoid this scenario. Luckily, the Horizontal Pod Autoscaler also allows us to set minimum and maximum values for the amount of copies. The minimum copies should be able to deal with sudden spikes in demand, before new pods can be spun up, and the maximum copies assure us that we are never going to spin up too many copies.

Now that we have talked about how autoscaling works, let's look at an example of a Horizontal Pod Autoscaler:

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
   minReplicas: 2
   maxReplicas: 10
   metrics:
   - type: Resource
     resource:
        name: cpu
        target:
           type: Utilization
           averageUtilization: 50
```

First off, you can see that we are referencing our ReplicaSet to define the target element in which we are going to modify the scale value. Furthermore, you can also see the minReplicas and maxReplicas, which define the minimum (minReplicas) and maximum (maxReplicas) replicas that can be deployed through autoscaling.

Finally, we need to tell the autoscaler how it should decide the number of replicas. As mentioned before, we are going to base our decision on the current CPU utilization. With this configuration, our Horizontal Pod Autoscaler will want to create a new replica if the CPU utilization is larger than 50%.

Let's roll this example out, by executing the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f autoscale.yml
```

Once we apply this, we can view the created object using 

```
kubectl get HorizontalPodAutoscaler
```






Our current utilization will likely be quite low though. We can increase the load on our Service by hitting it with more requests. To do this, let's start another container, which we are going to use to send requests to our hello-cisco Service. Run the following command to get into the shell of a new container:

```
kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
```

We are now in the shell of our newly created container, and we can run a command to send requests to our Service:

```
while true; do wget -q -O- http://svc-hello-cisco.default.svc.cluster.local:5000; done
```

With all of these requests, our Pod will soon be overwhelmed. Our metrics server will notice that the utilization is much higher than it should be, and based on that, autoscaling will kick in and create new Pods. We can observe this using the following command:

```
kubectl get hpa
```

Keep in mind that it will take some time until our metrics server collects new metrics from the Pods. Thus, you can't really expect this to kick in for short burts of demand, but rather for a continued increase in load, such as in our example. After some time, autoscaling will create a few new Pods, and the load will be lower again. If we stop our requests to the Service, autoscaling will remove the Pods again after some time.

You can now have a look at the following two examples to try this yourself.

![Challenge 4](img/challenge4.png?raw=true "Challenge 4")
[Click here for the solution](./solutions/challenge4 "Click here for the solution")

![Challenge 5](img/challenge5.png?raw=true "Challenge 5")
[Click here for the solution](./solutions/challenge5 "Click here for the solution")
