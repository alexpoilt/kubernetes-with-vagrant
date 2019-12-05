echo "Configuring the Master Node ..."

# get IP of the master node(i.e this box) 
# echo IP_ADDR=`ifconfig enp0s8 | grep Mask | awk '{print $2}'| cut -f2 -d:`
echo IP_ADDR=`hostname -I | awk '{print $2}'`

# get the hostname of the master
echo HOSTNAME=$(hostname -s)

# initialize the cluster control plane on the master no
sudo kubeadm init --apiserver-advertise-address=192.168.56.7 --apiserver-cert-extra-sans=192.168.56.7  --node-name=$HOSTNAME --pod-network-cidr=172.16.0.0/16

# configure kube config
mkdir -p $HOME/.kube 
sudo \cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -un):$(id -gn) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# install weaveworks network addon
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# make the master node workload schedulable
kubectl taint nodes $HOSTNAME node-role.kubernetes.io/master-