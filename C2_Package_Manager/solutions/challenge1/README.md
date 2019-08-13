# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

To achieve this, we basically should do two things. First, we need to add a variable to our Ingress template. Second, we should add a default value for the path in our 'values.yaml' file. The second part is optional though. Let's start off by modifying our Ingress yaml file:

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
      - path: /{{.Values.path}}(/|$)(.*)
        backend:
          serviceName: frontend-svc
          servicePort: 5000
```

Next, let's add the following line to our 'values.yaml' file:

```
path: example
```

That's it actually! Nothing else required. Now, we should take these changes and apply them to our existing application. Ideally, we don't want to delete one version and install a new one, but we rather want to upgrade the existing application.
