# Reference
- [運營永續及災害復原 ( BCDR ) 與 Azure 案例分享](https://www.cloudriches.com/2019/11/22/bcdr/)

# BCDR strategy (運營永續及災害復原策略)
## Site Recovery service
## Backup service
- Get improved backup and restore performance with Azure Backup **Instant Restore capability**

Ability to use snapshots taken as part of a backup job that's available for recovery without waiting for data transfer to the vault to finish. It reduces the wait time for snapshots to copy to the vault before triggering restore.
Reduces backup and restore times by retaining snapshots locally, for two days by default. This default snapshot retention value is configurable to any value between 1 to 5 days.
Supports disk sizes up to 32 TB. Resizing of disks isn't recommended by Azure Backup.
Supports Standard SSD disks along with Standard HDD disks and Premium SSD disks.
Ability to use an unmanaged VMs original storage accounts (per disk), when restoring. This ability exists even when the VM has disks that are distributed across storage accounts. It speeds up restore operations for a wide variety of VM configurations.
For backup of VMs that are using unmanaged premium disks in storage accounts, with Instant Restore, we recommend allocating 50% free space of the total allocated storage space, which is required only for the first backup. The 50% free space isn't a requirement for backups after the first backup is complete.