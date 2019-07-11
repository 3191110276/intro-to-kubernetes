# Environment Setup

Welcome to this introduction to Kubernetes. This guide will start you off with the basics in container technology, all the way to deploying applications on Kubernetes using advanced features. This chapter should help you with the setup of your environment. We will be using your local machine for all further chapters. Below, we will go through the individual parts of the setup.

## Docker
We will be using Docker for playing with containers on your local machine. While this will only be a short part of this training, it will be very useful for you to have this later on. Depending on whether you are using Windows or Mac, you will have to download and install the respective image from https://hub.docker.com/?overlay=onboarding. Specifically, you can use the following links:
- [Windows installer](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe)
- [Mac installer](https://download.docker.com/mac/stable/Docker.dmg)

Either way, you will have to start the application after installing it. If you are using Linux, you will have to install Docker through the respctive package manager of your distribution. Again, don't forget to make sure that the application is up and running.

## Kubernetes




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
