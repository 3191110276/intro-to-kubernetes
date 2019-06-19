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
      env: prod
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
     -
