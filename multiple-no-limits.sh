. .workshop/settings.sh

API_SERVER=https://api.cluster-kharon-ba75.kharon-ba75.example.opentlc.com:6443

    
START=1
END=30

for i in $(seq $START $END); 
do 
  echo ">>>>> deleting limits on atomic-fruit-$i"
  PROJECT_NAME=${WORKSHOP_NAME}-$i
  oc delete limitrange --all -n atomic-fruit-$i
  echo "<<<<< deleting limits on atomic-fruit-$i"
done
