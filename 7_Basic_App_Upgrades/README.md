# Basic Application Upgrades

So far we learned how to effectively create a scalable application that our end users can access. If we are developing our own applications, we will likely have to upgrade our replicas to a newer version though. This has always been the case, but the frequency of new application upgrades has been increasing over the last few years through microservices and similar techniques. Containers are a perfect vehicle for such applications, and we can thus expect application upgrades to happen relatively frequently.

If we look at our ReplicaSets, we could simply change the specified image to update our application. Let's give that a try to see what is happening. In the [/code](code/ "/code") folder, you will find two files: 'rs-v1.yml' and 'rs-v2.yml'. Both of them are the same configurations we are used to from previous examples, and the only difference between them is that v1 includes 'image: mimaurer/hello-cisco:v1', while v2 includes 'image: mimaurer/hello-cisco:v2' in the image definition. Let's first roll out v1 of our ReplicaSet:

```
kubectl apply -f rs-v1.yml
```

Pods with the v1 image will be created. Once they are ready, we can change to our v2 ReplicaSet:

```
kubectl apply -f rs-v2.yml
```

You will notice that nothing actually happens. You might have also noticed this behavior during the previous chapter, when trying to update the ReplicaSet. To force our Pods to update, we can simply delete all old Pods, and new Pods will be created with the correct image. This is not a very practical approach though, especially if we have a larger amount of Pods to deal with. We could also delete the entire ReplicaSet and all of its Pods, and create a new ReplicaSet. While this is faster for the administrator, it means that our application will have some downtime. Let's delete this ReplicaSet again:

```
kubectl delete rs rs-hello-cisco
```

Before we talk about how we can solve this problem, let's first think about what we would need. We would want a mechanism that will delete old Pods and create new Pods, if we change our Pod template. Furthermore, we probably don't want to delete all of our Pods at once, thus we will need some kind of method of upgrading without service interruption. We can achieve all of this by using Deployments.

![Deployments](img/deployment.png?raw=true "Deployments")

Essentially, Deployments are an element that deals with the lifecycle of ReplicaSets. Initially, our Deployment would create a ReplicaSet for v1. If we want to upgrade our application to v2 later on, the Deployment would create a new ReplicaSet for v2 to replace the old one. One nice feature of Deployments is the ability to perform a simple rollback to an older version, for example in case of issues with the newer release. We will have a look at all of these features in the next sections.

First, let's have a look at a very simple Deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: deploy-hello-cisco
spec:
    replicas: 4
    selector:
        matchLabels:
            app: hello-cisco
    minReadySeconds: 10
    strategy:
        type: RollingUpdate
        rollingUpdate:
            maxUnavailable: 1
            maxSurge: 1
    template:
        metadata:
            labels:
                app: hello-cisco
        spec:
            containers:
            - name: hello-cisco
              image: mimaurer/hello-cisco:v1
              ports:
              - containerPort: 5000
```

You will notice that the Deployment element looks very similar to a ReplicaSet. Deployments do just build on top of ReplicaSets. You will notice some new parts in the definition though, specifically the entries for 'minReadySeconds' and 'strategy'.

The optional 'minReadySeconds' field specifies how many seconds a Pod should be ready without crashing, before it is considered available. This defaults to 0, thus the Pod would be considered available, as soon as it is ready. This field thus decides which Pods are considered available by the Deployment.

The 'strategy' allows us to configure how Kubernetes will transition from one ReplicaSet to another. There are two types we can use right now: 'Recreate' and 'RollingUpgrade.' With 'Recreate', all existing Pods are killed before new ones are created, which is probably not what we want in many cases. With 'RollingUpgrade', Kubernetes gradually replaces the old Pods with new Pods.

We can also provide some settings to specify how many Pods can be replaced at once (maxUnavailable), either as an absolute value, or as a percentage of total Pods. We don't necessarily need to have unavailable Pods though, as we can also allow our RollingUpgrade to provision more Pods than what would be needed (maxSurge). Again, this can be an absolute value, or a percentage of total Pods, and it will enable us to provision further new Pods during the Upgrade, to speed up the process.

We can use 'maxUnavailable' and 'maxSurge' exclusively, or we can combine them. For example, if we set 'maxSurge' to 1, we could set 'maxUnavailable' to 0. In that case, the Deployment would create one new Pod (more than what would be required), and once the Pod is ready, and old Pod will be killed. This continues until the upgrade is complete.

Let's have a look at all of that in a practical example. First, let's roll out the Deployment with v1 by running the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f deploy-v1.yml
```

This will create the Deployment, which we can look at using:

```
kubectl get deployments
```

We can see if the Deployment is ready, as well as how many replicas we have available currently. In the background, the Deployment will also have created a ReplicaSet, which was responsible for creating these replicas. Let's have a look:

```
kubectl get rs
```

This ReplicaSet then created the Pods in the background. Thus Deployments create ReplicaSets, and ReplicaSets create Pods. So far we haven't done anything that we couldn't have also done with a ReplicaSet though, so let's have a look at an application upgrade from v1 to v2. We have a v2 file or our Deployment in the the [/code](code/ "/code") folder. The only difference to v1 is that the image is now set to 'mimaurer/hello-cisco:v2', instead of 'mimaurer/hello-cisco:v1'. Let's execute this command from within the [/code](code/ "/code") folder:

```
kubectl apply -f deploy-v2.yml
```

We can watch the upgrade using the following two commands:

```
kubectl get deploy
```

```
kubectl get pods
```

You will see that the new Pods are being created (look at the AGE column to differentiate between new and old Pods easily). You will notice that right at the start two new Pods are created, while one of the old Pods starts terminating. This is because we are creating one new Pod via 'maxUnavailable' (which replaces an old Pod with a new Pod), and one Pod via 'maxSurge' (which creates one Pod in addition to the existing Pods). Once the first Pods are ready, more old Pods will be replaced with new Pods. This process will take a few seconds. If you don't need all the details, you can just follow the upgrade using the following command:

```
kubectl rollout status deployment deploy-hello-cisco
```

In case you missed the changes, you can apply the v1 version of the deployment again to observe what the Deployment is doing. Make sure to upgrade to v2 again though, as we will need that version for our next steps.

Now that we are on v2, let's have a look at what we did so far. We can see the history of our Deployment with this command:

```
kubectl rollout history deployment deploy-hello-cisco
```

You will see the revisions, as well as causes for the change, which will be empty in our case. Keep in mind that the revision will be a higher number if you switched between v1 and v2 again. Let's deploy another version, to see how our history will look at that point. You can run the following command from within the [/code](code/ "/code") folder to roll out v3 of our application:

```
kubectl apply -f deploy-v3.yml 
```

If you look at the rollout history now, you should see another revision being displayed:

```
kubectl rollout history deployment deploy-hello-cisco
```

Now that we learned how to do upgrades, let's say that we noticed some problem in v3 of our application, and we want to go back to v2 for now.
