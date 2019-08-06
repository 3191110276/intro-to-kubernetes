# Persistent storage
In the previous chapters, we have been building an application consisting of a web frontend and a database. When entering data into the form, it is saved into the database. What happens if we move the Pod? Or if the Pod dies? Or if we create a new version of it? Right now, our storage is coupled with our Pod, which means that if our Pod goes away, the storage will vanish along with it.

Ok, thats not good. We shouldn't lose our data each time a Pod dies, that wouldn't work for a production system. So, we need a way to permanently store our data across Pod failures or moves. In Kubernetes we can can achieve this through Persistent Volumes (PV). Let's have a closer look at how this works.

![Storage Design](img/storage_design.png?raw=true "Storage Design")

A Persistent Volume will be backed by some type of storage that offers an interface to Kubernetes. We can (and usually will) have multiple Persistent Volumes on a single storage system. Now, how do we actually create the Persisten Volume and connect it to the Pod though? There are two ways to achieve this. Either we manually create a Persistent Volume and bind it to the Pod, or we use a dynamic creation process based on Persistent Volume Claims (PVC).

In many cases, dynamic creation of Persistent Volumes can be advantageous, as we don't have to deal with creating the volume. If a devleoper needs some storage for their application, they can simply write a yaml file with the Persistent Volume Claim, and use that to provision their storage, without having to create it manually in the background. In this chapter, we are going to look at dynamic creation via Persistent Volume Claims, but static provisioning would also be a valid usage of Persistent Volumes.

As you can see in the image above, there is one more intermediate step between the Persistent Volume Claim and the Storage system. Kubernetes uses the concept of a StorageClass to tell the PersistentVolumeClaim which storage system can be used. Then, once we know which storage system we will use, the volume plugin will be used for provisioning the volume, which will be exposed to the requestor as a Persistent Volume in Kubernetes.

