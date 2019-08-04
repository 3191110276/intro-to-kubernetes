# Persistent storage
In the previous chapters, we have been building an application consisting of a web frontend and a database. When entering data into the form, it is saved into the database. What happens if we move the Pod? Or if the Pod dies? Or if we create a new version of it? Right now, our storage is coupled with our Pod, which means that if our Pod goes away, the storage will vanish along with it.

Ok, thats not good. We shouldn't lose our data each time a Pod dies, that wouldn't work for a production system. So, we need a way to permanently store our data across Pod failures or moves. In Kubernetes we can can achieve this through Persistent Volumes.

![Storage Design](img/storage_design.png?raw=true "Storage Design")

Let's have a closer look at how this works.
