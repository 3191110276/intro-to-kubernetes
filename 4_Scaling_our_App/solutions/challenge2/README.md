# Solution for Challenge 2

This is the solution for the following challenge:

![Challenge 2](../../img/challenge2.png?raw=true "Challenge 2")

Let's first have a look at our existing pods and their labels using the following command:

```
kubectl get pods --show-labels
```

The '--show-labels' modifier allows us to see the labels that have been assigned to a pod. If we didn't change anything in the ReplicaSet, we should have 2 pods up and running. We can now remove the label from one of them by using the followong command (remember to substitute 'pod_name' for the actual name of the pod):

```
kubectl label pod pod_name app-
```

The above command will remove the label 'app' from the pod we mention in the command. We signalr that we want to remove the label by adding a minus at the end. Once we run that command, we can re-run the original command showing our pods again:

```
kubectl get pods --show-labels
```

You will notice that we now have 3 instances of the hello-cisco pod. This is because the ReplicaSet created a new copy of the pod. Remember, the ReplicaSet identifies its pods using the labels. We removed the label from our pod, thus the ReplciaSet can no longer see it, and it has to assume that a new pod needs to be created to satisfy the two required copies.
