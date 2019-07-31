#!/bin/bash

# Ask the user for information about their environment
echo Hello, help us with the setup by providing some information about your environment

read -p 'Pod number: ' pod_number
read -p 'Pod password: ' pod_password

echo $pod_number
echo $pod_password

curl -o auto_deploy.sh \
  https://raw.githubusercontent.com/3191110276/intro-to-kubernetes/master/0_Environment_Setup/setup/auto_deploy.sh \
  && chmod +x auto_deploy.sh

./auto_deploy.sh $pod_number $pod_password full

<<<<<<< HEAD









---
- name: Reset Kubernetes
  hosts: kube
  become: yes

  tasks:
  - shell: kubeadm reset
    register: reset

  - debug:
      msg: "{{reset}}"

- name: Initialize on Kubernetes Master
  hosts: kube01
  become: yes

  tasks:
    - name: Run kubeadmin init on Master
      when: reset is succeeded
      shell: |
        kubeadm init \
        --token {{token}} \
        --pod-network-cidr=10.2{{POD_NUM}}.0.1/16 \
        --service-cidr=192.168.2{{POD_NUM}}.1/24 \
        --apiserver-advertise-address=172.20.{{POD_NUM}}.11
      register: init_master

    - debug:
        msg: "{{init_master}}"

    - name: Create Kubernetes Config directory
      become: false
      file:
        path: "~/.kube"
        state: directory

    - name: Copy kubeconfig file
      become: true
      copy:
        src: /etc/kubernetes/admin.conf
        dest: /home/{{ansible_user}}/.kube/config
        owner: "{{ansible_user}}"
        group: "{{ansible_user}}"
        mode: 0755
        remote_src: True

    - name: Fetch kubeconfig file
      fetch:
        src: /etc/kubernetes/admin.conf
        dest: files/kubeconfig-sbx{{POD_NUM}}
        flat: yes

- name: Join nodes to master
  hosts:
    - kube02
    - kube03
  become: yes

  tasks:
    - name: Run kubeadm join
      when: reset is succeeded
      shell: |
        kubeadm join \
        --token {{token}} \
        {{ hostvars['kube01']['node']['ip'] }}:6443
      register: join_cluster

    - debug:
        msg: "{{join_cluster}}"

- name: Setup kubectl on DevBox
  hosts: devbox

  tasks:
    - name: Create Kubernetes Config directory
      become: false
      file:
        path: "~/.kube"
        state: directory

    - name: Copy kubeconfig file
      become: true
      copy:
        src: files/kubeconfig-sbx{{POD_NUM}}
        dest: /home/{{ansible_user}}/.kube/config
        owner: "{{ansible_user}}"
        group: "{{ansible_user}}"
        mode: 0755

- name: Fix kube-dns IP in configurations
  hosts: kube
  become: yes

  tasks:
    - name: Remove incorrect line
      lineinfile:
        path: /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
        state: absent
        line: Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"

    - name: Add correct line
      lineinfile:
        path: /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
        state: present
        line: Environment="KUBELET_DNS_ARGS=--cluster-dns=192.168.2{{POD_NUM}}.10 --cluster-domain=cluster.local"
        insertafter: 'Environment="KUBELET_NETWORK_ARGS'

    - name: Restart kubelet
      systemd:
        state: restarted
        daemon_reload: yes
        name: kubelet
=======
rm auto_deploy.sh
rm auto_deploy.log
>>>>>>> 3cd57e7aee4e2238696631debf5cd312521c74b6
