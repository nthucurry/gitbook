hashValue="q4g6v"
subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
myResourceGroupVM="dba-k8s-$hashValue-rg"
az account set -s $subscription

vmCount=`az vm list -g $myResourceGroupVM -d --query "length([].name)"`
vmIndex=0

for((i=0; i<=$((vmCount-1)); i++))
do
    vm=`az vm list -g $myResourceGroupVM -d --query [$i].name | cut -d '"' -f2`
    az vm stop -g $myResourceGroupVM -n `echo $vm`
done