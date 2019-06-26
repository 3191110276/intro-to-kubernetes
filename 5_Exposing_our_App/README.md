# Exposing our application

So far we have learned how to roll out an application container using Kubernetes Pods. We even managed to scale our deployment using Replicasets. So far we haven't actually accessed our application though. And how would we even do that? We don't know on which application which Pod will be spun up on, so how can we easily expose our application for external access?

The solution to this problem is called a 'Service' in Kubernetes. A Service is a Kubernetes component, which enables us to expose one or more pods to other applications in the cluster, or to entities external to the cluster, such as users.

![Kubernetes Service](img/service.png?raw=true "Kubernetes Service")

The service then allows us to access the logical set of pods using a single interface. Even if the pods behind the service are replaced by new pods, the service will stay consistent. This means that pod failures or application upgrades will not interfere with our Service. While pods might change frequently, services will often stay consistent over a long time.

```yaml
metadata:
    name: svc-hello-cisco
    labels:
        app: hello-cisco
spec:
    type: NodePort
    ports:
    - port: 5000
      nodePort: 30001
      protocol: TCP
    selector:
        app: hello-cisco
```


![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")
