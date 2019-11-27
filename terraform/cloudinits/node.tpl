#cloud-config

runcmd:
  - for i in $(seq 10); do echo "kubeadm join $i" && kubeadm join --token=${bootstrap_token} --discovery-token-unsafe-skip-ca-verification ${control_plane_ip}:6443 && break || sleep 15; done

final_message: "The system is finally up, after $UPTIME seconds"
