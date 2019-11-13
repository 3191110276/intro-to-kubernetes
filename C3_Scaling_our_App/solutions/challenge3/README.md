# Solution for Challenge 3

This is the solution for the following challenge:

![Challenge 3](../../img/challenge3.png?raw=true "Challenge 3")

This challenge wants us to delete the ReplicaSet. We can check the existing list of ReplicaSets using the following command:

```
kubectl get rs
```

We can now go ahead and delete our ReplicaSet using the following command::

```
kubectl delete rs rs-hello-cisco
```

If we now use the get command again, we will see that the ReplicaSet has been removed. The same is true for the Pods:


```
kubectl get pods
```

The pods created by our ReplicaSet have been removed now. We might still have a pod from challenge 2. Remember: if we remove the labels of a pod, it becomes independent of the ReplicaSet.
