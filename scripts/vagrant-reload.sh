#!/bin/bash -eu

if [[ $# -lt 4 ]]; then

  echo "$0: Missing parameter(s)"
  exit 1
fi

local_login=$1
prov_addr_start=$2
app_addr_start=$3
app_hostname_base=$4
app_node_count=${5:-0}


if [[ ! -e /etc/ansible/.bootstrapped ]]; then
  # Pre-approve ssh connections to provider
  prov_hostname="${app_hostname_base}-provisioner-${prov_addr_start}"
  sudo -u ${local_login} bash -c \
    "ssh-keyscan ${prov_hostname} | grep ecdsa-sha2 > ~${local_login}/.ssh/known_hosts && chmod 600 ~${local_login}/.ssh/known_hosts"; 
  
  # Pre-approve ssh connections to appliance
  if [[ ${app_node_count} -gt 0 ]]; then
    app_node_max=$(( ${app_node_count} - 1 ))
    for app_index in $(seq 0 ${app_node_max}); do
      app_node_index=$(( ${app_addr_start} + ${app_index} ))
      app_hostname="${app_hostname_base}-${app_node_index}"
      sudo -u ${local_login} bash -c \
        "ssh-keyscan ${app_hostname} | grep ecdsa-sha2 >> ~${local_login}/.ssh/known_hosts && chmod 600 ~${local_login}/.ssh/known_hosts"; 
    done 
  fi
fi