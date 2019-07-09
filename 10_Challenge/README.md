# Challenge: Deploying an example application
We have gone through many concepts together, but in this chapter, it is up to you to deploy an application on your own. You will get some information about the application that you have to deploy, but then you will have to make it work on your own. Let's have a look at the high-level design of the application.

![Application Design](img/app_design.png?raw=true "Application Design")

As you can see, we will have an Ingress, which will be used for user access. Behind that, we will have to create one Service for the frontend, and one service for the database. Both Services will have their respective Deployments to deliver Pods. Below you will find detailed instructions for each individual component in this design, including the images that should be used. Please use the exact names for the Kubernetes components, otherwise you might face problem in this chapter or in the following chapters. With that said, let's go over the detailed description of all of our components.









![Challenge](img/challenge.png?raw=true "Challenge")
[Click here for the solution](./solutions/ "Click here for the solution")

Once you think that you are done, you can try querying the application through the Ingress. The result of your query should look something like this:

![Challenge Result](img/result.png?raw=true "Challenge Result")

You can add some of your own entries to the database, and the page will update with the comments. In the next chapters, we will explore ways to improve this application design. You don't need to remove any of the deployed components this time. We will be using this application in the next chapter to show how persistent storage can be added. If you are unsure if you deployed everything correctly, there will be a way to clean up everything in the future chapters.
