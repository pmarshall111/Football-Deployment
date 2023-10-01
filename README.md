<h1>Terraform & Ansible IAC files for Football Betting Project</h1>

<h2>To Setup</h2>

1. Clone project, create ansible user on the local machine, and grant access to project
```bash
git clone <githubUrl>
adduser ansible
chmod -R 774 TerraformFootball
chgrp -R ansible TerraformFootball
```

2. Setup EC2 server with Terraform. Use -var-file to specify the file containing terraform variables:
```bash
terraform apply -var-file {...}
```

3. Update the IP of the ansible host and add an entry to your hosts file.

```bash
./scripts/update_ec2_ip.sh
```

4. Create SSH keys for each user, ensuring the file names match those specified in group_vars/all.yaml

```bash
peter@chronos:~$ sudo su ansible
ansible@chronos:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ansible/.ssh/id_rsa): github-actions-frontend
```


5. Run Ansible to set up configuration on the host:

```bash
cd ansible
sudo su ansible
ansible-playbook provision_football.yaml --extra-vars "@tf_ansible_vars.yaml" --extra-vars "TOMCAT_PASS=__your_password__"
```

6. Add the SSH_PRIVATE_KEY, SSH_USER, SSH_HOST secrets to each project's GitHub Actions to enable CI/CD

7. A push to GitHub will then be required to deploy each project to the new machine