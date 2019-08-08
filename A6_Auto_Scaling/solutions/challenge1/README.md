# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

Our existing application is already being scaled based on CPU, but we can also add memory scaling. To add auto-scaling based on memory as well, we would need to change two things. First, our Pod template would need some information about the memory we are requesting. Second, we need to modify our HorizontalPodAutoscaler to include scaling based on memory.

Let's start by adding a memory request to our ReplicaSet. As mentioned in the instructions, we should add a memory request of 100Mi. This will result in the following ReplicaSet definition:

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
                 memory: 50Mi
```

Our Service definition will remain unchanged. Before we can create the new ReplicaSet, we first need to delete the old ReplicaSet with the following command:

```
kubectl delete rs rs-hello-cisco --wait=false
```

We can now apply the new ReplicaSet to update our Pods by executing the following command from within the current folder:

```
kubectl apply -f rs-limit-memory.yaml
```

Why did we need to delete the old ReplicaSet first? Our ReplicaSet already has a certain number of Pods associated with it. Newly created Pods would use the template with memory included, but existing Pods will not be updated. We will learn another technique soon, which will enable us to update Pods more easily.

We also need to adapt our HorizontanPodAutoscaler to also include scaling based on memory. We can simply do this by adding another entry in the metrics category:

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
   - type: Resource
     resource:
        name: memory
        target:
           type: Utilization
           averageUtilization: 50
```

We can now apply this file with the following command from within the current folder:

```
kubectl apply -f autoscale-memory.yaml
```

If you check the HorizontalPodAutoscaler now, you will see that it will be based on both metrics:

```
kubectl get hpa
```
