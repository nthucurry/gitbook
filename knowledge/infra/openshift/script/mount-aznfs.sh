mount -o sec=sys,vers=3,nolock,proto=tcp wkcnfs.blob.core.windows.net:/wkcnfs/etcd /mnt/backup/etcd
mount -o sec=sys,vers=3,nolock,proto=tcp wkcnfs.blob.core.windows.net:/wkcnfs/config /mnt/backup/config
mount -o sec=sys,vers=3,nolock,proto=tcp wkcnfs.blob.core.windows.net:/wkcnfs/nfs-disk-space /mnt/backup/nfs-disk-space