. .workshop/settings.sh

API_SERVER=https://api.cluster-kharon-ba75.kharon-ba75.example.opentlc.com:6443

    
START=2
END=4

for i in $(seq $START $END); 
do 
  echo ">>>>> deleting lab ${WORKSHOP_NAME} for user$i"
  PROJECT_NAME=${WORKSHOP_NAME}-$i
  oc delete project ${PROJECT_NAME}
  oc delete project atomic-fruit-$i
  echo "<<<<< deleting lab ${WORKSHOP_NAME} for user$i"
done
