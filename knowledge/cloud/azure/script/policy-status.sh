#!/bin/bash

output_file="policy_status_list.csv"
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
az account set -s $subscription

[ -e $output_file ] && rm $output_file

# policy assignment list
az policy assignment list --query "[].{displayName: displayName,name: name}" -o tsv | sort > tmp.file
sed -i "s/\t/,/g" tmp.file

# policy assignment show
echo "display_name,compliant,noncompliant" >> $output_file
cat tmp.file | while read line
do
    display_name=`echo $line | awk -F"," '{print $1}'`
    assignment_name=`echo $line | awk -F"," '{print $2}'`
    temp=`az policy state summarize \
    --policy-assignment $assignment_name \
    --query "{ \
    compliant: results.resourceDetails[?complianceState == 'compliant'].count[] | [0], \
    noncompliant: results.resourceDetails[?complianceState == 'noncompliant'].count[] | [0], \
    effect: policyAssignments[].policyDefinitions[].effect | [0] \
    }" -o tsv | tr "\t" "," | tr "None" "0"`
    echo $display_name,$temp >> $output_file
    # echo "az policy state summarize --policy-assignment $assignment_name"
    echo -e
done

[ -e tmp.file ] && rm tmp.file