# Auto-scaling applications

You should have a basic understanding of deploying (Pod), scaling (ReplicaSet), and exposing (Service) applications now.
 now. Our current way of scaling with ReplicaSets has one major issue though: we always need to scale based on the maximum demand. Let's think about this with an example. We might have an application that is used by our employees when they log into their workstation. Thus, the application would likely experience a lot of traffic in the morning, and around lunch time. During the rest of the day, we are likely going to receive relatively few requests. We would still have to provide enough pods to handle the spikes though.

This means that for the majority of the time, we are running a lot more pods than would be needed. To accomodate for changes in demand, Kubernetes offers autoscaling capabilities. This can save us a lot of money, especially if we are running in a cloud environment.

How do we create this feature in our Kubernetes environment? ReplicaSets already provide the scaling capabilities that we need, but they do not automatically scale based on demand. To achieve that, we will need an additional element, the so-called 'Horizontal Pod Autoscaler'. This element basically controls the amount of replicas a ReplicaSet should produce.

![Auto-scaling](img/autoscaler.png?raw=true "Auto-scaling")

We can scale our pods based on different metrics, such as CPU or memory, among others. For example, let's imagine that we would like our pods to use 100m CPU on average. If they are using 200m CPU on average, this would mean that we are double the desired metric. Thus, the Horizontal Pod Autoscaler would double the amount of copies that the ReplicaSet should produce.

We just mentioned 100m and 200m CPU, what does that mean though? Let's have a quick look at how CPU and memory are measured in Kubernetes. CPUs resources are measured in cpu units, which would correspond to one Hyperthread on a bare metal server, though the exact measurement varies between environments. 100m would correspond to 0.1 cpu units. Memory is measured in bytes.

Before we get started with deploying autoscaling, we first need to have metrics for deciding what to do. By default, most Kubernetes distributions will not collect these metrics though, thus we will need to set up a metrics server. Keep in mind that while it does not come pre-installed, it is part of Kubernetes, and not some hacky third party solution. The setup is quite a simple process. All the necessary yaml files for the rollout are prepared in the [/code/metrics-server](code/metrics-server "/code/metrics-server") folder. You can have a look at the individual files, but we are just going to apply all yaml files by ececuting the following command from within the [/code](code/ "/code") folder:
 
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

You should see the defined HorizontalPodAutoscaler, as well as the metrics in the TARGETS column. If you are still seeing an <unknown> value in the TARGETS column, the metrics server did not have enough time to collect metrics yet, and you will have to wait a little bit more. Furthermore, you can also see the minimum and maximum amount of replicas, as well as the current replicas.

Right now, our CPU utilization will likely be quite low. Thus, our HorizontalPodAutoscaler will have deployed the minimum of 2 replicas. We can increase the load on our service by hitting it with more requests. To do this, let's start another container, which we are going to use to send requests to our hello-cisco Service. Open a new terminal window, and then run the following command to start a new container that provides you shell access:

```
kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
```

Now that we are in the shell of our container, we can run the following command to send requests to our Service:

```
while true; do wget -q -O- http://svc-hello-cisco.default.svc.cluster.local:5000; done
```

This starts an infinite loop of requests or our application. With all of these requests, our Pods will soon be overwhelmed. Our metrics server will notice that the utilization is much higher than it should be, and based on that, autoscaling will kick in and create new Pods. We can observe this by looking at the HorizontalPodAutoscaler, short hpa:

```
kubectl get hpa
```

Keep in mind that our metrics server only does periodic polling, thus it might take some time until our metrics are updated. Thus, you can't really expect this to kick in for short burts of demand, but rather for a continued increase in load, such as in our example. Soon, the metrics will be updated, and our HorizontalPodAutoscaler will notice that the Pod metrics are  higher than they should be. Due to this mismatch between metrics and target, autoscaling will  kick in and create a few new Pods. Once the new Pods are up and running, the metrics should be lower again. Again, keep in mind that this will take some time to update, due to the periodic polling of the metrics server.

Whie we are waiting for this to happen, we can look at a few other features of the metrics server to observe this process. You can run the following command to see the utilization of the current Pods:

```
kubectl top pod
```

If you want to see the information at a Node level, you can use another command:

```
kubectl top node
```

In the meantime, our HorizontalPodAutoscaler should have also been doing its job, and it should have created new Pods to handle the increased demand. Once we verified this, we can stop the requests from the second Pod. This means that the CPU utilization will be lower again, and that excess Pods will be removed. As before, you can observe this using the following command:

```
kubectl get hpa
```

Now that you have seen how the HorizontalPodAutoscaler works, you can have a look at the following two examples to try it yourself.

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")
[Click here for the solution](./solutions/challenge2 "Click here for the solution")

## Cleaning up
We can now delete all components created in this chapter (ReplicaSet, Service, HorizontalPodAutoscaler). Try doing this on your own, but if you need some help, below are the three commands that you will need:

```
kubectl delete svc svc-hello-cisco
```

```
kubectl delete rs rs-hello-cisco
```

```
kubectl delete hpa scaling-hello-cisco
```
