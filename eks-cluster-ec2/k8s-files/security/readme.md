## https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html 

cat ~/.kube/config # read content from kubeconfig

kubectl config get-contexts # List available contexts

kubectl config current-context # Display the current context

kubectl config use-context <context-name> # switch context to a different context

kubectl config set-context <context-name> --cluster=<cluster-name> --user=<user-name> --namespace=<namespace> # Set a new context by specifying cluster, user, and namespace

kubectl config delete-context <context-name> # Delete context


kubectl config rename-context <old-context-name> <new-context-name> # Rename context from old to new name




## Steps to implement RBAC
- Create a new IAM Role in AWS
- Assign eks permission or Admin permission
- Edit ConfigMap AUth and add the name of the user or add group (if user is in any group)

  > kubectl edit -n kube-system configmap/aws-auth # edit your aws-auth ConfigMap to add users and groups

- configure a Cluster role and a cluster role binding with the required permissions in the cluster
- Deploy the cluster role amnd role binding
- deploy your k8s workloads

- update profile on cli by running the commands below:
  - aws configure --profile <profile-name> # Provide credentials for new user created above
  - export AWS_PROFILE=<name of profile> # to set profile to a current profile
  - aws sts get-caller-identity # Run command to confirm current profile

- kubectl describe -n kube-system configmap/aws-auth # Get details about aws_auth config for your cluster

- Attempt to run a comand that will go contrary to the permissions of the user



## Template for CONFIGMAPAUTH

# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::389029577690:role/jjtech-demo-cluster-node-group_role
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::389029577690:user/k8s-user
      username: jjtech-user
      groups:
        - system:masters
kind: ConfigMap
metadata:
  creationTimestamp: "2023-06-24T18:24:12Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "50777"
  uid: f1ff4023-148e-43ef-986f-dc90f9e6e223



