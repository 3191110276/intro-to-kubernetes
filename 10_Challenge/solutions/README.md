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

```yaml
apiVersion: v1
kind: Service
metadata:
    name: frontend-svc
    labels:
        app: frontend
spec:
    type: NodePort
    ports:
    - port: 5000
      nodePort: 30010
      protocol: TCP
    selector:
        app: frontend
```

```yaml
apiVersion: v1
kind: Service
metadata:
    name: mysql-svc
    labels:
        app: mysql
spec:
    type: ClusterIP
    ports:
    - port: 3306
      protocol: TCP
    selector:
        app: mysql
```













```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deploy
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - image: mysql:5.6
          name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: C1sco123
          ports:
            - containerPort: 3306
              name: mysql
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deploy
  labels:
    app: frontend
spec:
  replicas: 4
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - image: mimaurer/frontend:v1
          name: frontend
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: C1sco123
          ports:
            - containerPort: 5000
              name: frontend
```
