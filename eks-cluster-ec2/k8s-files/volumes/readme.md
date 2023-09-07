# Create efs file system for EKS storage
## To create an Amazon Elastic File System (EFS) cluster and configure it for use with Amazon Elastic Kubernetes Service (EKS), you need to follow these steps:

### Set up an Amazon EFS File System:

- Ensure your eks cluster is up and running
- Go to the AWS Management Console and navigate to the Amazon EFS service.
Click on "Create file system" and configure the settings for your EFS file system, such as the **name** and the **vpc** in which your cluster is configred. Note down the File System ID (e.g., fs-12345678), as you will need it later.
Create a Mount Targets:


### Set up EFS Provisioner and RBAC Roles:

- You need to deploy an EFS CSI (Container Storage Interface) provisioner in your EKS cluster. This provisioner manages the dynamic provisioning of EFS volumes.
Clone the EFS CSI Driver repository from GitHub:

> git clone https://github.com/kubernetes-sigs/aws-efs-csi-driver.git.

- Navigate to the kubernetes directory by running the follwoing command:

> cd aws-efs-csi-driver/deploy/kubernetes

- Apply the EFS CSI driver manifests by running the following command:
> kubectl apply -k base

This will create the required RBAC roles, ServiceAccount, and the EFS CSI driver deployment in your cluster.
Create a StorageClass, PersistentVolume, and PersistentVolumeClaim (as mentioned in the previous response) to define the EFS storage resources for your applications.

### Deploy your application:

- Write or modify your application's deployment or pod configuration file to include a volume and volume mount referencing the PersistentVolumeClaim (PVC) you created.

- Apply the configuration using 
> kubectl apply -f <your-config-file.yaml>.

- Once you have completed these steps, the EFS provisioner will dynamically create the PersistentVolumes based on the PVCs requested by your application pods. The EFS volumes will be mounted to the pods, providing persistent storage.

- Remember to adjust the configuration settings, such as storage capacity, access modes, and networking and filesystemID to match your specific requirements and cluster setup.

>

## https://kubernetes.io/docs/concepts/storage/volumes/#local # Volume config for hostpath
## https://kubernetes.io/docs/concepts/storage/persistent-volumes/  # For kubernetes PErsistent volumes
## https://kubernetes.io/docs/concepts/storage/storage-classes/#local # For storage classes