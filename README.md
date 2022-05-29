# DRaC - Disaster Recovery as Code
Source code for the Master's thesis "Feasibility of Infrastructure-as-Code for Web Application Disaster Recovery"

## Binary application versions
* ansible 2.9.25
* Terraform v1.0.9
* aws-cli 2.3.0 

## Ansibe setup
Install the required community collections
```ansible-galaxy collection install community.general```

### ansible.cfg
```
[defaults]
gathering = explicit
callback_whitelist = profile_tasks
```
