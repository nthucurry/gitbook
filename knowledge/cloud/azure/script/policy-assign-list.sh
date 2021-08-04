#!/bin/bash

output_file="policy_assign_list.json"
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
az account set -s $subscription

[ -e $output_file ] && rm $output_file

# policy assignment list
az policy assignment list --query "[].name" -o tsv > tmp.file

# policy assignment show
cat tmp.file | while read name
do
    policy_assignment_id=$name
    az policy assignment show \
    --name $policy_assignment_id \
    --query "{ \
    display_name:displayName, \
    not_scopes:notScopes, \
    parameter_effect_value:parameters.effect.value, \
    policy_definition_id:policyDefinitionId, \
    scope:scope \
    }" >> $output_file
done

[ -e tmp.file ] && rm tmp.file