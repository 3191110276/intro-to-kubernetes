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
kubectl apply -f secret.yml 
```

Our Secret should now be created, we can verify that by using the respective get command for Secrets:

```
kubectl get secrets 
```

We can now apply this Secret to our existing Deployment.

- Make sure that the application from the previous chapter is running
- Apply Secret to Deployment
- Challenge
- Other use cases
