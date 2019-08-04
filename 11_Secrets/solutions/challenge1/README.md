# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

We have already created the Secret and applied it to the frontend Deployment. Now, we would like to do the same thing for the mysql Deployment. To do this, we need to modify the mysql Deployment to reference the Secret like this:

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
              valueFrom:
                 secretKeyRef:
                    name: example-secret
                    key: password
          ports:
            - containerPort: 3306
              name: mysql
```

We can then apply this by running the following command from within the current folder:

```
kubectl apply -f mysql-new.yaml
```

This is it, it will take a bit to deploy our mysql container. Keep in mind that just because our frontend is available, our database will need some additional time to start up, thus you won't be able to enter new messages immediately. Once it is ready, it will use the password it receives to the Secret to configure the database.
