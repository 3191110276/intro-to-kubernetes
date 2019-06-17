# Solution for Challenge 2

This is the solution for the following challenge:

![Challenge 2](../../img/challenge2.png?raw=true "Challenge 2")

As we saw in the previous challenge, it is not possible to apply the same configuration again. We would need to create a new configuration to start a second hello-cisco pod. To differentiate this new pod from our existing pod, we would only need to assign it a new name, for example:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco2
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
```

We can then apply this new pod using the following command from within the current folder folder of this solution:

```
kubectl apply -f pod2.yml
```

If we now run a 'kubectl get pods', we should see two pods running.
