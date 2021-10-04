<h1>Terraform & Ansible IAC files for Football Betting Project</h1>

<h2>To Setup</h2>

1. Clone project, create ansible user on the local machine, and grant access to project
```bash
git clone <githubUrl>
adduser ansible
chmod -R 774 TerraformFootball
chgrp -R ansible TerraformFootball
```

2. Setup EC2 server with Terraform:
```bash
terraform apply
```

3. Update the IP of the ansible host and add an entry to your hosts file.

```bash
./scripts/update_ec2_ip.sh
```

4. Run Ansible to set up configuration on the host:

```bash
cd ansible
sudo su ansible
ansible-playbook provision_football.yaml --extra-vars "@tf_ansible_vars.yaml" --extra-vars "TOMCAT_PASS=__your_password__"
```