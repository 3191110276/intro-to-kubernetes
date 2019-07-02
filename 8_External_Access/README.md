# Providing external access to the cluster
We have come very far since the start of this training. We already learned a lot of important concepts that allow us to create and manage applications. We have only quickly touched on how to expose those applications though. Services allowed us to grant access to a group of Pods inside, and even outside of the cluster. For external access, we used a NodePort Service, which uses a port on each worker node to forward traffic to a certain group of Pods. For example, in the previous chapters we exposed our applications on &lt;IP&gt;:30001 of a worker node.

What would happen if that node needed downtime though? We wouldn't be able to reach the NodePort anymore on that node. It will still be available on other nodes, but we would have to change the IPs. We could also put a loadbalancer in front of all of our node IPs. This would allow us to deal with situations where a node might go down, and it will also balance the traffic between the various nodes, to avoid overloading a single node.

With the Ingress element, Kubernetes already provides a way of supporting this kind of scenario. An Ingress receives HTTP(S) traffic, and sends it to a NodePort Service via a loadbalancer. The Ingress does not set up the loadbalancer, this has to be taken care of seperately. Then, we need to define the rules that govern which URL will be forwarded to which Service.

![Ingress](img/ingress.png?raw=true "Ingress")

Let's have a look at this with a simple example. Our application is a simple HTML page, which is served by a webserver. We could expose that application as one route in our Ingress. The Ingress will then route the traffic to the Service, and the Service will forward it to one of the Pods. The configuration for that would look something like this:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
    name: ingress-hello-cisco
    annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
spec:
    rules:
    - http:
       paths:
       - path: /hello-cisco
          backend:
              serviceName: svc-hello-cisco
              servicePort: 5000


```

In this definition, we define an Ingress that routes the path /hello-cisco to our Service 'svc-hello-cisco' on port 5000. We can create the Ingress (as well as the Deployment and Service) by running the following command from within the [/code](code/ "/code") folder:


```
kubectl apply –f ingress.yml
```

Now, let's have a look at the Ingress we just created:



