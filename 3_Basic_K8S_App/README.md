# Creating a basic application with Kubernetes

## Deploying apps on Kubernetes
In Kubernetes, the basic building blocks for our applications are called pods. Pods are the sammelst deployable unit. It is important to differentiate pods from containers though: a single pod can contain multiple containers. These containers will always be run at the same time on the same node. This is useful when we want to combine multiple components into a single piece.

![K8S Pod](img/pod.png?raw=true "K8S Pod")

Aside from one or more containers, pods can also include shared storage in the form of volumes. All the components of a pod will also share a single IP address and port space. We are going to start with a basic example that includes only a single container.

To deploy a pod to our Kubernetes cluster, we need to provide some information about the content of the pod, for example:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
```
Let's have a closer look at what we are trying to do here. In this example, we are telling Kubernetes that we would like to create a new pod (kind: Pod). We are also providing a name for that pod in the metadata section. Finally, the definition of the pod content can be found in the spec section. We include a list of containers with only one entry for our hello-cisco container.

As a side note: this container image will be pulled from Docker Hub, a public repository of container images. We are going to discuss the topic of hosting container images later on. For now, we don't need to dive deeper into where the image is coming from.

Now that we have a finished definition, we need to apply it to our Kubernetes cluster, using the following command executed from within the [/code](code/ "/code") folder:
```
kubectl apply -f pod1.yml
```

Now that we have created the pod, we can go ahead and check what Kubernetes is going. Let's have a look at the list of pods:

```
kubectl get pods
```

Right now, the list of pods should only include a single pod, the hello-cisco pod we just created.

We can also get detailed information about this pod by using:

```
kubectl describe pods hello-cisco
```

We could even jump directly into the pod, to verify some things:

```
kubectl exec hello-cisco ps aux
```


![Challenge 1](img/challenge1.png?raw=true "Challenge 1")

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")

## Imperative vs declarative configuration
**TODO**

![Imperative vs declarative configuration](img/imperative_vs_declarative.png?raw=true "Imperative vs declarative configuration")


## Labels and Label Selectors
**TODO**

![Labels](img/label.png?raw=true "Labels")

![Challenge 3](img/challenge3.png?raw=true "Challenge 3")


![Challenge 4](img/challenge4.png?raw=true "Challenge 4")
