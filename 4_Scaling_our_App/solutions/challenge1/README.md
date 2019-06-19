# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

To delete a pod, first let's look at the list of pods we are currently running:

```
kubectl get pods
```

We can copy the name of any of these pods, and use it for the delete command, for example:

```
kubectl delete pod rs-hello-cisco-jh756
```

Please keep in mind that the name of your pod will be different, but other than that, the command structure will be the same. Now, let's run the 'kubectl get pods' command again. We will notice that our old pod is gone, but there are two pods again. This means that the ReplicaSet realized that it did not have enough copies of the pod, and created a new one. if we look at the 'age' column, we can also see that one of the pods will be much younger compared to the other one.
