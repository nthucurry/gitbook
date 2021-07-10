#!/usr/bin/expect

subscription=XXXX
tenant=XXXX
service_principal_client_id=XXXX
service_principal_client_secret=XXXX

spawn ~/ocp4.5_inst/openshift-install create install-config --dir=/home/azadmin/ocp4.5_cust

send "$subscription\r"
send "$tenant\r"
send "$service_principal_client_id\r"
send "$service_principal_client_secret\r"

expect {
    "azure subscription id" { send "$subscription\r" }
    "azure tenant id" { send "$tenant\r" }
    "azure service principal client id" { send "$service_principal_client_id\r" }
    "azure service principal client secret" { send "$service_principal_client_secret\r" }
}
interact