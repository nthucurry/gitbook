# download install config
rm install-config.yaml
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/install-config.yaml

# generate ssh key
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y
ssh_key_values="`cat ~/.ssh/id_rsa.pub`"
echo -e

# update ssh key
sed -i "s|ssh-rsa XXXX|$ssh_key_values|g" ~/install-config.yaml