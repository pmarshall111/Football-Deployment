<h1>Terraform & Ansible IAC files for Football Betting Project</h1>

<h2>To Setup</h2>

1. Setup EC2 server with Terraform:
```bash
terraform apply
```

2. Update the IP of the ansible host and add an entry to your hosts file.

```bash
./scripts/update_ec2_ip.sh
```

3. Run Ansible to set up Software on the host:

```bash
cd ansible
sudo su ansible
ansible-playbook provision_football.yaml --extra-vars "TOMCAT_PASS=__your_password__"
```