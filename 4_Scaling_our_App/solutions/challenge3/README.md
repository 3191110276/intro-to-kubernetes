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

