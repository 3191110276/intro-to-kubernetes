# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

To do this, first let's create a new Namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata: 
   name: challenge
   labels:
      name: challenge
```

Now, let's deploy one of our Pods in this Namespace. It doesn't really matter what we pick, as we just want to use it to see what happens if the Namespace is removed. Let's use 'hello-cisco' for now. Before you go ahead and create this Pod, think about the Namespace though. Our original Pod did not have a Namespace associated with it, thus it was placed in the 'default' Namespace. If we want to move it into a specific Namespace, we need to add that information into the 'metadata' part of our yaml file:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco
   namespace: challenge
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
```

You can apply the Namespace and the Pod by executing the following command from within the current folder:

```
kubectl apply -f ns_pod_challenge.yaml
```

Now, let's have a look at what we just did. If you try to look for the Pod with 'kubectl get pods hello-cisco', you should not see anything, as the Pod as been created in a different Namespace. Thus, let's first switch to that Namespace:

```
kubectl config set-context --current --namespace=challenge
```

You can run the 'kubectl get pods hello-cisco' command again, and this time you should see the Pod. Perfect! Everything has been created as intended, so let's go ahead and delete the Namespace again using the following command:

```
kubectl delete ns challenge --wait=false
```

If we check the list of Namespaces now, we will see that it is either 'Terminating' or already gone:

```
kubectl get ns
```

We are still in the correct context though. So, what happens if we execute a 'kubectl get pods'? You will see that all the Pods will be deleted. Deleting a Namespace will delete every object attached to it! Be careful when deleting a Namspace, or you might take down a lot of applications unintentionally. Now that we are done, let's switch back to our 'default' Namespace:

```
kubectl config set-context --current --namespace=default
```
