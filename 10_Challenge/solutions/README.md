# Solution for Challenge

This is the solution for the following challenge:

![Challenge](../img/challenge.png?raw=true "Challenge")

We will split the solution up into the various parts of the application. First, we will talk about creating the Ingress, followed by the implementation of the Services and Deployments.


```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-example
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - path: /example(/|$)(.*)
        backend:
          serviceName: frontend-svc
          servicePort: 5000
```

