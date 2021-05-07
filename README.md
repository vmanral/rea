Prerequisites:
-------------
A. AWS account: 
  1. create one IAM user with Security credentials having appropriate permissions (AmazonEC2FullAccess and ElasticLoadBalancingFullAccess) for creating the AWS EC2, ELB and Security Groups
  2. Have a EC2 key pair

B. Linux (Ubuntu 18.04.5 LTS) machine:
  1. Install Terraform as per https://www.terraform.io/docs/cli/install/apt.html
  2. Install AWS CLI as per https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
  3. Install Ansible as per https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu


Steps to setup the Sinatra app:
------------------------------
1. Login into the Ubuntu machine (B from Prerequisites) and clone the git repo
	- git clone https://github.com/vmanral/rea.git 
2. Modify the values of the variables in ./rea/build_infra/variables.tf as per your environment
	- the Ubuntu AMI may be tied to the specific AWS region
3. Execute "aws configure" and set the credentials of the IAM user (A.1 from Prerequisites)
4. cd to ./rea/build_infra/ folder and execute the below commands to create the AWS infrastructure
	- terraform init
	- terraform plan
	- terraform apply
- the AWS instructure could be visualized in ./rea/terraform_plan.png
5. Identify the IP addresses of the EC2 instances and the address of the ELB
6. Copy the AWS key pair (A.2 from Prerequisites) under /tmp folder and provide 500 permission to it
	- chmod 500 /tmp/aws_devops.pem
	- update the name of the key at ./rea/configure_infra/group_vars/linux_sinatra.yml
8. Update the IP addresses of the AWS EC2 instances in the ./rea/configure_infra/ansible_hosts file
9. Execute the ansible playbook
 	- cd ./rea/configure_infra/
 	- ansible-playbook -i ./ansible_hosts sinatra.yml
10. login into both the AWS EC2 instances with user "ubuntu" and then the web server starts automatically
11. Verify the web servers by executing http://<ec2_ip_address>/ in a web browser
12. Verify the ELB by executing the ELB address, 
	- example: http://internal-r-elb-40015396.us-west-2.elb.amazonaws.com/ in a web browser


Further Improvements:
--------------------
1. The configuration of the prerequisites on the Ubuntu (B from Prerequisites) could itself be automated
2. All the steps to setup the Sinatra app could also be automated using a wrapper script written in Python or through Jenkins
3. I think step 10 could be eliminated by autostarting the Sinatra app on machine reboot. And then the SSH and ICMP security groups could be eliminated to harden the security
4. Autoscaling could also be added to the ELB based upon the need
