# Exposing our application

So far we have learned how to roll out an application container using Kubernetes Pods. We even managed to scale our deployment using Replicasets. So far we haven't actually accessed our application though. And how would we even do that? We don't know on which application which Pod will be spun up on, so how can we easily expose our application for external access?

The solution to this problem is called a 'Service' in Kubernetes. A Service is a Kubernetes component, which enables us to expose one or more pods to other applications in the cluster, or to entities external to the cluster, such as users.

![Kubernetes Service](img/service.png?raw=true "Kubernetes Service")

The service then allows us to access the logical set of pods using a single interface. Even if the pods behind the service are replaced by new pods, the service will stay consistent. This means that pod failures or application upgrades will not interfere with our Service. While pods might change frequently, services will often stay consistent over a long time. Thus, if we want one application to communicate with another application, we should be using a Service for that. There are three types of Services:
* ClusterIP (default) - allows internal access by exposing the Service on an internal IP to the cluster
* NodePort - allows external access by exposing the Service on the same port for each Node in the cluster, and then routing the request to an automatically created ClusterIP
* LoadBalancer - allows external access by assigning a fixed external IP of a LoadBalancer to the Service, while also automtically creating NodePort and ClusterIP in the backend to which the LoadBalancer will route
* ExternalName: maps the service to the contents of the externalName field by returning a CNAME records with its value

Now, let's try to access our own application. To do that, we would need to expose it externally, for example using a NodePort:

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

This Service will expose port 5000 from our application on port 30001 of our nodes. In this case we selected the port manually, but we could also let Kubernetes choose a port from the service node port range (default: 30000 - 32767).

Pods are, again, selected based on a label. We could use the same label that we also use for the ReplicaSet, but it might also be different, depending on our needs. If we want to expose multiple versions of an application, the Service might be a superset of multiple ReplicaSets of different application versions.

Now, let's go ahead and try this out in our Kubernetes cluster. We can use the following command to roll out the Service from within the [/code](code/ "/code") folder:

```
kubectl apply -f service.yml
```

If you look at the YAML file, you will notice that it does not only contain the Service, but also the ReplicaSet. We can specify multiple Kubernetes components in a single YAML file by separating them with 3 dashes (---). Let's have a look at the Kubernetes components we just created. Let's first check the Service:

```
kubectl get service
```

We can see that we created a service that forwards port 5000 from the Pod, to port 30001 on the node. You might also notice that there is another service for Kubernetes, but we can ignore that one for our current example. The ReplicaSet is the same as in the previous example. We can verify that everything was deployed correctly using:

```
kubectl get service
```

Now, we know that we have created a Service, as well as a ReplicaSet. Thus, we should be all set to access our application. We are using a Service of type NodePort, which means that we can access our application on port 30001 on our nodes. Thus, we would need to find out what our node IP is, so that we can access the cluster via <IP>:30001. Let's have a look at all of our nodes, including their IPs:

```
kubectl get nodes -o wide
```

This will show you all the nodes, as well as the IP addresses that they have. We will need the external IP for access to our application. Now that we have a node IP, we can access our application using <IP>:30001. To access the main page, the path would be < IP >:30001/index.html. You should see a nice welcome page.










![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")
