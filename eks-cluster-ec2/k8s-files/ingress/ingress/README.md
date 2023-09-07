Create nginx controller
------
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/aws/deploy.yaml

``` For more info refer https://kubernetes.github.io/ingress-nginx/deploy/ ```

# Patch ingress to remove finaliszers when delete is pending/jhanging
- kubectl patch ingress $Ingressname -n $namespace -p '{"metadata":{"finalizers":[]}}' --type=merge