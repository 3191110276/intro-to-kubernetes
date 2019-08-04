# Solution for Challenge 3

This is the solution for the following challenge:

![Challenge 3](../../img/challenge3.png?raw=true "Challenge 3")

To write a label selector, we first need to apply the correct label to our pod. We could use either of the two pods we deployed so far, but in this case we are going to use our pod from the previous challenge.

We will need one pod definition for our test environment:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco2
   labels:
      env: test
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
 ```

And we will need a second pod definition for our prod environment:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco2
   labels:
      env: prod
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
 ```

Aside from the env label, both pod definitions are identical. Let's first apply the 'test' label to our pod, using the following command from within the current folder of this solution:

```
kubectl apply -f pod2_label1.yaml
```

Our pod should now have the 'test' label applied to it, and we can try to query it:

```
kubectl get pods -l env=test
```

Our pod should show up in this query for the test environment. We can also query for the prod environment, to make sure our pod does not show up:

```
kubectl get pods -l env=prod
```

Our pod should not appear with this query. Keep in mind that the second pod we deployed might show up with these queries though, depending on how it is configured.

Now, we can change the label of our pod to 'prod', using the following command from within the current folder of this solution:

```
kubectl apply -f pod2_label2.yaml
```

We can query for 'test' again, but now our pod should no longer show up:

```
kubectl get pods -l env=test
```

If we query for the 'prod' environment, our pod should now appear:

```
kubectl get pods -l env=prod
```
