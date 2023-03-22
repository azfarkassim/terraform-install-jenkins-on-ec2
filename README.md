# terraform-install-jenkins-ec2

## Create AWS named profile
1. Install AWS CLI - [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. Create AWS access keys - [AWS Access Keys](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
3. Configure AWS access keys on your machine - ```aws configure --profile terraform```
4. Enter ```aws_access_key_id``` and ```aws_secret_access_key``` created

## Create EC2 Key Pair
1. Create .pem EC2 key pair - [Create Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)
2. Save the key pair on your local machine
3. Modify ec2.tf file for ```key_name``` and ```private_key``` according to the key pair name

## Apply Terraform Config
1. Initialize Terraform - ```terraform init```
2. View Terraform plan - ```terraform plan```
3. Apply Terraform plan - ```terraform apply```

### Apply Jenkins Initial Admin Password
1. Copy ```InitialAdminPassword``` printed on terminal
2. Go to Jenkins URL printed on terminal
3. Enter ```InitialAdminPassword``` in Unlock Jenkins window
4. Install the necessary Jenkins plugins
5. Jenkins is now ready to use!

### Destroy Terraform
1. Destroy Terraform - ```terraform destroy```

