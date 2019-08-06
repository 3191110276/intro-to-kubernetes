# Persistent storage
In the previous chapters, we have been building an application consisting of a web frontend and a database. When entering data into the form, it is saved into the database. What happens if we move the Pod? Or if the Pod dies? Or if we create a new version of it? Right now, our storage is coupled with our Pod, which means that if our Pod goes away, the storage will vanish along with it.

Ok, thats not good. We shouldn't lose our data each time a Pod dies, that wouldn't work for a production system. So, we need a way to permanently store our data across Pod failures or moves. In Kubernetes we can can achieve this through Persistent Volumes (PV). Let's have a closer look at how this works.

![Storage Design](img/storage_design.png?raw=true "Storage Design")

A Persistent Volume will be backed by some type of storage that offers an interface to Kubernetes. We can (and usually will) have multiple Persistent Volumes on a single storage system. Now, how do we actually create the Persisten Volume and connect it to the Pod though? There are two ways to achieve this. Either we manually create a Persistent Volume and bind it to the Pod, or we use a dynamic creation process based on Persistent Volume Claims (PVC).

In many cases, dynamic creation of Persistent Volumes can be advantageous, as we don't have to deal with creating the volume. If a devleoper needs some storage for their application, they can simply write a yaml file with the Persistent Volume Claim, and use that to provision their storage, without having to create it manually in the background. In this chapter, we are going to look at dynamic creation via Persistent Volume Claims, but static provisioning would also be a valid usage of Persistent Volumes.

As you can see in the image above, there is one more intermediate step between the Persistent Volume Claim and the Storage system. Kubernetes uses the concept of a StorageClass to tell the PersistentVolumeClaim which storage system can be used. Then, once we know which storage system we will use, the volume plugin will be used for provisioning the volume, which will be exposed to the requestor as a Persistent Volume in Kubernetes.

Let's go ahead and try to create this ourselves for our database example we have been using in the previous few chapters. First, we need to define the StorageClass, which will define one of our available storage systems. In our case, we don't have an external storage system, thus we will just use VMware storage. This might not be useful for a production deployment, but will be good enough for us. Let's have a look:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: vsphere
provisioner: kubernetes.io/vsphere-volume
parameters:
   diskformat: thin
   fsType: ext3
```

The main structure of the yaml file is the same as always, with 'kind' defined as 'StorageClass'. The important part is the 'provisioner', which tells us what storage system this class will be using. Actually, it specifically tells us what volume plugin we will be using, but this does correspond to the storage system.

In a real world deployment, we might have different storage classes based on different quality-of-service levels, or similar policies. If we have different environments, it might be good to have the same StorageClasses in each environment, even if the storage system behind them is different. This should make it easier to move an application from one environment to another, because we can just refer to the StorageClass, which abstracts the storage system behind it.

Now that we have a StorageClass, we can use it for storage through a PersistentVolumeClaim. Let's have a look at an example for our database server:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
   name: example-db-pvc
spec:
   storageClassName: vsphere
   accessModes:
      - ReadWriteOnce
   resources:
      requests:
         storage: 400M
```

This basic example includes a few basic parameters that we will need for the claim. The 'storageClassName' refers to the StorageClass we created before.



Depending on your environment and the storage you use, you might need further parameters for both the StorageClass, as well as for the PersistentVolumeClaim. You can check out the documentation of the volume plugin for your storage system to get more information.

What we created so far is a claim on a StorageClass, which is backed by a real storage system. We still need to connect all of this to a Pod though, to actually put it to use as a volume.





Storage Object in use Protection
