###################################
# bigdata: a7bdf2e3-b855-4dda-ac93-047ff722cbbd
# auo    : de61f224-9a69-4ede-8273-5bcef854dc20
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="DBA_Test"
###################################
az account set -s $subscription
echo "[Stop VM..........] "$1
echo "[Subscription.....] "`az account show --query name`
echo "[Resource Group...] "$resource_group
###################################
vm_name=$1
az vm deallocate -g $resource_group -n $1