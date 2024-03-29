hashValue="dksbr"
subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
myResourceGroupVM="dba-k8s-$hashValue-rg"
az account set -s $subscription

vmCount=`az vm list -g $myResourceGroupVM -d --query "length([].name)"`
vmIndex=0

for((i=0; i<=$((vmCount-1)); i++))
do
    vm=`az vm list -g $myResourceGroupVM -d --query [$i].name | cut -d '"' -f2`

    # vmUnreachableStatus=`ping -c 1 $vm | grep -E '100% packet loss|Name or service not known'`
    # if [[ ${#vmUnreachableStatus} > 0  ]];then
        echo "Start cluster..........." $vm
        az vm start -g $myResourceGroupVM -n `echo $vm`
    # fi
done