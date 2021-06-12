hashValue="dksbr"
subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resourcegroup="dba-k8s-$hashValue-rg"
az account set -s $subscription

vmCount=`az vm list -g $resourcegroup -d --query "length([].name)"`
vmIndex=0

echo "Are you sure to shutdown OCP cluster (yes/no)?"
read isShutdown
if [[ $isShutdown == "yes" ]];then
    echo "Warning, worker node will be shutdown first!!"
    for((i=$((vmCount-1)); i>=0; i--))
    do
        vm=`az vm list -g $resourcegroup -d --query [$i].name | cut -d '"' -f2`

        # Mark the node as unschedulable
        oc adm cordon $vm

        # Drain all pods on your node
        oc adm drain $vm --ignore-daemonsets --force=true --delete-local-data=true

        # Stop K8S and CRI-O
        echo "Stop K8S and CRI-O......" $vm
        ssh core@$vm sudo systemctl stop kubelet
        ssh core@$vm sudo systemctl stop crio

        sleep 5

        # VM stopped (deallocated)
        echo "Shutdown cluster........" $vm
        az vm deallocate -g $resourcegroup -n `echo $vm`

        sleep 30
    done
else
    echo "Nothing to do"
fi