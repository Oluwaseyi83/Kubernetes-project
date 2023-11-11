# Use link for velero setup article 
https://katharharshal1.medium.com/backup-and-restore-eks-kubernetes-using-velero-32b11cb55b81

Install Velero https://velero.io/docs/main/basic-install/#velero-on-windows 
- Windows:

```bash
choco install velero
```

- MacOs:
 
```bash
brew install velero
```

1. Create s3 bucket and provide any name of your choice

2. Create new IAM user or use exisint IAM user and add the below permission to the user.

   ***N.B replace ${VELERO_BUCKET} with S3 bucket name which we created for velero.***

   ```
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${VELERO_BUCKET}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${VELERO_BUCKET}"
            ]
        }
    ]

   }


3. Add user credentials to your local system

```bash
aws configure
```

4. Verify installation of velero

```bash
velero version
```

5. Deploy velero on EKS 

***replace your bucket name, region, and credentials path in the command.***

```bash
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.0.1 \
    --bucket <bucketname>\
    --backup-location-config region=<region> \
    --snapshot-location-config region=<region> \
    --secret-file ~/.aws/credentials
```

6. Inspect the resources created

```bash
kubectl get all -n velero
```

7. Deploy any test applications regardless of namespaces

```bash
kubectl apply -f <name of file>
```

# BACKUP and RESTORE

Lets implement backup ajnd restore operations with velero now

1. backup based on namepsace

```bash
velero backup create <backupname> --include-namespaces <namespacename>
```
2. Check status of backup

```bash
velero backup describe <backupname>
```

3. Check-in S3 bucket to see if backup is stored in the S3 bucket created at the start of the guide

4. Let’s delete the namespace where apps are deployed to simulate a disaster

```bash
kubectl delete namespace <namespace>
```

5. Restore backups

```bash
velero restore create --from-backup <backupname>
```

6. Verify deployments/pods, resources etc and confirm they were restored

```bash
kubectl get all -n <namespace>
```


# Here are some useful commands for velero :
## Backup:

```bash
# Create a backup every 6 hours with the @every notation
velero schedule create <SCHEDULE_NAME> --schedule="@every 6h"

# Create a daily backup of the namespace
velero schedule create <SCHEDULE_NAME> --schedule="@every 24h" --include-namespaces <namspacename>

# Create a weekly backup, each living for 90 days (2160 hours)
velero schedule create <SCHEDULE_NAME> --schedule="@every 168h" --ttl 2160h0m0s     
##default TTL time is 720h
# Create a backup including the test and default namespaces
velero backup create backup --include-namespaces test,default

# Create a backup excluding the kube-system and default namespaces
velero backup create backup --exclude-namespaces kube-system,default
# To backup entire cluster
velero backup create <BACKUPNAME>
#To backup namespace in a cluster
velero backup create <BACKUPNAME> --include-namespaces <NAMESPACENAME>

```

## Restore:

```bash
#Manual Restore
velero restore create --from-backup <backupname>
#Scheduled Backup
velero restore create <RESTORE_NAME> --from-schedule <SCHEDULE_NAME>
# Create a restore including the test and default namespaces
velero restore create --from-backup backup --include-namespaces nginx,default

# Create a restore excluding the kube-system and default namespaces
velero restore create --from-backup backup --exclude-namespaces kube-system,default
#Retrieve restore logs
velero restore logs <RESTORE_NAME>
```


# Uninstall VElero

```bash
velero uninstall
```