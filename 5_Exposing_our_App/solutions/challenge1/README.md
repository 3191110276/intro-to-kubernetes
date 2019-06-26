# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

Let's try adapting our existing Service to ClusterIP




```yaml
apiVersion: v1
kind: Service
metadata:
    name: svc-hello-cisco
    labels:
        app: hello-cisco
spec:
    type: ClusterIP
    ports:
       - protocol: TCP
         port: 5000
         targetPort: 5000
    selector:
        app: hello-cisco
```

As this only provides cluster-internal access, we won't be able to reach the application anymore. Now, let's create a LoadBalancer Service using the following configuration:

```yaml
apiVersion: v1
kind: Service
metadata:
    name: svc-hello-cisco
    labels:
        app: hello-cisco
spec:
    type: LoadBalancer
    ports:
    - port: 5000
      protocol: TCP
    selector:
        app: hello-cisco
```

We can access the application externally using the load balancer IP. We can see that IP using the following command:

```
kubectl get services svc-hello-cisco -o yaml
```

Once we have the IP, we can access the application on &lt;IP&gt;:5000. Keep in mind that we will need an available load balancer IP for this to work. If we exposed many services using this way, we would quickly run out of IPs. In a public cloud environment, this would also be a waste of resources, as we would be using a load balancer for only exposing a single service. We will learn about another component that will allow for much more efficient usage of load balancers later on.
