#/bin/bash

CLUSTER_NAME=$1
KEY_NAME=$2


checkingEnvVars() {
    if [ -z $AWS_REGION ] ; then echo "please set AWS_REGION var using export AWS_REGION=xxxxxx"; exit 1 ; else echo "$AWS_REGION"; fi
    if [ -z $AWS_ACCESS_KEY_ID ] ; then echo "please set AWS_ACCESS_KEY_ID var using export AWS_ACCESS_KEY_ID=xxxxxx"; exit 1 ; else echo "$AWS_ACCESS_KEY_ID"; fi
    if [ -z $AWS_SECRET_ACCESS_KEY ] ; then echo "please set AWS_SECRET_ACCESS_KEY var using export AWS_SECRET_ACCESS_KEY=xxxxxx"; exit 1 ; else echo "$AWS_SECRET_ACCESS_KEY"; fi
    if [ -z $CLUSTER_NAME ] ; then echo "please use CLUSTER_NAME to set eks master name"; exit 1 ; else echo "$CLUSTER_NAME"; fi
    if [ -z $KEY_NAME ] ; then echo "please use KEY_NAME to set the key pair names to your cluster"; exit 1 ; else echo "$KEY_NAME"; fi
}


checkingEnvVars

echo "running terrafor init..."
terraform init

echo "importing modules..."
terraform get

echo "running plann..."
terraform plan -out my_plan -var aws_access_key=$AWS_ACCESS_KEY_ID -var aws_region=$AWS_REGION -var aws_secret_key=$AWS_SECRET_ACCESS_KEY -var eks-cluster-name=$CLUSTER_NAME -var key_name=$KEY_PAIR_NAME


echo "Applying, it maybe will aks you to proceed"
terraform apply -var aws_access_key=$AWS_ACCESS_KEY_ID -var aws_region=$AWS_REGION -var aws_secret_key=$AWS_SECRET_ACCESS_KEY -var eks-cluster-name=$CLUSTER_NAME -var key_name=$KEY_PAIR_NAME


mkdir $HOME/.eks_tools


curl -o  $HOME/.eks_tools/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/kubectl
chmod +x $HOME/.eks_tools/kubectl

curl -o $HOME/.eks_tools/heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
chmod +x $HOME/.eks_tools/heptio-authenticator-aws

export PATH=$PATH:$HOME/.eks_tools

echo 'export PATH=$HOME/.eks_tools:$PATH' >> ~/.bashrc

arn_output=$(terraform output -module=policy instance_profile_arn)
account_id_for_role=$(echo "$arn_output" |cut -d ":" -f 5)
role_name=$(echo "$arn_output" |cut -d ":" -f 6 |cut -d "/" -f 2)

if [ -d ~/.kube ]; then echo "kube dir exists...moving on"; else mkdir ~/.kube; fi

terraform output -module=eks kubeconfig > ~/.kube/config-aws-terraform-poc


export KUBECONFIG=$KUBECONFIG:~/.kube/config-aws-terraform-poc
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-aws-terraform-poc' >> ~/.bashrc

sed -i s,AWS_ACCOUNT_ID,$account_id_for_role,g aws-auth-cm.yaml
sed -i s,AWS_EKS_ROLE,$role_name,g aws-auth-cm.yaml

kubectl apply -f aws-auth-cm.yaml

kubectl get nodes --watch

