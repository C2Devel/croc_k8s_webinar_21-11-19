#cloud-config

write_files:
  - path: /etc/kubernetes/kubeadm.conf
    owner: root:root
    permissions: 0644
    content: |
      apiVersion: kubeadm.k8s.io/v1beta2
      kind: InitConfiguration
      bootstrapTokens:
      - groups:
        - system:bootstrappers:kubeadm:default-node-token
        token: ${bootstrap_token}
        ttl: 0s
        usages:
        - signing
        - authentication
      ---
      apiVersion: kubeadm.k8s.io/v1beta2
      kind: ClusterConfiguration
      kubernetesVersion: ${kubernetes_version}
      controlPlaneEndpoint: CONTROL_PLANE_IP:6443
      networking:
        podSubnet: 192.168.0.0/16

runcmd:
  - sed -i "s/CONTROL_PLANE_IP/$(curl http://169.254.169.254/latest/meta-data/local-ipv4)/g" /etc/kubernetes/kubeadm.conf
  - kubeadm init --config /etc/kubernetes/kubeadm.conf
  - mkdir -p $HOME/.kube
  - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  - sudo chown $(id -u):$(id -g) $HOME/.kube/config
  - kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml

final_message: "The system is finally up, after $UPTIME seconds"
