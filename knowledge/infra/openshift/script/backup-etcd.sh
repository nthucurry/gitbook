#/bin/bash

## backup etcd
ssh core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}') \
    'sudo /usr/local/bin/cluster-backup.sh /home/core/assets/backup'

## modify backup folder authority
ssh core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}') \
    'sudo chown -R core:core /home/core'

## copy to bastion or NFS
scp core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}'):/home/core/assets/backup/* \
    /mnt/fileshare