# Cisco ACI Integration into Kubernetes

Cisco ACI (Application Centric Infrastructure) is Cisco's solution for software-defined networking in the Data Center. It abstracts away individual network devices and protocols, and instead focuses on applications, and how they can interact with each other. We are not going to do a detailed introdocution to ACI, but rather just a short overview of the most important core concepts.

Unlike traditional networks, which are configured switch by switch, ACI uses policies, which then configure the switches for us. This allows us to automate our fabric at scale, which gives us many benefits as an operator. At the physical level, an ACI fabric consists of a spine-leaf fabric, with a controller that is responsible for management, without sitting in the data path.

SPINELEAF

ACI will then go ahead and build a VXLAN Fabric with our switches, which means that we don't have to configure the underlying routed network ourselves. We will be dealing with the workloads that are connected to the access ports. With regards to applications, you can imagine ACI like a single big switch, whcih means that workload migration between switches is no problem.

FABRIC

In the traditional world, we would have dealt with access lists and similar concepts to create additional security in our fabric. In ACI, we have a very similar concept called contracts. A contract is essentially an ACL, but instead of using IP addresses, we use groups of applications instead. This could mean grouping VMs, containers, or even bare metal servers together into a so-called Endpoint Group (EPG). We can create bigger or smaller EPGs, depending on our segmentation needs.

EPG

This means that we can easily add a new host to an EPG, or remove one from it, and all the associated contracts (ACL) will be added or removed respectively. In addition to EPG, there are also some other networking constructs, which are also present in traditional networks: L2 domains are called bridge domains, L3 domains are called VRF, and logical separations inside a single device are referred to as Tenants.

TENANTSTRUCTURE

Now that we have defined all of our basic concepts, we can have a look at how to create a contract (ACL). One thing first though: ACI denies all traffic between EPGs by default, thus it uses a whitelist model. We need to tell ACI what communication should be allowed, for example we could say that only https traffic will be allowed between EPGs. Then, we can attach that contract to our EPGs. 

CONTRACTS

Once you have some experience with this, contracts are actually even more powerful, and offer features like service insertion for other devices (such as firewalls). We are not going into advanced features now though. We will be looking at applying this model to Kubernetes though. ACI provides a Kubernetes networking plugin, which provides communication between the individual nodes. It also allows us to add network segmentation to Kubernetes. We can use Kubernetes elements, and put them into an ACI EPG. There are three options for this: segmentation based on clusters, segmentation based on namespaces, and segmentation based on Deployments.

ACIK8S

Cluster isolation allows all communication inside a single Kubernetes cluster, and only traffic leaving or entering the cluster is filtered. This means that this mode is very unintrusive, but it also only offers protection from the outside, but does not separate Kubernetes-internal communication. Namespace isolition allows us to put each different namespace into a unique EPG. This means that we can have one cluster with different users or use cases, and we only allow communication between them if explicitly needed. This is als quite unintrusive, and offers an added layer of security.

Finally, we can also do ACI segmentation based on Deployments. This means that one Deployment could only communicate with another Deployment, if the EPGs that represent them have a contract that allows the communication. This provides added security, but it is also quite intrusive. Ideally, this mode would already be used during development, to continually add the necessary networking rules between the applications.

To get some hands-on with all of these, we have three examples that you can try. You can use the guides below:
* CLUSTER ISOLATION
* NAMESPACE ISOLATION
* DEPLOYMENT ISOLATION
