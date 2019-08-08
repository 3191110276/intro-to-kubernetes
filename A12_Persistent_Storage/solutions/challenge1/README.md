# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

Let's have a look at the list of PersistentVolumes:

```
kubectl get pv
```

We will pick the one for our MySQL database, and then go ahead and delte it using the following command (don't forget to add the name of the PersistentVolume you have):

```
kubectl delete pv <name> --wait=false
```

If we do a 'kubectl get pv' again, the PersinstentVolume will still be there, even though we deleted it. We can see that it is 'Terminating' though. We can still access the application in the browser, and the PersistentVolume doesn't seem to go away, even after waiting for some time. What is happening?

Basically, Kubernetes comes with protection for active PersistentVolumes and PersistentVolumeClaims. If a PersistentVolume is bound to a PVC, or if a PersistentVolumeClaim is used by a Pod, they cannot be deleted. We saw that our volume was in the 'Terminating' state though. This means that it will be deletet as soon as there is no need for it anymore.

One more thing regarind this protection. The protection is achieved through finalizers, which protect the element. If you remove the finalizer, you can actually delete the element without any problems. You can use the following command to see the finalizer:

```
kubectl describe pv <name>
```
