# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

Let's try adapting our existing Service to ClusterIP




```yaml
apiVersion: v1
kind: Service
metadata:
    name: svc-hello-cisco
    labels:
        app: hello-cisco
spec:
    type: ClusterIP
    ports:
    - port: 5000
      nodePort: 30001
      protocol: TCP
    selector:
        app: hello-cisco
```



```yaml
apiVersion: v1
kind: Service
metadata:
    name: svc-hello-cisco
    labels:
        app: hello-cisco
spec:
    type: LoadBalancer
    ports:
    - port: 5000
      nodePort: 30001
      protocol: TCP
    selector:
        app: hello-cisco
```


