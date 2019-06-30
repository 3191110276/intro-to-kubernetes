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
                 memory: 100Mi
```

Our Service definition will remain unchanged. We can now apply this ReplicaSet to update our Pods by executing the following command from within the current folder:

```
kubectl apply -f rs-limit-memory.yml
```

