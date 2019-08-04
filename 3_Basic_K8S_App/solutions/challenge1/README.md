# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

If we use the 'kubectl apply -f pod1.yaml' again, there will be no changes to our Kubernetes cluster. We should receive a message similar to this:

```
pod/hello-cisco unchanged
```

Kubernetes is aware that this is still the same configuration, and thus the same pod. Due to this, there is no need to create a new pod. This also means that if we are not sure if we created an object already, we can just apply it again.
