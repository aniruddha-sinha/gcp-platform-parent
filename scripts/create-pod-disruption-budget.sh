declare -a PDB_NAMESPACES
declare -a DEPLOYMENT_WITHOUT_PDB


PDB_NAMESPACES+=($(kubectl get namespaces --field-selector=metadata.name!=kube-system,metadata.name!=kube-node-lease,metadata.name!=kube-public -o custom-columns="NAMESPACE":.metadata.name --no-headers))

for namespace in "${PDB_NAMESPACES[@]}"
do 
    DEPLOYMENT_WITHOUT_PDB+=($(kubectl get deployments --selector='!    pdb' -n "$namespace" -o custom-columns="NAME":.metadata.name --no-headers))
    for deployment in "${DEPLOYMENT_WITHOUT_PDB[@]}"
    do
        kubectl label deployment "$deployment" pdb="$deployment" -n "$namespace"
        cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata: 
  name: $deployment-pdb
  namespace: $namespace
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      pdb: $deployment
EOF
    done
done