# Uninstalling Cloud Pak for Data
## To remove the Cloud Pak for Data control plane
### Log in to your Red Hat OpenShift cluster as a project administrator
### Change to the project where the Cloud Pak for Data control plane is deployed
```bash
oc project Project_Name
```

### Run the following command to preview the changes that will be made to the cluster when you remove the Cloud Pak for Data control plane
```bash
NAMESPACE=zen
./cpd-cli uninstall \
--namespace $NAMESPACE \
--assembly lite \
--uninstall-dry-run
```

### Run the following command to remove the Cloud Pak for Data control plane
```bash
NAMESPACE=zen
./cpd-cli uninstall \
--namespace $NAMESPACE \
--assembly lite
```

### When the uninstallation completes, enter the following command to verify that the lite assembly is no longer listed
```bashReplace Project with the name of your Cloud Pak for Data project
oc get CPDInstall cr-cpdinstall -n Project -o yaml
```

## A cluster administrator can remove and clean all of Cloud Pak for Data from OpenShift by completing the following steps
### List all Persistent Volumes in the Cloud Pak for Data project and remove them
### On the OpenShift cluster, stop all pods that are running in the Cloud Pak for Data project
### Delete the project and all cluster scoped items from the OpenShift cluster
```bash
oc delete namespace Project
oc delete scc cpd-user-scc
oc delete scc cpd-zensys-scc
oc delete crd cpdinstalls.cpd.ibm.com
```
>Replace Project with the name of your Cloud Pak for Data project

### Verify that all Cloud Pak for Data Persistent Volumes are gone
```bash
oc get pv

# If any still exist, delete them
oc delete pv pv-name
```