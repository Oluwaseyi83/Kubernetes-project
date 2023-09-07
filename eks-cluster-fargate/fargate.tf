# To run CoreDNS or any other application in AWS Fargate, first, you need to create a Fargate profile. 
# It is a setting that allows EKS automatically create nodes for your application based on 
# Kubernetes namespace and optionally pod labels.

# We need to create a single IAM role that can be shared between all the Fargate profiles. Similar to EKS, 
# Fargate needs permissions to spin up the nodes and connect them to the EKS control plane.

resource "aws_iam_role" "eks-fargate-profile" {
  name = "eks-fargate-profile"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


# Then we need to attach AWS managed IAM policy called AmazonEKSFargatePoExecutionRolePolicy.

resource "aws_iam_role_policy_attachment" "eks-fargate-profile" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-fargate-profile.name
}


# For the AWS Fargate profile, we need to specify the EKS cluster. 
# Then the name, I usually match it with the Kubernetes namespace and an IAM role. 
# When you select subnets for your profile, make sure that you have appropriate tags with cluster name. 
# Finally, you must specify the Kubernetes namespace that you want AWS Fargate to manage. 
# Optionally you can filter by pods labels.


resource "aws_eks_fargate_profile" "kube-system" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn

  # These subnets must have the following resource tag: 
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  selector {
    namespace = "kube-system"
  }
}

# Create another fargate profile for all our applications that will run in the application namesoace
resource "aws_eks_fargate_profile" "application" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "application"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn

  # These subnets must have the following resource tag: 
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  selector {
    namespace = "application"
  }
}




