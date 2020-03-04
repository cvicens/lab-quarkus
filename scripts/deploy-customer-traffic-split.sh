#!/bin/bash

## ./deploy-customer-traffic-split.sh $APPS_NAMESPACE $SUBDOMAIN

APPS_NAMESPACE=$1
SUBDOMAIN=$2
SCRIPTS_DIR=$(dirname $0)/descriptors

oc whoami

if [ $? -ne 0 ]
then
   echo "You must be logged in in the platform"
   exit 1
fi


echo ""
echo "*** Deploying customer kservice with latest version (v4) getting 50% of the traffic. V3 will get the other 50%" 
cat $SCRIPTS_DIR/customer-traffic-split.yml | NAMESPACE=$(echo $APPS_NAMESPACE) envsubst | oc apply -f - -n $APPS_NAMESPACE

echo ""
echo " **************************************************************************************************************************** "
echo ""
echo "    Test customer service: curl -v customer.$APPS_NAMESPACE.$SUBDOMAIN                                                       "
echo ""
echo "    Test current customer service: curl -v current-customer.$APPS_NAMESPACE.$SUBDOMAIN                                                       "
echo ""
echo "    Test candidate customer service: curl -v candidate-customer.$APPS_NAMESPACE.$SUBDOMAIN                                                       "
echo ""
echo "    Test latest customer service: curl -v latest-customer.$APPS_NAMESPACE.$SUBDOMAIN                                                       "
echo ""
echo " **************************************************************************************************************************** "
echo ""
