# Package Manager

If we are building an application in Docker, it will likely consist of many different components. Each of these components will then need multiple yaml definitions for Deployments, Services, and other objects. This results in a large number of individual yaml files that are needed to create an application. This is alredy quite complex, but our application might even have external dependencies that need to be accounted for.

That's a lot of moving points for a single application rollout. Wouldn't it be easier if we could just tell Kubernetes to install an application? Well, we can! There are tools for Kubernetes that allow us to package all of these components and dependencies into a single deployable component. Such tools are commonly referred to as package managers. The most popular of these Kubernetes package managers is called Helm.

![Helm](img/helm.png?raw=true "Helm")

Helm allows us to define applications as so-called Helm charts. These Helm charts bundle all necessary components. We can then use the two components of Helm to deploy such a chart. First, we have the Helm client, which is installed on the user PC. The second part of Helm is Tiller, which is running on our Kubernetes cluster as a counterpart to the Helm client.

That all sounds well and good, but let's try this out with a practical example. We already had simple web applications in previous chapters. We will use one of those as an example for Helm and explore all basic features of Helm using this example.

The first thing we will need to do is installing the Helm client. You can find installation options here: https://helm.sh/docs/using_helm/#installing-helm. Tiller is already isntalled on our Kubernetes cluster, thus the setup is complete once Helm is up and running on our PC.

We got Helm running now, let's try it out by installing a first example chart on our Kubernetes cluster:

```
helm repo update
helm install stable/mysql --name helm-mysql
```

We first pull the latest list of charts with the 'update' command, and then we install a Helm chart from the official stable repository. If you get an error about a mismatch between client and server version, you can upgrade the server via the following command (you will need to wait a moment until it is ready again!):

```
helm init --upgrade
```

Let's check out this rollout. You can verify yourself that this created a Deployment and a Service on your cluster. Thus, we can easily install multiple Kubernetes components with a single command. There are also some further customizations that we can do for MySQL. Let's not go into that for now. We can delete the application again with the following command:

```
helm delete helm-mysql
```

As you can see here, we are referring to the name we used when creating the app in the first place. In many cases, we want to build our own charts though, and a pre-made chart is not good enough for us. We can create a new Helm chart with the following command:

```
helm create ciscoapp
```

Helm created a directory, which contains all the necessary files for this chart. You can have a look into this directory to see the basic structure of a Helm chart. There should be four basic components. The 'Charts.yaml' file contains high-level metadata about the chart, such as chart name or version. Our yaml files will then be placed inside the 'templates' directory. As the name suggests, these yaml files can contain variables. We can set default values for our variables with the help of the 'values.yaml' file. Finally, we can manually add dependencies in the 'charts' directory, or we could also create a 'requirements.yaml' file to dynamically manage dependencies.

To start off, let's delete all the example files in the 'templates' directory, and then we just copy all of our yaml files into the 'templates' directory. You can find them in the [/code/yaml_files](code/yaml_files "/code/yaml_files") directory. With that, our chart is actually already usable. Before we continue with creating this chart, let's first delete all application components that might still be on our Kubernetes cluster:
* Deployments
* Services (except for Kubernetes)
* Storage Class 'vsphere'
* Secret 'example-secret'

We can apply it to our Kubernetes cluster with the following command:

```
helm install --name ciscoapp ./ciscoapp
```

This will create all of the components again through Helm. Great! You can check out the deployments, services, and so on yourself. You can also use the following Helm command to inspect your application:

```
helm status ciscoapp
```

OK, great, that worked. You can also view your application in the browser. Remember to use 'kubectl get service nginx-ingress-controller --namespace=ccp' to get the IP, and then append '/example/' as the path for the app. Let's explore some more features of Helm. First, let's delete the existing application using the following command:

```
helm delete ciscoapp
```

As you can see, we deleted the entire application with a single command. We don't need to track down individual components to make sure that everything is gone. Now, let's improve upon our existing Helm chart by using some variables. If you remember, in one of our previous chapters, we used a Secret to store the database password of this application. Right now, it is hardcoded in the yaml file. That does not sound all too great from a security perspective. Let's have a look at how our Secret could look like with an added variable for Helm:

```yaml
apiVersion: v1
kind: Secret
metadata:
   name: example-secret
data:
   password: {{.Values.dbpassword}}
```

Now, one more thing before we finish. Let's add a default value for this variable in our 'values.yaml' file. You can append the following line to achieve this:

```yaml
dbpassword: C1sco123
```

Of course you could replace the password with your own password if you want to. We could install the chart the same way we did before by installing the contents of the folder. We can also package all of it into a single file if we want to make our application more portable. You can use this command to package the folder into a single file:

```
helm package ./ciscoapp
```

Now, let's install this packaged chart with the following command:

```
helm install --name ciscoapp.v2 ciscoapp-0.1.0.tgz --set dbpassword=C1sco123
```

Ok, great. You can verify the application again. As a last thing, you can try all of this again with a challenge.

![Challenge 1](img/challenge1.png?raw=true "Challenge 1")
[Click here for the solution](./solutions/challenge1 "Click here for the solution")
