# MySQL-and-Python
 Flask app https://github.com/uym2/MySQL-and-Python deployed on AWS by using EKS and ECR 
 By using terraform will create EKS , ECR , EC2 (act as Jenkins)
 By anible will deploy jenkins installation , docker , aws cli , Kubectl ....
 Kuberentes to trigger all files (deplyment , statefullset , confige map , vp , vpc .....)
 # Terraform
 - EKS into 2 Nodes 
 - EC2
- 2 ECR
- 
```
- terraform init
- terraform apply
```
 # Ansible
 - Install Jenkins
 - Configure Jenkins access
 - Install dependances (Docker , aws cli , Kubectl ,.....)
 # Jenkins 
 - add credential Dashboard > Manage Jenkins > Credentials > system > Global credentials (unrestricted) + Add Credentials 
 -  add (secert key , access key ,...)
 - add Github token 
 
 
