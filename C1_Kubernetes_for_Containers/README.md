# Kubernetes for container orchestration
Now that we have a basic understanding, let's have a look at Kubernetes (short: K8s). We already identified one reason why we might need an additional layer of management on top of our container runtime. This chaper will look at why we need an orchestration system for our containers. After that, we will have a look at Kubernetes, the most popular container orchestration system.

## Why we need container orchestration
In the previous chapter, we already noticed that managing ports for different containers is a lot of work, which could benefit from some automation. That is only one of the reasons why we might want to have a container orchestration system though. A much bigger problems of container runtimes is their inability to look beyond their own host.

![Problems with container runtimes](img/why_orchestration.png?raw=true "Problems with container runtimes")

We would need to manually decide which container should be on which host, balancing workloads between them. If a host fails, we would need to restart the containers on another host. All of that while making sure that the applications will still be reachable, even if we move them between hosts. We might also want to have multiple instances of an application on different hosts. For that, we would also have to deal with load balancing between the applications, keeping in mind that applications might have to move from one host to another without warning.

Of course, all of this could be automated with scripts. There are several open source tools out there, which can take care of all of these aspects already though. The most popular of them is Kubernetes, which we will be our focus for the remaining part of this training.

## Introducing...Kubernetes
As mentioned before, Kubernetes is a system for orchestrating containers across multiple hosts. It was originally developed by Google, to run their own container applications in production. In 2014, the company opened the tool up to the public, and it is now maintained by the Cloud Native Computing Foundation (CNCF).

![Kubernetes basics](img/kubernetes.png?raw=true "Kubernetes basics")

Kubernetes will support you with rolling out production applications at scale. Complex tasks are abstracted and automated by functionalities of Kubernetes.

Creating and maintaining a Kubernetes cluster is not a trivial task. Installations can be tricky, and clusters will usually use a range of plugins, which all need to be verified when upgrading from one version to another. Due to these problems, Kubernetes users often tend to go with a ready-made solution, either an on-premises container platform, or a Kubernetes service offered by a cloud provider.

For this example, we are going to use Cisco's Container Platform (CCP), to quickly roll out a cluster. While this does simplify the rollout, this platform is using 100% standard Kubernetes and open-source plugins. Thus, everything that we learn in this workshop can be transferred to other Kubernetes solutions. If you haven't set up your cluster so far, you can go to the Environment Setup chapter to do that.

## Kubernetes concepts
As a system, Kubernetes consists of one or more masters and regular non-master nodes. Masters are tasked with coordinating the cluster, and making sure that the desired state is reached. In practice, this means that the master would intelligently place container workloads on different nodes. If a node should fail, the master will redeploy the containers on a different node.

![Kubernetes concepts](img/k8s_cluster.png?raw=true "Kubernetes concepts")

This means that we don't have to deal with the intricacies of managing our containers.

## Accessing a Kubernetes cluster
As an end user, we will interact with the master to communicate what we would like to happen, and the master will take care of rolling out our intent to the cluster. We can communicate with the master in multiple ways.

All actions we can do in Kubernetes will be executed against an API server running on the master. We could directly access this API, but in most cases, we are probably going to use a simpler way of managing the system. Each cluster will also provide a management dashboard, in which we can view the cluster, as well as our deployed components. This interface also allows us to deploy new components to our cluster. In most cases, we are going to interact with the cluster through the kubectl though, a command-line tool.

![Accessing a Kubernetes cluster](img/user_access.png?raw=true "Accessing a Kubernetes cluster")

To enable the usage of the kubectl, we will need a kubeconfig file. Kubeconfig files specify details about our cluster. We can define multiple clusters in a single Kubeconfig file, and then switch between them through a simple command.

We can view information about the nodes in our cluster using the following kubectl command:

```
kubectl get nodes
```
