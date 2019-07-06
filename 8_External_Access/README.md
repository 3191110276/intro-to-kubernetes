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
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - path: /hello-cisco(/|$)(.*)
        backend:
          serviceName: svc-hello-cisco
          servicePort: 5000
```

In this definition, we define an Ingress that routes the path /hello-cisco/ to our Service 'svc-hello-cisco' on port 5000. We also added some rewrite commands, so that other paths in our app will be adjusted to /hello-cisco/. We can create the Ingress (as well as the Deployment and Service) by running the following command from within the [/code](code/ "/code") folder:


```
kubectl apply -f ingress.yml
```

Now, let's have a look at the Ingress we just created:

```
kubectl get ingress
```

We can see the Ingress we created, as well as IP addresses. You might be lead to believe that these are the IPs we can use to access our loadbalancer, but that is not the case. These IPs represent the worker nodes that are reachable through our Ingress. To get the IP address of the Ingress loadbalancer, we can execute the following command:

```
kubectl get service nginx-ingress-controller --namespace=ccp
```

The IP of the loadbalancer will be in the EXTERNAL-IP column. If you run a different environment with a different loadbalancer, this could be different. In our case, we are using an NGINX loadbalancer, which is running on our cluster. Thus, the loadbalancing actually happens through a Service of type LoadBalancer, which then forward to our NodePort Service. The advantage of this setup is that we can reuse the loadbalancer for multiple applications, which is especially useful in cloud environments, where each additional loadbalancer results in an additional charge.

Now that we know the IP of our loadbalancer, we can connect to our application again using &lt;LB-IP&gt;/hello-cisco/. Make sure to include the trailing slash in the URL, otherwise other resources, such as pictures, are not going to load.

We can also add TLS to our Ingress, but that is a more advanced topic, which we will not be doing for now.

## Cleaning up
Now that we are done with this section, we can remove the artifacts we created. Specifically, we would have to remove the Ingress, the Service, and the Deployment. You should be able to do this on your own, but you can also use the commands below in case you have doubts:

```
kubectl delete ingress ingress-hello-cisco
```

```
kubectl delete svc svc-hello-cisco
```

```
kubectl delete deploy deploy-hello-cisco
```
