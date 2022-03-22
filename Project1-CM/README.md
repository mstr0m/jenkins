# Project 1: Automating Infrastructure using Terraform

# STEPS
1. Generate ssh keypair to manage AWS VM  
    ssh-keygen -t rsa -f ~/.ssh/aws-rsa  
2. Copy vars.tf.example to vars.tf and fill it with your AWS credentials  
3. Run terraform  
    terrafrom init  
    terrafrom plan  
    terrafrom apply  
4. Open Jenkins URL and use Jenkins initialAdminPassword to connect and unlock (provided in ansible output)