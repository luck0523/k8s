#/bin/sh

IP=192.168.170.0

# k8s reset
sudo kubeadm reset 
sudo swapoff -a

# Delete network directory
sudo rm -rf /etc/cni/net.d

# Initialize k8s
sudo kubeadm init --pod-network-cidr=${IP}/16  --upload-certs 
sudo cp -fi /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# untaint
kubectl taint node smstone node-role.kubernetes.io/master-
kubectl taint node smstone node.kubernetes.io/not-ready-




sleep  5
kubectl run --image=nginx nginx
sleep  5
kubectl taint node smstone node.kubernetes.io/not-ready-

sleep  5

##network setting for calico CNI
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
wget https://docs.projectcalico.org/manifests/custom-resources.yaml
#Update IP addr
sed -i -e  's/cidr: 192.168.0.0\/16/cidr: 192.171.0.0\/16/g'  custom-resources.yaml
kubectl create -f ./custom-resources.yaml


#Confirm pod status 
kubectl describe   pod nginx
kubectl get   pod nginx

