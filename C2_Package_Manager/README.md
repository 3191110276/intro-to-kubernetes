# Package Manager

If we are building an application in Docker, it will likely consist of many different components. Each of these components will then need multiple yaml definitions for Deployments, Services, and other objects. This results in a large number of individual yaml files that are needed to create an application. This is alredy quite complex, but our application might even have external dependencies that need to be accounted for.

That's a lot of moving points for a single application rollout. Wouldn't it be easier if we could just tell Kubernetes to install an application? Well, we can! There are tools for Kubernetes that allow us to package all of these components and dependencies into a single deployable component. Such tools are commonly referred to as package managers. The most popular of these Kubernetes package managers is called Helm.

![Helm](img/helm.png?raw=true "Helm")

Helm allows us to define applications as so-called Helm charts. These Helm charts bundle all necessary components. We can then use the two components of Helm to deploy such a chart. First, we have the Helm client, which is installed on the user PC. The second part of Helm is Tiller, which is running on our Kubernetes cluster as a counterpart to the Helm client.

That all sounds well and good, but let's try this out with a practical example. We already had simple web applications in previous chapters. We will use one of those as an example for Helm and explore all basic features of Helm using this example.







```yaml

```
