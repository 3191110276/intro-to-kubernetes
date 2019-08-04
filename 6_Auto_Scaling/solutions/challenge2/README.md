# Solution for Challenge 2

This is the solution for the following challenge:

![Challenge 2](../../img/challenge2.png?raw=true "Challenge 2")

We can essentially use the same elements from challenge 1, and we just have to change the definition of the ReplicaSet.


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
                 memory: 40Mi
```

We already have some Pods up and running, thus we should remove them first, otherwise the Pods might not be updated correctly:

```
kubectl delete rs rs-hello-cisco
```

We can then execute this change by running the following command from the current folder:

```
kubectl apply -f rs-limit-memory2.yaml
```

We can then confirm that everything worked via 'kubectl get rs' and 'kubectl get pods'. If we are looking at the HorizontalPodAutoscaler, we can also verify if our change in memory had an impact on the current situation:

```
kubectl get hpa
```

Very likely, there will be one more replica compared to before.  Memory is likely not a good value for scaling this application, this was only meant for demonstration purposes.
