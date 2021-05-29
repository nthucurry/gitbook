#/bin/bash

## backup etcd
ssh core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}') \
    'sudo /usr/local/bin/cluster-backup.sh /home/core/assets/backup' \
ssh core@$(oc get nodes | grep master | sed -n '2,2p' | awk '{print $1}') \
    'sudo /usr/local/bin/cluster-backup.sh /home/core/assets/backup'
ssh core@$(oc get nodes | grep master | sed -n '3,3p' | awk '{print $1}') \
    'sudo /usr/local/bin/cluster-backup.sh /home/core/assets/backup'

## copy to bastion
scp core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}'):/home/core/assets/backup/*
