[control_plane]
${control_plane_ips}

[worker_nodes]
${worker_node_ips}

[kube_cluster:children]
control_plane
worker_nodes

[all:vars]
ansible_user=${ssh_user}