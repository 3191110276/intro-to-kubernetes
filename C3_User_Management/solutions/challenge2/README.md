# Solution for Challenge 2

This is the solution for the following challenge:

![Challenge 2](../../img/challenge2.png?raw=true "Challenge 2")

Ok, so we basically need to create some Pod in two different Namespaces, and then we have to try to do a ping between them. Let's just use busybox for our two Pods. Then, we can put one of those into the 'default' Namespace. We also need to create a Namespace for the second Pod. This can look something like this:

```
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
  labels:
    app: busybox
spec:
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
---
apiVersion: v1
kind: Namespace
metadata: 
   name: challenge
   labels:
      name: challenge
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: challenge
  labels:
    app: busybox
spec:
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
```

You can apply all of that using the following command from within the current folder:

```
kubectl apply -f busyboxes.yaml
```

You can now, of course, check that both Pods are running properly (kubectl get pods). Once you confirmed that, we now need to create a ping between the two Pods. To do this, we will need to know the IP address of the Pod. Let's find out the IP address of the Pod running in the 'challenge' Namespace:

```
kubectl get pods -o wide --namespace challenge
```

As you can see here, we can get a list of all Pods from a different Namespace, by adding '--namespace' to the end of our command. This also works for other commands. In the output of this command, we will see an IP address. This is what we will be using to ping the our ping. Make sure that you are in the 'default' Namespace, then let's go ahead and try to ping from that busybox to the other one:

```
kubectl exec busybox ping <IP ADDRESS>
```

Make sure to replace the IP address with the one you got before. Then, you should see the ping working between the two Pods. Great! What does this mean though? By default, there is no network isolation between different Namespaces. This means that we could intentionally, or unintentionally, create communication where we might not want to allow it.

It is possible to block the network communication between the Namespaces by using a networking plugin, such as Cisco's ACI plugin for Kubernetes. More on that later.
