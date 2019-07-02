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

You will notice that nothing actually happens. You might have also noticed this behavior during the previous chapter, when trying to update the ReplicaSet. To force our Pods to update, we can simply delete all old Pods, and new Pods will be created with the correct image. This is not a very practical approach though, especially if we have a larger amount of Pods to deal with. We could also delete the entire ReplicaSet and all of its Pods, and create a new ReplicaSet. While this is faster for the administrator, it means that our application will have some downtime.

Before we talk about how we can solve this problem, let's first think about what we would need. We would want a mechanism that will delete old Pods and create new Pods, if we change our Pod template. Furthermore, we probably don't want to delete all of our Pods at once, thus we will need some kind of method of upgrading without service interruption. We can achieve all of this by using Deployments.

![Deployments](img/deployment.png?raw=true "Deployments")
