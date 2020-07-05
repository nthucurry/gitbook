# GCP command
- 列出專案
	```bash
    gcloud projects list --format="table(PROJECT_ID)" | grep -v "(PROJECT_ID|astute-nuance-272206)" >> gcp-proj-list.txt
    ```
- 列出 instance vCPU, RAM, 狀態, disk size, OS type
    ```bash
    #!/bin/bash

    proj_name="proj-list.txt"
    output_file="instacne-detail.csv"
    rm $output_file

    echo "project,dirty,name,vCPU,RAM,internal_ip,external_ip,status,licenses,disk0_size_gb,disk1_size_gb,disk2_size_gb" > $output_file

    cat $proj_name | while read line
    do
        echo "*********** $line ***********"
        gcloud config set project=" $line" > /dev/null 2>&1
        gcloud compute instances list --project=$line --format="csv(disks[0].source,NAME,MACHINE_TYPE,INTERNAL_IP,EXTERNAL_IP,STATUS,disks[0].licenses[0].basename(),disks[0].diskSizeGb,disks[1].diskSizeGb,disks[2].diskSizeGb,creationTimestamp)" | grep -v "name" >> $output_file
        gcloud config unset project > /dev/null 2>&1
    done

    echo "*********** ok ***********"

    sed -i 's/https:\/\/www.googleapis.com\/compute\/v1\/projects\///g' $output_file

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
    ```
- 列出 instance 磁碟大小, 類型
    ```bash
    #!/bin/bash

    ### define
    vm_list="gcp-instances-list.csv"
    vm_list_disk="gcp-instances-list-detail.csv"

    #### initial
    rm $vm_list_disk

    #### get vm disk spec
    cat $vm_list | while read line
    do
        echo "*********** $line ***********"
        proj_name=`echo $line | awk '{FS=" "}  {print $1}'`
        vm_name=`echo $line | awk '{FS=" "}  {print $2}'`
        gcloud config set project $proj_name > /dev/null 2>&1
        gcloud compute disks list --filter="name=($vm_name)" --format="table(NAME,SIZE_GB,TYPE)" | grep -v "NAME" >> $vm_list_disk
        gcloud config unset project > /dev/null 2>&1
    done
    ```