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

Right now, the list of pods should only include a single pod, the hello-cisco pod we just created. We can see a bit more information about the pod, by specifiying the '-o wide' option. If we want to see the complete definition of the object in Kubernetes, we can use the '-o yaml' or '-o json' options. Another way to get detailed information about the pod would be by using:

```
kubectl describe pods hello-cisco
```

All of this information so far was focused on how Kubernetes sees the pod. If we want to figure out what is going on inside of our container, we can even run Linux commands directly in our container. For example, we could have a look at what processes are currently running:

```
kubectl exec hello-cisco ps aux
```

Now, it's time for you to apply this yourself with the following two challenges.

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")
[Click here for the solution](./solutions/challenge2 "Click here for the solution")

## Imperative vs declarative configuration
So far, we have been using the kubectl to apply yaml files to our Kubernetes cluster. These yaml files specify what we would like to see, and the Kubernetes cluster will take care of instantiating the necessary resources. It would also be possible to execute direct commands against, for example to create a pod. That is not the Kubernetes way though.

![Imperative vs declarative configuration](img/imperative_vs_declarative.png?raw=true "Imperative vs declarative configuration")

Direct, imperative commands can be useful for some emergency our troubleshooting scenarios, but we should aim to deploy all of our applications via declarative yaml files. As we saw before, we can apply such a configuration multiple times, and nothing will change. We could also use the yaml files for updates though. We could change some parameters in the yaml file, and then apply it again to update our cluster.

If we then put each version of our yaml file into a version control system, we could see a complete history of our application definitions. If there are any problems, we could easily roll back to an older version of our application, without having to think about what configurations we used two weeks ago.

Thus, to summarize: whenever possible, use declarative configuration with Kubernetes. It will make your life a lot simpler, and enables more options!

## Labels and Label Selectors
Right now, we should only have two pods up and running. Imagine running Kubernetes for more complex environments though. Due to the leightweight nature of containers, we might end up running many thousands of containers on a single Kubernetes cluster. If we wanted to troubleshoot a certain application, we would need to have an easy way to find all relevant pods.

Labels allow us to attach some additional information to a pod. As an example: one application might consist of many containers. We could tag all of them to show that they belong to the same application. 

![Labels](img/label.png?raw=true "Labels")

As we can see in the example, the pod is tagged with app=demoweb, to show what app this belongs to. We also have a tag for the version, in case we are running multiple versions at the same time. Finally, this example also includes a tag for the relevant contact. This would enable us to filter all pods managed by a certain user.

Let's try to apply this to our hello-cisco pod that we deployed before. Labels are part of the metadata section in the defintion. Everything else would stay the same though.

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco
   labels:
      app: getting-started
      version: v1
      env: prod
spec:
   containers:
    - name: hello-cisco
      image: mimaurer/hello-cisco:v1
      ports:
      - containerPort: 5000

```

We can update our existing pod by applying the config via the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f pod1_label.yml
```

By doing this, we are modifying our existing hello-cisco pod. If we run a 'kubectl get pod' command, we can see that our pod is still up and running from before. We can see that the labels have been applied with the 'kubectl describe pod hello-cisco' command. Now that the pod has these labels, we can use them for filtering. We can run the 'kubectl get pod' command again, but now we specify a few labels that we are filtering for:

```
kubectl get pods -l app=getting-started,version=v1,env=prod
```

You can try this yourself in the next challenge.

![Challenge 3](img/challenge3.png?raw=true "Challenge 3")
[Click here for the solution](./solutions/challenge3 "Click here for the solution")

While labels are a very powerful feature, which allows us to search for elements by key/value pairs, there are some situations where labels are not ideal, due to their restrictions. First off, label names are limited to 63 characters, and more importantly, label values are limited to 253 characters. There are also some restrictions regarding the allowed characters. This means that some values won't work as labels, for example a very long URL.

To add such information to a pod, we can use annotations, which do not have the same restrictions. The main drawback of annotations is that they are not searchable though. In terms of configuration, they look quite similar to labels:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco
   annotations:
      ping: pong
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
```
We can change our existing pod with an annotation using this command from within the [/code](code/ "/code") folder:

```
kubectl apply -f pod1_annotation.yml
```
Now you can go ahead and try this yourself in the challenge below.

![Challenge 4](img/challenge4.png?raw=true "Challenge 4")
[Click here for the solution](./solutions/challenge4 "Click here for the solution")
