#!/bin/bash
# Wrapper functions:
# Run command on EC2 via SSH
ec2cmd () {
  ssh -i ~/.ssh/ansible_rsa -l ec2-user $1 $2
}
# Copy a file from EC2 via SCP
ec2cp () {
  scp -i ~/.ssh/ansible_rsa ec2-user@$1 $2
}


############################################
echo "Get IP Addresses from Terraform state"
############################################
echo "Get IP addresses from Terraform state"
cd terraform
OWS=$(terraform workspace show)
terraform workspace select primary
APPIP=$(terraform output -raw app_ip)
DBIP=$(terraform output -raw db_ip)
SEIP=$(terraform output -raw se_ip)
WEBIP=$(terraform output -raw web_ip)
terraform workspace select $active_workspace
cd ..

echo "web: $WEBIP"
echo "app: $APPIP"
echo "db: $DBIP"
echo "search: $SEIP"


#############################
echo "Stop NGINX and Liferay"
#############################
ec2cmd $WEBIP "sudo systemctl stop nginx"
ec2cmd $APPIP "sudo systemctl stop liferay-portal"


##########################
echo "Run backup commands"
##########################
ec2cmd $APPIP "cd /opt/liferay/ && sudo tar cvzf osgi.tar.gz liferay-ce-portal-7.4.2-ga3/osgi"
ec2cmd $APPIP "cd /opt/liferay/ && sudo tar cvzf properties.tar.gz liferay-ce-portal-7.4.2-ga3/portal-setup-wizard.properties"
ec2cmd $APPIP "cd /opt/liferay/ && sudo tar cvzf license.tar.gz liferay-ce-portal-7.4.2-ga3/license"
ec2cmd $APPIP "cd /opt/liferay/ && sudo tar cvzf data.tar.gz liferay-ce-portal-7.4.2-ga3/data"
ec2cmd $APPIP "sudo chown ec2-user:root /opt/liferay/*tar.gz"
ec2cmd $DBIP "sudo -u postgres pg_dumpall --clean --file=/tmp/dump.sql"


################################
echo "Copy from remote to local"
################################
ec2cp $APPIP:/opt/liferay/osgi.tar.gz backups/lr/
ec2cp $APPIP:/opt/liferay/properties.tar.gz backups/lr/
ec2cp $APPIP:/opt/liferay/data.tar.gz backups/lr/
ec2cp $APPIP:/opt/liferay/license.tar.gz backups/lr/
ec2cp $DBIP:/tmp/dump.sql backups/db/


##############################
echo "Start NGINX and Liferay"
##############################
ec2cmd $APPIP "sudo systemctl start liferay-portal"
ec2cmd $WEBIP "sudo systemctl start nginx"
