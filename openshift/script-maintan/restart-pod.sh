iisXmetaRepo=`oc get pod -n zen | grep iis-xmetarepo | awk 'BEGIN {FS=" "} {print $1}'`
iisService=`oc get pod -n zen | grep iis-service | awk 'BEGIN {FS=" "} {print $1}'`
omag=`oc get pod -n zen | grep omag | awk 'BEGIN {FS=" "} {print $1}'`

# auto discovery
oc delete pods -n zen $iisXmetaRepo
oc delete pods -n zen $iisService

# resync
oc delete pods -n zen $omag