[control_plane]
${control_plane_ips}

[worker_nodes]
${worker_node_ips}

[cluster:children]
control_plane
worker_nodes