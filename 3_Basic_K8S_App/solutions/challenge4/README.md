# Solution for Challenge 4

This is the solution for the following challenge:

![Challenge 4](../../img/challenge4.png?raw=true "Challenge 4")

For challenge 4, we can use any of our two pods, but we are going to use our pod from challenge 2.


```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco2
   annotations:
      ping: pong
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
 ```

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





```
kubectl apply -f pod2_annotation.yml
```

```
kubectl apply -f pod2.yml
```
