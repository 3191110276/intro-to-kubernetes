# Persistent storage
In the previous chapters, we have been building an application consisting of a web frontend and a database. When entering data into the form, it is saved into the database. What happens if we move the Pod? Or if the Pod dies? Or if we create a new version of it? Right now, our storage is coupled with our Pod, which means that if our Pod goes away, the storage will vanish along with it.

Let's try this. If you don't have the application from the previous chapter, you can quickly deploy it using the following command from within the /code folder:

```
kubectl apply -f existing.yaml
```

Let's have a look at the website. In case you don't have the URL anymore, you can use the following command where you will see the IP in the 'EXTERNAL-IP' column:

```
kubectl get service nginx-ingress-controller --namespace=ccp
```

You can have a look at the storage persistence yourself by entering some information into the web interface (&lt;IP&gt;/example), and then deleting the database Pod via 'kubectl delete pod <pod_name>'. If you refresh the website, you will see that all the information is gone. Keep in mind that it will take a moment to restart the database, even if the Pod is already available.

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

Let's go ahead and create this in our environment by applying the following command from within the /code folder:

```
kubectl apply -f storageclass.yaml
```

We can confirm the cration of our StorageClass with the following command:

```
kubectl get storageclass
```

You might see that we already have another StorageClass, which is marked as 'default'. If you wanted to make your new StorageClass the default, you would have to change the annotation of the two StorageClasses. We don't need to do that for this example though. 

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

This basic example includes a few basic parameters that we will need for the claim. The 'storageClassName' refers to the StorageClass we created before. Furthermore, we also need to provide an access mode. This can be one of the following:
* ReadWriteOnce (RWO): the volume can be used for reading and writing by a single node
* ReadOnlyMany (ROX): the volume can be used as read-only by multiple nodes
* ReadWriteMany (RWX): the volume can be used as both read and write by multiple nodes

Depending on your storage vendor, not all of these modes might be supported. In our case, we have a single database Pod, which means that ReadWriteOnce will be sufficient. Finally, the last part of our definition is a request for a specific storage amount. In this case, we are requesting '400M' of storage.

You might need some further paramters for your environment for both the StorageClass, as well as for the PersistentVolumeClaim depending on your environment and the storage you use. You can check out the documentation of the volume plugin for your storage system to get more information.

Now, let's go ahead and actually create this StorageClass by applying the following command from within the /code folder:

```
kubectl apply -f pvc.yaml
```

What we created so far is only a claim on a StorageClass, which is backed by a real storage system. We still need to connect all of this to a Pod though, then it will finally be available as a volume. To do this, we basically need to add the PersistentVolumeClaim to the Pod.

Deployment with PVC

Apply new settings

Show that storage is now persistent

Storage Object in use Protection
