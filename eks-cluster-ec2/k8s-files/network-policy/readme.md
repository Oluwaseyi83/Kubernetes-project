Setup calico

- install helm 
 - windows: 
 ```bash
 choco install kubernetes-helm
 ```
 - macos: 
 ```bash
 brew install helm
 ```

- Download helm chart for calico
```bash
helm repo add projectcalico https://docs.tigera.io/calico/charts
```
- If you are installing on a cluster installed by EKS, GKE, AKS or Mirantis Kubernetes Engine (MKE), set the kubernetesProvider as described in the Installation reference.
copy the code below and run on your terminal.

```bash
cat > values.yaml <<EOF
imagePullSecrets: {}

installation:
  enabled: true
  kubernetesProvider: "EKS"

apiServer:
  enabled: true

certs:
  node:
    key:
    cert:
    commonName:
  typha:
    key:
    cert:
    commonName:
    caBundle:

# Resource requests and limits for the tigera/operator pod.
resources: {}

# Tolerations for the tigera/operator pod.
tolerations:
- effect: NoExecute
  operator: Exists
- effect: NoSchedule
  operator: Exists

# NodeSelector for the tigera/operator pod.
nodeSelector:
  kubernetes.io/os: linux

# Custom annotations for the tigera/operator pod.
podAnnotations: {}

# Custom labels for the tigera/operator pod.
podLabels: {}

# Image and registry configuration for the tigera/operator pod.
tigeraOperator:
  image: tigera/operator
  version: v1.29.6
  registry: quay.io
calicoctl:
  image: docker.io/calico/ctl
  tag: v3.25.2
EOF
```
- Create the tigera-operator namespace.
```bash 
kubectl create namespace tigera-operator
```

- Install the Tigera Calico operator and custom resource definitions using the Helm chart:
```bash 
helm install calico projectcalico/tigera-operator --version v3.25.2 -f values.yaml --namespace tigera-operator
```

- View the resources in the tigera-operator namespace
```bash
kubectl get all -n tigera-operator
```

- kubectl get all -n calico-system
```bash
kubectl get all -n calico-system
```

- Confirm that the logs for one of your calico-node, calico-typha, and tigera-operator Pods don't contain ERROR. Replace the pod name values in the following commands with the values returned in your output for the previous steps.
```bash
kubectl logs tigera-operator-768d489967-6cv58 -n tigera-operator | grep ERROR
kubectl logs calico-node-khw4w -c calico-node -n calico-system | grep ERROR
kubectl logs calico-typha-696bcd55cb-49prr -n calico-system | grep ERROR
```

- If you're using version 1.9.3 or later of the Amazon VPC CNI plugin for Kubernetes, then enable the plugin to add the Pod IP address to an annotation in the calico-kube-controllers-55c98678-gh6cc Pod spec. For more information about this setting, see ANNOTATE_POD_IP on GitHub. See which version of the plugin is installed on your cluster with the following command.

```bash
kubectl describe daemonset aws-node -n kube-system | grep amazon-k8s-cni: | cut -d ":" -f 3
```

- Create a configuration file that you can apply to your cluster that grants the aws-node Kubernetes clusterrole the permission to patch Pods.
```bash
cat << EOF > append.yaml
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - patch
EOF
```

- Apply the updated permissions to your cluster.

```bash
kubectl get clusterrole aws-node -o yaml > tempfile.yaml
cat tempfile.yaml append.yaml | kubectl apply -f -
rm tempfile.yaml
```
- Set the environment variable for the plugin.

```bash
kubectl set env daemonset aws-node -n kube-system ANNOTATE_POD_IP=true
```

- Delete the calico-kube-controllers-55c98678-gh6cc
```bash
kubectl delete pod calico-kube-controllers-55c98678-gh6cc -n calico-system
```

- View the Pods in the calico-system namespace again to see the ID of the new calico-kube-controllers Pod that Kubernetes replaced the calico-kube-controllers-55c98678-gh6cc Pod that you deleted in the previous step with.

```bash
kubectl get pods -n calico-system
```

- Confirm that the vpc.amazonaws.com/pod-ips annotation is added to the new calico-kube-controllers Pod. Replace 5cd7d477df-2xqpd with the ID for the Pod returned in a previous step.

```bash
kubectl describe pod calico-kube-controllers-5cd7d477df-2xqpd -n calico-system | grep vpc.amazonaws.com/pod-ips
```

- deploy pods and test connection with example below
```bash
kubectl exec -it -n application <name of pod a> -- <curl ip of pod b>
```


- Remove Calico from your cluster using Helm.
```bash
helm uninstall calico
```
