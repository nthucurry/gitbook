###################################
echo "  * Azure EA : WKC      (1)"
echo "  * Azure EA : DBA-K8S  (2)"
echo "  * Big Data : DBA_Test (3)"
###################################
echo "Choise 1, 2, 3: "
read info
if [[ $info == "1" ]]; then
    subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
    resource_group="WKC"
elif [[ "$info" = "2" ]]; then
    subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
    resource_group="DBA-K8S"
    nsg="nsg-k8s"
    nsg_home_rule="from_Home"
    public_home_ip=`curl https://ifconfig.me`
else
    subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
    resource_group="DBA_Test"
fi
###################################
echo "Input VM name: "
read vm_name
az account set -s $subscription
###################################
# if vm is not exist, exit the process
isExistVM=`az vm list -g $resource_group -d --query "[?name == '$vm_name'].id" -o tsv`
if [[ ${#isExistVM} == 0 ]]; then exit 1; fi
###################################
echo "[Subscription.....] "`az account show --query name`
echo "[Resource Group...] "$resource_group
echo "[Start VM.........] "$vm_name
###################################
az vm start -g $resource_group -n $vm_name
###################################
if [[ `hostname` == "MBP18.local" ]] || [[ `hostname` == "iMac11.local" ]]; then
    # at home
    az network nsg rule update \
        -g $resource_group \
        --nsg-name $nsg \
        -n $nsg_home_rule \
        --source-address-prefixes "$public_home_ip"
fi
###################################