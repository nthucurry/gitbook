oragnisation=AUO-ADTAB2
username=tonylee
pat=x5rcnfqlnxquboawrdm6havdkv7bnufxsk6mn3frgmtkskrbt7aq
curl --location \
    --request GET \'https://dev.azure.com/$oragnisation/_apis/projects?api-version=6.0\' \
    -u $username:$pat | jq '.value[].name'
echo