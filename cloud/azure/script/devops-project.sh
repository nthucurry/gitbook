oragnisation=xxx
username=xxx
pat=xxx
curl --location \
    --request GET \'https://dev.azure.com/$oragnisation/_apis/projects?api-version=6.0\' \
    -u $username:$pat | jq '.value[].name'
echo
