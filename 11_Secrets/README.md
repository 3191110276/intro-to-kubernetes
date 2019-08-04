# Secrets for applying configuration

In the previous chapter we created quite a big application. We want to improve a small thing about that application though. If you recall, the spec for the frontend Deployment looked like this:

```yaml
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

As you can see, we are passing the password to the frontend container using a plain text string in the spec section of the Deployment file. We have also done the same thing in the definition of the mysql Deployment. First off, this is quite redundant, as both of them will have to use the same password. If we wanted to change our password, we would have to change it in all Deployments that are using the database.

Additionally, having all of this information in plain text in the Deployment file could lead to the password being leaked. Thus, Kubernetes has another object called a Secret, which allows us to save small pieces of data up to 1MiB in size. This is usually used for things like passwords, keys, and similar.

![Secrets](img/secrets.png?raw=true "Secrets")

First off, Secrets will allow us to reuse the information in multiple places, but Secrets are also more secure compared to storing the information directly in the Deployment file. There are some security aspects that we would still have to consider, but this section will only focus on the basics of how to use a Secret.

Secrets themselves are actually quite easy to create:

```yaml
apiVersion: v1
kind: Secret
metadata:
   name: example-secret
data:
   password: C1sco123
```

As you can see here, all we need to specify is the name of the secret, and the data we want to store, in this case the password. We can then go ahead and create this object by running the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f secret.yaml 
```

Our Secret should now be created, we can verify that by using the respective get command for Secrets:

```
kubectl get secrets 
```

We can now apply this Secret to our existing Deployment. For this, you can use the existing Deployment from the previous chapter. If you do not have this, or if you are not sure if it is working correctly, you can use the following command from within the [/code](code/ "/code") folder to apply all components:

```
kubectl apply -f existing.yaml 
```

Now, we can create a new Deployment file for our frontend, which also contains a reference to the Secret. We can reuse almost all of our definitions from the previous chapter, but we will need to exchange the password for a reference to the Secret. To do this, we use 'valueFrom' in the environment variables, and then reference the Secret:

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
              valueFrom:
                 secretKeyRef:
                    name: example-secret
                    key: password
          ports:
            - containerPort: 5000
```

As you can see, the 'secretKeyRef' contains a 'name', which is the name of the Secret, and a 'key', which is the specific value inside the Secret. You could have multiple values inside a Secret, all with their own key. Now, let's go ahead and apply this by running the following command from within the [/code](code/ "/code") folder:

```
kubectl apply -f frontend-new.yaml 
```

If you did everything correctly, nothing should change. The application is still getting the same password, thus it will still work the same way as before. We could apply the same Secret to the database though, to reuse it. You can try this out yourself in the following challenge:

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")

Our application now properly utilizes Secrets. To finish this chapter, let's talk about some use cases for Secrets. We can provide any kind of information to the containers through environment variables. This is also useful if we have applications that move from testing to production. We can have a different Secret for each environment, which contains the correct information about each environment. It is also possible to mount Secrets to a container like a file. This opens up even more use cases.

## Cleaning up

We do not need to clean up the application so far. We will be using it for one more chapter. If you are unsure if your application is deployed correctly, we will offer you an opportunity to redeploy the application in the next chapter.
