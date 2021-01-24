# terraform-eks
all the necessary IaC to configure AWS EKS with spot instances using Terraform

after completion of infrastructure creation run this command
to generate kubeconfig:

```aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)```

in case when you run command ```terraform destroy``` you recive error ```Error: Unauthorized```
use this command to resolve issue: ```terraform state rm 'module.eks.kubernetes_config_map.aws_auth[0]'```
