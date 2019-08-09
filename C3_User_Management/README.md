# Logical separation of applications and users

So far, we usually only deployed a single application - maybe two versions of the same application at most. In the real world, a Kubernetes cluster can host hundres or thousands of applications from many different users. We might want to give each of them their own separate environment to work in, without having to create multiple clusters.


## Namespaces

Namespaces allow us to do exactly that. We can create a virtual cluster inside our Kubernetes cluster, which basically means that we have the ability to create tenants.

![Namespaces](img/namespaces_overview.png?raw=true "Namespaces")

Just as the name implies, a Namespaces provides a scope for names. Normally, we couldn't deploy two Kubernetes elements with the same name. If we are deploying them in different Namespaces, that is not a problem at all. This means that different users can have their own application naming schemes, without impacting each other. Let's have a look at that. What Namespaces do we have in our cluster?

```
kubectl get namespaces
```

As you can see, there are already a few Namespaces in our cluster. For a basic installation, Kubernetes will include the following three Namespaces:
* default (if no Namespace is specified)
* kube-system (Kubernetes system resources)
* kube-public (used for resources that should be publicly available in the entire cluster)

You might see some further Namespaces in your clusterm, which have been created to host further cluster components during the installation. This depends on what method you use for setting up your Kubernetes cluster. Before we do anything else, let's create our own Namespace. This is actually quite simple:

```yaml
apiVersion: v1
kind: Namespace
metadata: 
   name: ciscok8s
   labels:
      name: ciscok8s
```

As you can see, there is not a lot to the definition of a Namespace. We just need to provide a name and a label for it, and we are good to go. Let's create this Namespace by applying the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f namespace.yaml
```





Resources are only visible inside the namespace
Unique resources/constraints per namespace

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

## User management

