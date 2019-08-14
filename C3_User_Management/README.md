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

We can easily confirm that our new Namespace was created:

```
kubectl get namespaces
```

Now, let's switch into our new Namespace. There are some more sophisticated methods to do this, but for now, we will just override our current contect:

```
kubectl config set-context --current --namespace=ciscok8s
```

We are now in a different virtual cluster, so all of our previous resources will not be accessible anymore, as they have all been created in the 'default' Namespace. We can confirm this by running a 'kubectl get pods' command. You will see that there are no Pods in our current Namespace. We can switch back to our 'default' Namespace with the following command:

```
kubectl config set-context --current --namespace=default
```

There is much more that you can do with Namespaces, such as setting resource limits. Let's finish this chapter with some challenges for you.

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

![Challenge 2](img/challenge2.png?raw=true "Challenge 2")
[Click here for the solution](./solutions/challenge2 "Click here for the solution")

## User management

While Namespaces can separate applications from different users, our account still has access to all Namespaces. Let's have a look at how accounts work in Kubernetes, to see what restrictions will be possible.

![User Accounts](img/user_accounts.png?raw=true "User Accounts")

In Kubernetes, there are two types of user accounts: User Accounts and Service Accounts. As the name suggests, user accounts are for human users, while service accounts are for processes running in Pods. A user account is global by default and must be unique across all Namespaces. Service Accounts are namespaced. While we might create user accounts with some form of directory integration, Service Accounts are created directly in Kubernetes.

Either way, if an account wants to access the Kubernetes API, they will have to go through authentication, authorization, and admission control. Authentication deals with making sure that the user is who they say they are by means of client certificates, passwords, or various tokens. After being authenticted, the request is authorized based on the usernamme of the requester and the requested action against a specific object. Finally, the last step would be admission control, which are software modules that can modify or reject requests. You can have several admission controllers, which would be called in order. They can even access the contents of the object that is being created, updated, or deleted. Admission control is not available for reads.

Let's look at Service Accounts and how they work. Service Accounts can be created per Namespace, but they are not all that useful on their own. We will also need to add a Role, which gives some permissions to the Service Account. Roles are generic and can be re-used. To connect a Role to a Service Account, we need to use a Role Binding. Thus, to properly create a Service Account, we need the following elements:

![Service Accounts](img/service_account.png?raw=true "Service Accounts")

Let's have a look at this in pratice with the definition of a Service Account:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
   name: myaccount
   namespace: default
```

We can then also go ahead and create a Role with read permissions on the Kubernetes cluster:

```yaml
apliVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
   name: pod-reader
   namespace: default
rules:
   - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "list"]
```

Finally, we will bind that Role to the Service Account via a Role Binding:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
   name: pod-reader-rolebinding
   namespace: default
subjects:
   - kind: ServiceAccount
      name: myaccount
      apiGroup: ""
roleRef:
   kind: Role
   name: pod-reader
   apiGroup: rbac.authorization.k8s.io
```

Let's go and create all of these by applying the following command

CODE

Use Service Account for Pod
