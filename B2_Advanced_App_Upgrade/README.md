# Advanced application upgrade
In this chapter we will apply the Istio service mesh to do more advanced application upgrades. First, we will install Istio, then we will create a simple application with a service mesh. Then, we will use Istio to create forwarding rules that will allow us to transition from one application version to another. Then, to finish the chapter, we will look at monitoring of our forwarding policies.

## Installing Istio
If you are going to install Istio in your environment, you might want to do some customization, but in our case, we already prepared a single installation file to simplify the setup. To install Istio, simply apply the following command

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
TODO

![Istio Flow](img/istio_flow.png?raw=true "Istio Flow")




## Traffic steering between different versions
TODO

## Monitoring with Istio
TODO

## Cleanup
TODO
