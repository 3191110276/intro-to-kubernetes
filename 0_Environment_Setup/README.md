# Environment Setup
Welcome to this introduction to Kubernetes. This guide will start you off with the basics in container technology, all the way to deploying applications on Kubernetes using advanced features. This chapter should help you with the setup of your environment. We will be using your local machine for all further chapters. Below, we will go through the individual parts of the setup.

## Docker
We will be using Docker for playing with containers on your local machine. While this will only be a short part of this training, it will be very useful for you to have this later on. Depending on whether you are using Windows or Mac, you will have to download and install the respective image from https://hub.docker.com/?overlay=onboarding. Specifically, you can use the following links:
- [Windows installer](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe)
- [Mac installer](https://download.docker.com/mac/stable/Docker.dmg)

Either way, you will have to start the application after installing it. If you are using Linux, you will have to install Docker through the respctive package manager of your distribution. Again, don't forget to make sure that the application is up and running.

## Kubernetes
There are many different options that you could use to set up Kubernetes. You could start it on your own local machine, run it from the cloud, or install it on a server. In our case, we are going to use a demo environment provided by Cisco DevNet. Go to the [DevNet Sandbox page](https://devnetsandbox.cisco.com) and log in. You will be shown a variety of available sandboxed that you can use for free.

![DevNet sandbox](img/devnet_sandbox.png?raw=true "DevNet sandbox")

On this screen you can select and reserve a sandbox for a certain amount of time. Select the 'Cloud' category, and then select the sandbox for Cisco Container Platform and click 'Reserve'. You can either start the reservation immediately, or you can reserve on a certain date. Make sure that the sandbox is reserved for the time you want to practice with it.

![Reservation](img/reservation.png?raw=true "Reservation")

The sandbox will be prepared for the specific time you selected. If you opted to start the sandbox immediately, you will have to wait a bit while all components are being prepared. Either way, you should receive an E-Mail once your sandbox is ready. Follow the instructions in this E-Mail to connect to the VPN. After that, you can go back to the sandbox page, which will look something like this.

![Sandbox](img/sandbox.png?raw=true "Sandbox")

On the left side of the page you will see some information that tells you how to connect to the CCP Web UI. Open this URL in a new tab. This will allow you to create your own Kubernetes cluster. Keep in mind that you need to be connected to the VPN to access this page. Once the page has loaded, log in using the provided credentials, you should be presented with a page similar to what you can see below.

![CCP login](img/ccplogin.png?raw=true "CCP login")

Once you are on this page, you can log in as user "admin" with the password "Cisco123". After the login, you should be seeing the following page:

![CCP main page](img/ccpmainstart.png?raw=true "CCP main page")

You can see that we already have a cluster that could be used. For this workshop, we are going to create a new cluster though. To do that, go ahead and click on the "New Cluster" button above the list of current clusters. This will take you to the following page:

![CCP setup](img/ccpsetup.png?raw=true "CCP setup")

Fill out the page as shown in the image, and then continue to the next page by clicking "Next":

![CCP provider](img/ccpprovider.png?raw=true "CCP provider")

On this page, you can provid the settings for the infrastructure used by our cluster. In our case, we don't have much choice. Fill out all the fields as shown in the picture and continue by pressing "Next":

![CCP node](img/ccpnode.png?raw=true "CCP node")



![CCP node2](img/ccpnode2.png?raw=true "CCP node2")

![CCP harbor](img/ccpharbor.png?raw=true "CCP harbor")

![CCP deploying](img/ccpmaindeploying.png?raw=true "CCP deploying")

![CCP finished](img/ccpmainfinished.png?raw=true "CCP finished")

![CCP cluster detail](img/ccpclusterdetail.png?raw=true "CCP cluster detail")

![CCP setup check](img/ccpsetupcheck.png?raw=true "CCP setup check")


## Kubectl
Last, but not least, we need to install kubectl. Kubectl is the command line tool, we can use to interact with a Kubernetes cluster. Depending on your operating system, the installation will be slightly different. See below for how to install on Windows, Mac, or Linux.

### Windows
1. Download the software from here [here](https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/windows/amd64/kubectl.exe)
2. Add the binary in your PATH
3. Test to ensure that kubectl is working by entering the following command:
```
kubectl version
```

### Mac
1. Download the latest release:
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
```

2. Make the kubectl binary executable
```
chmod +x ./kubectl
```

3. Move the binary in your PATH
```
sudo mv ./kubectl /usr/local/bin/kubectl
```

4. Test to ensure that kubectl is working by entering the following command:
```
kubectl version
```

### Linux
1. Download the latest release:
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```

2. Make the kubectl binary executable
```
chmod +x ./kubectl
```

3. Move the binary in your PATH
```
sudo mv ./kubectl /usr/local/bin/kubectl
```

4. Test to ensure that kubectl is working by entering the following command:
```
kubectl version
```

## Kubeconfig



























<!--
## Kubectl Auto-completion (optional)
With the components above, we already have everything that we will need for the training. Additionally, we can set up auto-completion for the kubectl on Mac and Linux. See below how to install the feature on Linux and Mac.

### Mac
To install the feature on Mac, you will first have to make sure that bash autocompletion is installed. You can check that via the following command:

```
type _init_completion
```

If the command does not succeed, you first need to install bash-autocomplete via the following command (requires Homebrew):

```
brew install bash-completion@2
```

Now go to your '~/.bashrc' file, and add this entry it:

```
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
```

After this, you need to reload your shell, then kubectl autocompletion should be working.


### Linux
```
apt-get install bash-completion
```
or
```
yum install bash-completion
```





To enable this feature, you first need to check if you have bash autocompletion installed on your system. Run the following command to find out:
```
type _init_completion
```
-->
