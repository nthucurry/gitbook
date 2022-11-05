export PROJECT_CPFS_OPS=ibm-common-services
export PROJECT_CPD_OPS=ibm-common-services
export PROJECT_CPD_INSTANCE=zen

export IBM_ENTITLEMENT_SERVER=cp.icr.io
export IBM_ENTITLEMENT_USER=cp
export IBM_ENTITLEMENT_KEY=XXX
export PRIVATE_REGISTRY_LOCATION=XXX
export PRIVATE_REGISTRY_PUSH_USER=azadmin
export PRIVATE_REGISTRY_PUSH_PASSWORD=XXX
export PRIVATE_REGISTRY_PULL_USER=azadmin
export PRIVATE_REGISTRY_PULL_PASSWORD=XXX
export INTERMEDIARY_REGISTRY_HOST=$PRIVATE_REGISTRY_LOCATION
export INTERMEDIARY_REGISTRY_USER=$PRIVATE_REGISTRY_PUSH_USER
export INTERMEDIARY_REGISTRY_PASSWORD=$PRIVATE_REGISTRY_PUSH_PASSWORD
export INTERMEDIARY_REGISTRY_PORT=443
# export INTERMEDIARY_REGISTRY_HOST=10.250.101.19
# export INTERMEDIARY_REGISTRY_USER=auoocr
# export INTERMEDIARY_REGISTRY_PASSWORD=openshiftcr
# export INTERMEDIARY_REGISTRY_PORT=5000
export USE_SKOPEO=true
export WORK_ROOT="$HOME/temp/work"

export OFFLINEDIR_CPD="$HOME/offline/cpd"
export OFFLINEDIR_CPFS="$HOME/offline/cpfs"
export PATH_CASE_REPO="https://github.com/IBM/cloud-pak/raw/master/repo/case"
export PROJECT_CATSRC=openshift-marketplace

export APPROVAL_TYPE=Automatic

export LICENSE_CPD=Enterprise

mkdir -p $WORK_ROOT
mkdir -p $OFFLINEDIR_CPD
mkdir -p $OFFLINEDIR_CPFS