# Solution for Challenge 4

This is the solution for the following challenge:

![Challenge 4](../../img/challenge4.png?raw=true "Challenge 4")

For challenge 4, we can use any of our two pods, but we are going to use our pod from challenge 2. Let's first add an annotation to our pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
   name: hello-cisco2
   annotations:
      challenge: OUR ANNOTATION WAS ADDED TO THE POD
spec:
   containers:
   - name: hello-cisco
     image: mimaurer/hello-cisco:v1
     ports:
     - containerPort: 5000
```

We can apply the annotation to our pod, using the following command from within the current folder of this solution:

```
kubectl apply -f pod2_annotation.yaml
```

How can we verify this? We can't search for the annotation, but the annotation will be visibile if we look at the pod details. You can use the following command to verify that the label has been applied:

```
kubectl get pods hello-cisco2 -o yaml
```

The '-o yaml' option, will show us all the pod details available, including the annotation. There could also be some existing annotations, but you can ignore those for now. Once you have verfied that the annotation exists, we can remote it again:

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

You can apply this change using the following command from within the current folder of this solution:

```
kubectl apply -f pod2.yaml
```

If you look at the pod details again, the annotation should be gone again:

```
kubectl get pods hello-cisco2 -o yaml
```
