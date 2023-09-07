
kubectl exec -it <pod-name> -c mysql -- mysql -u root -p  # Sign into mysql database by using password configured as secret