# GCP command
## 列出專案
```bash
gcloud projects list --format="table(PROJECT_ID)" | grep -v "(PROJECT_ID|astute-nuance-272206)" >> gcp-proj-list.txt
```

## 列出 instance vCPU, RAM, 狀態, disk size, OS type
```bash
#!/bin/bash

proj_name="gcp-proj-list.txt"
output_file="gcp-vm-detail.csv"

gcloud projects list --format="table(PROJECT_ID)" \
| grep -v "(PROJECT_ID|astute-nuance-272206)" >> $proj_name

rm $output_file

echo "project,dirty,name,vCPU,RAM,internal_ip,external_ip,status,licenses,disk0_size_gb,disk1_size_gb,disk2_size_gb" > $output_file

cat $proj_name | while read line
do
    if [ $line = "PROJECT_ID" ]; then
    echo $line
    else
        echo "*********** $line ***********"
        gcloud config set project=" $line" > /dev/null 2>&1
        gcloud compute instances list --project=$line --format=\
        "csv(disks[0].source,NAME,MACHINE_TYPE,INTERNAL_IP,EXTERNAL_IP,STATUS,disks[0].licenses[0].basename(),disks[0].diskSizeGb,disks[1].diskSizeGb,disks[2].diskSizeGb,creationTimestamp)" \
        | grep -v "name" >> $output_file
        gcloud config unset project > /dev/null 2>&1
    fi
done

rm $proj_name
echo "*********** ok ***********"

sed -i 's/https:\/\/www.googleapis.com\/compute\/v1\/projects\///g' $output_file

# CIM
sed -i 's/auo-aitea0-eda1/CIM EDA1,/g' $output_file
sed -i 's/t-auo-eda1/CIM EDA1 Test,/g' $output_file
sed -i 's/auo-cim-apc/CIM APC,/g' $output_file
sed -i 's/auo-cim-hy/CIM HY,/g' $output_file
# IT
sed -i 's/auo-cm/IT CM,/g' $output_file
sed -i 's/auo-bis/IT BIS,/g' $output_file
sed -i 's/auo-fin-hc/IT FIN,/g' $output_file
sed -i 's/auo-om/IT OM,/g' $output_file
sed -i 's/auo-plm/IT PLM,/g' $output_file
sed -i 's/auo-planning/IT PLM,/g' $output_file
# Infra
sed -i 's/auo-security-lk/IT Infra Security,/g' $output_file
sed -i 's/auo-aitab0-dba/IT Infra,/g' $output_file
sed -i 's/auo-infra-system/IT Infra System,/g' $output_file
sed -i 's/hostproject-173708/IT Infra,/g' $output_file
sed -i 's/auo-infra-tc/IT Infra TC,/g' $output_file

sed -i 's/f1-micro/0.2,0.6/g' $output_file
sed -i 's/g1-small/0.5,1.7/g' $output_file

sed -i 's/n1-standard-1/1,3.75/g' $output_file
sed -i 's/n1-standard-2/2,7.5/g' $output_file
sed -i 's/n1-standard-4/4,15/g' $output_file
sed -i 's/n1-standard-8/8,30/g' $output_file
sed -i 's/n1-standard-96/96,360/g' $output_file

sed -i 's/n1-highmem-2/2,13/g' $output_file
sed -i 's/n1-highmem-4/4,26/g' $output_file

sed -i 's/c2-standard-4/4,16/g' $output_file
sed -i 's/c2-standard-16/16,64/g' $output_file
sed -i 's/n2-standard-4/4,16/g' $output_file

sed -i 's/"custom (1 vCPU, 4.00 GiB)"/1,4/g' $output_file
sed -i 's/"custom (1 vCPU, 5.00 GiB)"/1,5/g' $output_file
sed -i 's/"custom (1 vCPU, 6.00 GiB)"/1,6/g' $output_file
sed -i 's/"custom (1 vCPU, 6.50 GiB)"/1,6.5/g' $output_file
sed -i 's/"custom (1 vCPU, 7.50 GiB)"/1,7.5/g' $output_file
sed -i 's/"custom (1 vCPU, 8.00 GiB)"/1,8/g' $output_file
sed -i 's/"custom (1 vCPU, 10.00 GiB)"/1,10/g' $output_file
sed -i 's/"custom (2 vCPU, 3.75 GiB)"/2,3.75/g' $output_file
sed -i 's/"custom (2 vCPU, 4.00 GiB)"/2,4/g' $output_file
sed -i 's/"custom (2 vCPU, 6.00 GiB)"/2,6/g' $output_file
sed -i 's/"custom (2 vCPU, 8.00 GiB)"/2,8/g' $output_file
sed -i 's/"custom (2 vCPU, 11.50 GiB)"/2,11.5/g' $output_file
sed -i 's/"custom (2 vCPU, 12.00 GiB)"/2,12/g' $output_file
sed -i 's/"custom (2 vCPU, 14.00 GiB)"/2,14/g' $output_file
sed -i 's/"custom (2 vCPU, 15.00 GiB)"/2,15/g' $output_file
sed -i 's/"custom (2 vCPU, 17.25 GiB)"/2,17.25/g' $output_file
sed -i 's/"custom (2 vCPU, 20.00 GiB)"/2,20/g' $output_file
sed -i 's/"custom (4 vCPU, 4.00 GiB)"/4,4/g' $output_file
sed -i 's/"custom (4 vCPU, 8.00 GiB)"/4,8/g' $output_file
sed -i 's/"custom (4 vCPU, 10.00 GiB)"/4,10/g' $output_file
sed -i 's/"custom (4 vCPU, 16.00 GiB)"/4,16/g' $output_file
sed -i 's/"custom (4 vCPU, 20.00 GiB)"/4,20/g' $output_file
sed -i 's/"custom (4 vCPU, 24.00 GiB)"/4,24/g' $output_file
sed -i 's/"custom (4 vCPU, 30.00 GiB)"/4,30/g' $output_file
sed -i 's/"custom (6 vCPU, 6.00 GiB)"/6,6/g' $output_file
sed -i 's/"custom (6 vCPU, 12.00 GiB)"/6,12/g' $output_file
sed -i 's/"custom (6 vCPU, 14.00 GiB)"/6,14/g' $output_file
sed -i 's/"custom (8 vCPU, 12.00 GiB)"/8,12/g' $output_file
sed -i 's/"custom (8 vCPU, 24.00 GiB)"/8,24/g' $output_file
sed -i 's/"custom (8 vCPU, 32.00 GiB)"/8,32/g' $output_file
sed -i 's/"custom (8 vCPU, 40.00 GiB)"/8,40/g' $output_file
sed -i 's/"custom (12 vCPU, 128.00 GiB)"/12,128/g' $output_file
sed -i 's/"custom (16 vCPU, 48.00 GiB)"/16,48/g' $output_file
sed -i 's/"custom (24 vCPU, 60.00 GiB)"/24,60/g' $output_file
sed -i 's/"custom (32 vCPU, 60.00 GiB)"/32,60/g' $output_file
sed -i 's/"custom (32 vCPU, 96.00 GiB)"/32,96/g' $output_file
sed -i 's/"custom (32 vCPU, 192.00 GiB)"/32,192/g' $output_file
sed -i 's/"custom (48 vCPU, 240.00 GiB)"/48,240/g' $output_file
sed -i 's/"custom (48 vCPU, 256.00 GiB)"/48,256/g' $output_file
sed -i 's/"custom (52 vCPU, 54.00 GiB)"/52,54/g' $output_file
sed -i 's/"custom (62 vCPU, 64.00 GiB)"/62,64/g' $output_file

echo "*********** original data ***********"

script="replace.sh"

touch $script

cat $output_file | while read line
do
    #echo $line
    if [[ $line == *"custom-"* ]];then
        tmp0=`echo $line | awk 'BEGIN {FS=","} {print $4}'`
        tmp1=`echo $line | awk 'BEGIN {FS="custom-"} {print $2}'`
        k1=`echo $tmp1 | awk 'BEGIN {FS="-"} {print $1}'`
        tmp2=`echo $tmp1 | awk 'BEGIN {FS="-"} {print $2}'`
        k2=`echo $tmp2 | awk 'BEGIN {FS=","} {print $1}'`
        k3=$((k2/1024))
        #echo $line | sed "s/$tmp0/$k1,$k3/g" > $script
        echo "sed -i \"s/$tmp0/$k1,$k3/g\" $output_file" >> $script
    fi
done

chmod u+x $script
./$script
rm $script
```

