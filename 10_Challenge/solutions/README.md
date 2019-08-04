# Solution for Challenge

This is the solution for the following challenge:

![Challenge](../img/challenge.png?raw=true "Challenge")

We will split the solution up into the various parts of the application. First, we will talk about creating the Ingress, followed by the implementation of the Services and Deployments.

## Ingress

First off, we want to create the Ingress. We know that it should be called 'ingress-example', and that it should route to '/example'. That alone is not enough to create the Ingress though. We also need to know where the Ingress redirects to. Thus, we will need to look at the information regarding the frontend application. We can see that the Service should be called 'frontend-svc', which we can then use in our application. In the spec for the frontend Deployment, we can also see that the application is using port 5000, which we can then use as servicePort in our Ingress definition. This should result in an Ingress definition like this:

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

You can apply this Ingress by executing the following command from within the current folder:

```
kubectl apply -f ingress.yaml
```

## Services

Now let's create the Services, which will be the prerequisite for all application communication. You will find the service name, and labels in the definition. There are two things that we will have to think about: the port numbers, and the type of Service. Just like for the Ingress, we can again look at the spec of the Deployments, to find the port numbers used by the application. That will be port 5000 for the frontend, and port 3306 for mysql. The other thing we have to think about is the type of Service we need. As the frontend needs to communicate externally, it makes sense to use type NodePort. The mysql Service will be internal-only, thus we can use type ClusterIP.

This will result in the following definition for the frontend Service:

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

The mysql Service will need a definition similar to the following:

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

We have combined the Services and Deployments into a single yaml file. You can already apply the Service defintions above, or you can wait until we apply everything in the next step.

## Deployments

Finally, for the Deployments, we can combine the information of what we should deliver with the specs to create the yaml definition. This will result in the following defintion for the frontend Deployment:

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

For the mysql Deployment, the definition should look something like this:

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

Now that we have our Services and Deployments defined, we can apply them. First off, let's createe the database by using the following command from within the current folder:

```
kubectl apply -f mysql.yml
```

After we did that, we can create the frontend Service and Deployment as well:

```
kubectl apply -f frontend.yml
```

Both of them will need some time to download the images and start the containers. After some time, we should be able to access the application by going to the IP of the loadbalancer, followed by a '/example'. Just a quick reminder, you can find the loadbalancer IP by running the following command:

```
kubectl get service nginx-ingress-controller --namespace=ccp
```

The IP of the loadbalancer will be in the EXTERNAL-IP column.
