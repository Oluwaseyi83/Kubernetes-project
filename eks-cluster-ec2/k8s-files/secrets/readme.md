
kubectl exec -it <pod-name> -c mysql -- mysql -u root -p  # Sign into mysql database by using password configured as secret

1. Run the commands on your terminal to encode the passwords

```bash
echo -n "your-root-password" | base64
echo -n "your-username" | base64
echo -n "your-user-password" | base64
```

2. Run following command to decode password

```bash
echo "cm9vdC1wYXNzd29yZA==" | base64 --decode
```

3. Sign into mysql database by using password configured as secret

```bash
kubectl exec -it <pod-name> -c mysql -- mysql -u root -p
```

4. Exit the mysql prompt with 

```bash
\q
```