#!/bin/bash

echo "--SCALING UP TO 4 REPLICAS--"
kubectl scale deployment nginx-deployment --replicas=4
echo

echo "--- WAITING FOR ALL PODS TO BECOME READY ---"
DESIRED_REPLICAS=4

while true; do
  # Get the number of currently ready pods from the deployment's status
  # Note: We add '|| echo 0' to handle the case where the command might fail and return nothing.
  READY_REPLICAS=$(kubectl get deployment nginx-deployment -o jsonpath='{.status.readyReplicas}' || echo 0)

  echo "Pods Ready: $READY_REPLICAS / $DESIRED_REPLICAS"

  # The -eq operator checks if two numbers are equal
  if [ "$READY_REPLICAS" -eq "$DESIRED_REPLICAS" ]; then
    echo "All pods are ready! Proceeding..."
    break # This command exits the loop
  else
    sleep 2 # Wait for 5 seconds before checking again
  fi
done
echo

echo "--CURRENT PODS RUNNING--"
kubectl get pods -o wide
echo

echo "--DESTROYING ONE POD TO TEST SELF HEALING--"
POD_TD=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD_TD

echo "--SELF HEALING PLEASE WAIT--"
sleep 15
echo

echo "--FINAL STATUS--"
kubectl get pods