#!/bin/bash

[ -e file ] && rm policy_assignment_list_name.tmp
[ -e file ] && rm policy_assignment_list.json

# policy assignment list
az policy assignment list --query "[].name" -o tsv > policy_assignment_list_name.tmp

# policy assignment show
cat policy_assignment_list_name.tmp | while read name
do
    policy_assignment_id=$name
    az policy assignment show \
    --name $policy_assignment_id \
    --query "[].{ \
    display_name:displayName, \
    not_scopes:notScopes, \
    parameter_effect_value:parameters.effect.value, \
    policy_definition_id:policyDefinitionId, \
    scope:scope \
    }" >> policy_assignment_list.json
done

rm policy_assignment_list_name.tmp