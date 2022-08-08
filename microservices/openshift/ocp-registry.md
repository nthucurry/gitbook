# [OpenShift Container Platform registry overview](https://docs.openshift.com/container-platform/4.6/registry/index.html)
> OpenShift Container Platform provides a built-in container image registry that runs as a standard workload on the cluster.

# [Configuring the registry for bare metal](https://docs.openshift.com/container-platform/4.6/registry/configuring_registry_storage/configuring-registry-storage-baremetal.html)
- Changing the image registry’s management state
    - `oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Managed"}}'`
- Change the spec.storage.pvc in the configs.imageregistry/cluster resource
- Verify that you do not have a registry pod
    - `oc get pod -n openshift-image-registry`
- Check the registry configuration
    - `oc edit configs.imageregistry.operator.openshift.io`
- Check the clusteroperator status
    - `oc get clusteroperator image-registry`
- Ensure that your registry is set to managed to enable building and pushing of images
    - `oc edit configs.imageregistry/cluster`
    - change the line `managementState: Removed` to `managementState: Managed`