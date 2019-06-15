# Introducing Kubernetes
Now that we have a basic understanding, let's have a look at Kubernetes. We already identified one reason why we might need an additional layer of management on top of our container runtime. This chaper will look at why we need an orchestration system for our containers. After that, we will have a look at Kubernetes, the most popular container orchestration system.

## Why we need container orchestration
In the previous chapter, we already noticed that managing ports for different containers is a lot of work, which could benefit from some automation. That is only one of the reasons why we might want to have a container orchestration system though. A much bigger problems of container runtimes is their inability to look beyond their own host.

![Problems with container runtimes](img/why_orchestration.png?raw=true "Problems with container runtimes")

We would need to manually decide which container should be on which host, balancing workloads between them. If a host fails, we would need to restart the containers on another host. All of that while making sure that the applications will still be reachable, even if we move them between hosts. Of course, all of this could be automated with scripts. There are several open source tools out there, which can take care of all of these aspects already though. The most popular of them is Kubernetes, which we will be our focus for the remaining part of this training.

## Introducing...Kubernetes
![Kubernetes basics](img/kubernetes.png?raw=true "Kubernetes basics")


## Kubernetes concepts
![Kubernetes concepts](img/k8s_cluster.png?raw=true "Kubernetes concepts")


## Accessing a Kubernetes cluster
![Accessing a Kubernetes cluster](img/user_access.png?raw=true "Accessing a Kubernetes cluster")
