# Advanced application upgrade
In this chapter we will apply the Istio service mesh to do more advanced application upgrades. First, we will install Istio, then we will create a simple application with a service mesh. Then, we will use Istio to create forwarding rules that will allow us to transition from one application version to another. Then, to finish the chapter, we will look at monitoring of our forwarding policies.

## Installing Istio
If you are going to install Istio in your environment, you might want to do some customization, but in our case, we already prepared a single installation file to simplify the setup. To install Istio, simply apply the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f istio_setup.yaml
```

This will create Custom Resource Definitions, which basically define new elements that we can use in Kubernetes. That's awesome! We can simply extend Kubernetes with new elements if needed! We are also going to create some elements for the the Istio system. Finally, the last thing we are doing is adding a label to our default environment (Namespace). We haven't covered Namespaces yet, but in essence, they are just virtual clusters inside our Kubernetes cluster. We can enable Istio on a per-Namespace basis like this:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: default
  labels:
    istio-injection: enabled
spec:
  finalizers:
  - kubernetes
```

The label we added tells Istio to inject a sidecar Pod, which makes the Pod part of the Istio data plane. That's all for now, let's create an application using Istio.

## Deploying a basic Istio application
Let's deploy a small application, so that we can explore Istio. Use the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f bookinfo.yaml
```

Before we continue, let's look at what created just now. Let's look at our Deployments first:

```
kubectl get deployments
```

As you can see, we have five different Deployments, with three of them covering the reviews aspect of our application, but all in different versions. We also have Services for our application:

```
kubectl get svc
```

As you can see, all of our Services are of type 'ClusterIP' though, which means that they will only be accessible from inside the cluster. Right now, we can't access our application! Finally, let's look at our Pods:

```
kubectl get pods
```

In the 'READY' column, you will see that all of our Pods consist of two containers. Once the Pods are ready, you should see a '2/2' in that column. If you use 'kubectl describe pod <POD_NAME>' with one of the Pods, you can see that there is a second container called 'istio-proxy'. If you look in the original yaml file, this container is not present. It was injected through Istio when the Pod was created!

Ok, now we have a rough overview of our application. We can't access it yet though, so let's use Istio to expose our application. To do this, we will need an Istio Gateway, and an Istio Virtual Service. Later on, we are also going to make use of Destination Rules, but for now, we will just set up our cluster access with those two components.

![Istio Flow](img/istio_flow.png?raw=true "Istio Flow")

The Istio Gateway configures a load balancer for our application. It defines what hosts can access our load balancer with what protocol.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
```

We also need to define a Virtual Service, which determines how the requests are routed within the mesh. As you can see, certain paths are mapped to certain Services.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo
spec:
  hosts:
  - "*"
  gateways:
  - bookinfo-gateway
  http:
  - match:
    - uri:
        exact: /productpage
    - uri:
        prefix: /static
    - uri:
        exact: /login
    - uri:
        exact: /logout
    - uri:
        prefix: /api/v1/products
    route:
    - destination:
        host: productpage
        port:
          number: 9080
```

The Isto Gateawy and Istio Virtual Service together are roughly equivalent to a native Kubernetes Ingress. We can apply both of them by running the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f bookinfo_gateway.yaml
```

To have a look at the application, we first need to get the external IP address of the load balancer. Let's make it simple. The following command should retrieve the IP for you:

```
kubectl get service istio-ingressgateway -n istio-system | tail -1 | awk '{ print $4 }'
```

You can now open this page in your web browser of choice. Don't forget to append '/productpage' at the end of the IP address. This is based on the rules for the paths we created with the Virtual Service. If you reload the page a few times, you will notice that the reviews will be different each time. You will either see no stars, red stars, or black stars, This all depends on the version of the reviews Service that is being used to serve this request. We haven't configured anything to choose a specific version yet, thus it will load balance across the various versions.

## Traffic steering between different versions
Now, let's try to route traffic only to v1 of our reviews Service. This can be done via Istio Destination Rules. Let's have a look at an example for the reviews:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews
spec:
  host: reviews
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
  - name: v3
    labels:
      version: v3
```

As you can see here, we have three subsets that we want to route to, each representing one of the versions of our reviews application. The Pods are selected based on their label, thus we could combine different types of Pods through labels. You can apply this and the other Destination Rules via the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f destination-rule-all.yaml
```

To route the requests to one specific version, we need to create Virtual Services that specify which version our service mesh should be routing to. Let's look at the reviews as an example again:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
  - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
```

As you can see here, we specify the subset 'v1' of our reviews. If we apply this, we should always get the same version of our reviews. Let's try it out by applying the Istio Virtual Services from within the [/code](code/ "/code") folder:

```
kubectl apply -f virtual-service-all-v1.yaml
```

This will create all the necessary Virtual Services. Let's referesh our web page a few times. It should not change anymore! You can try to change the service mesh in such a way that all traffic will go to v2 yourself with the following challenge.

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

Right now, we are just routing to one version. This is not much different to what we did before. One advantage of the upgrade with the Service Mesh is that we can bring up the new version completely before we switch to it. We can do some more fancy things with upgrades though. Let's explore some common upgrade methods.

![Versioning](img/versioning.png?raw=true "Versioning")

What we did just now would be a Blue/Green Upgrade, which means that we are switching from one version to the other instantly. We will look at two more examples: A/B testing and ramped/canary updates.

A/B testing means that we only switch some users to the new version while all the other users stay on the previous version.  This allows us to test the release in a real world environment.

Ramped/Canary upgrades will mean that a new version is first rolled out for a select few requests, and then over time more and more requests are serverd with the new version. If there are issues, we can find out with only a few users affected by it. We can add more users over time if everything is ok.

Our application sends back the username of logged in users. We can use that to determine if a user should be served the newest version or not. Let's have a look at our Virtual Service, and how we can modify it.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
  - reviews
  http:
  - match:
    - headers:
        end user:
          exact: your_username_here
      route:
      - destination:
          host: reviews
          subset: v3
  - route:
    - destination:
        host: reviews
        subset: v2
```

As you can see here, we added a second route to 'v3', in addition to our route to 'v2'. If the username matches whatever we specify, then the user will be served v3, otherwise they will be served v2. You can replace your own username for the match in this file and then apply with this command from within the [/code](code/ "/code") folder:

```
kubectl apply -f vs_user.yaml
```

Let's go back to the browser now. If you refresh the page a few times, you should see that the reviews are using black stars (v2). If you log in with the specified username now (no password required), you should see red stars (v3).

TODO: shift traffic 80:20

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")
[Click here for the solution](./solutions/challenge2 "Click here for the solution")

## Monitoring with Istio
TODO

## Cleanup
You can remove all artifcats created during this chapter, as none of them will be needed later on. It would be recommended to remove the label from the Namespace:

```
kubectl label ns default istio-injection-
```
