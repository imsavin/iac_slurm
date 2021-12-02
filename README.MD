### Simple Iac Installation of Slurm Workload Manager (proxmox + terraform + ansible)

#### 1 Terraform + Proxmox prerequsites

**Create Centos 7 cloud-init template**

```
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2
qm create 9002 --name "centos7-cloudinit-template" --memory 512 --net0 virtio,bridge=vmb0
qm importdisk 9002 CentOS-7-x86_64-GenericCloud-2111.qcow2  local-lvm
qm set 9002 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9002-disk-0
qm set 9002 --ide2 local-lvm:cloudinit
qm set 9002 --boot c --bootdisk scsi0
qm set 9002 --serial0 socket --vga serial0
qm template 9002
```

9002 - id number of temlate VM

On the next step set default username, password and public ssh key in Proxmox console and regenerate cloud-init of VM template

#### 2 Ansible prerequisites

**Install requred roles from the Ansible-galaxy**

```
ansible-galaxy install scicore.slurm
ansible-galaxy collection install community.mysql
```

**NOTE on Ansible /etc/ansible/hosts name**

without inner DNS discovery i prefer to keep coherent naiming of hosts, so my ansible hosts file look like shown below. Using just ip adresses looks confusing after role edits `/etc/hosts`

```
slurm-master.loc ansible_host=192.168.1.220
slurm-node-1.loc ansible_host=192.168.1.221
slurm-node-2.loc ansible_host=192.168.1.222
slurm-node-3.loc ansible_host=192.168.1.223

[slurm-control]
slurm-master.loc

[slurm-node]
slurm-node-1.loc
slurm-node-2.loc
slurm-node-3.loc
```