## 列出 instance 磁碟大小, 類型
```bash
#!/bin/bash

### define
proj_name="gcp-project-list.txt"
temp_file="gcp-disk-info.tmp"
output_file="gcp-disk-info.csv"
vm_list="gcp-instances-list.csv"
vm_list_disk="gcp-instances-list-detail.csv"

rm $temp_file $output_file

cat $proj_name | while read line
do
    echo "*********** $line ***********"
    gcloud config set project=" $line" > /dev/null 2>&1
    gcloud compute instances list --project=$line --format="csv(disks[0].source,NAME)" | grep -v "name" >> $temp_file
    gcloud config unset project > /dev/null 2>&1
done

sed -i 's/https:\/\/www.googleapis.com\/compute\/v1\/projects\///g' $temp_file

cat $proj_name | while read line
do
    proj=`echo $line | awk 'BEGIN {FS="\/"}  {print $1}'`
    inst=`echo $line | awk 'BEGIN {FS=","}  {print $2}'`
    echo "*********** $proj ***********" >> $output_file
    gcloud config set project $proj > /dev/null 2>&1
    # gcloud compute disks list --filter="name=($inst)" --format="table(NAME,SIZE_GB,TYPE)" | grep -v "NAME" >> $output_file
    gcloud compute disks list --format="table(NAME,SIZE_GB,TYPE)" | grep -v "NAME" >> $output_file
    gcloud config unset project > /dev/null 2>&1
done
```