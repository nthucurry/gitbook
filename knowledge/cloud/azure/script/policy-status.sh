#!/bin/bash

output_file="policy_status_list.csv"
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
az account set -s $subscription

[ -e $output_file ] && rm $output_file

# policy assignment list
az policy assignment list --query "[].{display_name: displayName, name: name, policy_definition_id: policyDefinitionId}" -o tsv | sort > tmp1.file
sed -i "s/\t/,/g" tmp1.file


# policy definition show
cat tmp1.file | while read line
do
    policy_definition_id=`echo $line | awk -F"," '{print $3}'`
    policy_definition_name=`az policy definition list --query "[?id == '$policy_definition_id'].displayName | [0]"`
    echo $line,$policy_definition_name >> tmp2.file
done

# policy assignment show
echo "display_name, compliant, non_compliant, effect, origin_description" >> $output_file
cat tmp2.file | while read line
do
    display_name=`echo $line | awk -F"," '{print $1}'`
    assignment_name=`echo $line | awk -F"," '{print $2}'`
    policy_definition_name=`echo $line | awk -F"," '{print $4}'`
    temp=`az policy state summarize --policy-assignment $assignment_name \
    --query "{ \
    compliant: results.resourceDetails[?complianceState == 'compliant'].count[] | [0], \
    noncompliant: results.resourceDetails[?complianceState == 'noncompliant'].count[] | [0], \
    effect: policyAssignments[].policyDefinitions[].effect | [0] \
    }" -o tsv | tr "\t" ","`
    echo "az policy state summarize --policy-assignment $assignment_name \
    --query \"{ \
    compliant: results.resourceDetails[?complianceState == 'compliant'].count[] | [0], \
    noncompliant: results.resourceDetails[?complianceState == 'noncompliant'].count[] | [0], \
    effect: policyAssignments[].policyDefinitions[].effect | [0] \
    }\""
    echo $display_name, $temp, $policy_definition_name | tee -a $output_file > /dev/null
    sed -i "s/None/0/g" $output_file
    # echo "az policy state summarize --policy-assignment $assignment_name"
    # echo -e
done

[ -e tmp1.file ] && rm tmp1.file
[ -e tmp2.file ] && rm tmp2.file