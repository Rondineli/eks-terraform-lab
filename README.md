### How to run

```
terraform init
terraform get
terraform plan -var aws_access_key=$AWS_ACCESS_KEY_ID -var aws_region=$AWS_REGION -var aws_secret_key=$AWS_SECRET_ACCESS_KEY' -var key_name=<my key name> -var eks-cluster-name=<my eks name>
```
