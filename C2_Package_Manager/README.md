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
helm install stable/mysql
```

We first pull the latest list of charts with the 'update' command, and then we install a Helm chart from the official stable repository. In many cases, we want to build our own charts though, and a pre-made chart is not good enough for us. We can create a new Helm chart with the following command:

```
helm create ciscoapp
```

Helm created a directory, which contains all the necessary files for this chart. You can have a look into this directory to see the basic structure of a Helm chart. There should be four basic components. The 'Charts.yaml' file contains high-level metadata about the chart, such as chart name or version. Our yaml files will then be placed inside the 'templates' directory. As the name suggests, these yaml files can contain variables. We can set default values for our variables with the help of the 'values.yaml' file. Finally, we can manually add dependencies in the 'charts' directory, or we could also create a 'requirements.yaml' file to dynamically manage dependencies.

To start off, let's just copy all of our yaml files into the 'templates' directory. You can find them in the [/code/yaml_files](code/yaml_files "/code/yaml_files") directory. With that, our chart is actually already usable. We can apply it to our Kubernetes cluster with the following command:

```
helm install --name ciscoapp ./ciscoapp
```

Check Install
Uninstall chart
Add variable for password
Package chart
Install with variables
Challenge: add variable for path and upgrade the current chart
