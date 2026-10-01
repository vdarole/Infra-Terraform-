**Build On-Prem Server Using Terraform**
This document describes how to build an on-premises virtual machine on VMware vSphere using Terraform from a Windows server.

1. Prerequisites
Before starting, ensure the following are available:
> Windows server: win01
> VMware vCenter Server is installed and accessible
> vCenter build/configuration is completed
> VMware vSphere environment is ready
> Terraform configuration files are available
> Terraform executable (terraform.exe) is downloaded
> Required VM templates are available in vCenter
> Network and datastore configuration is available

2. Login to Windows Server
Login to the win01 Windows server.
Open PowerShell or Command Prompt with the required permissions.

3. Create Terraform Directory
Create the Terraform working directory:
# mkdir C:\terraform-vsphere
# cd C:\terraform-vsphere

4. Download Terraform
Download the Terraform Windows executable and copy terraform.exe to:
# C:\terraform-vsphere
Verify Terraform:
#.\terraform.exe version
Expected output will show the installed Terraform version.

5. Download Terraform Configuration
Copy/download the required Terraform configuration files into:
C:\terraform-vsphere
Example:
C:\terraform-vsphere
│
├── terraform.exe
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── README.md
Keep the Terraform configuration files in the same working directory unless the configuration uses another module/file structure.

6. Initialize Terraform
Run Terraform initialization:
# .\terraform.exe init
This downloads the required Terraform providers and initializes the working directory.

7. Format Terraform Configuration
Format the Terraform files:
# .\terraform.exe fmt
To see which files would be changed:
# .\terraform.exe fmt -check

8. Validate Terraform Configuration
Validate the Terraform configuration:
# .\terraform.exe validate
Expected result:
Success! The configuration is valid.

9. Create the ANS01 Server
The following commands can be used to create the ans01 VM.

9.1 Create Terraform Plan
# .\terraform.exe plan -target="vsphere_virtual_machine.ans01"
Review the resources that Terraform plans to create.

9.2 Apply the Configuration
After reviewing the plan:
# .\terraform.exe apply -target="vsphere_virtual_machine.ans01"

Terraform will display the proposed changes.
Enter:
yes
when prompted.

10. Recommended Method — Save the Terraform Plan
For controlled server deployment, generate a plan file first:
# .\terraform.exe plan -target="vsphere_virtual_machine.ans01" -out=ans01.tfplan
Review the plan.
If everything is correct, apply the saved plan:
# .\terraform.exe apply ans01.tfplan
This ensures that the configuration being applied is the same configuration that was reviewed during the planning stage.

11. Create DOCK01 Server
To create the dock01 virtual machine:

11.1 Validate Configuration
# .\terraform.exe validate

11.2 Create Plan
# .\terraform.exe plan -target="vsphere_virtual_machine.dock01"

11.3 Apply Configuration
# .\terraform.exe apply -target="vsphere_virtual_machine.dock01"

Confirm with:
yes
when prompted.

12. Terraform Commands Used
Purpose	Command
Initialize Terraform	.\terraform.exe init
Format configuration	.\terraform.exe fmt
Validate configuration	.\terraform.exe validate
Plan ANS01	.\terraform.exe plan -target="vsphere_virtual_machine.ans01"
Apply ANS01	.\terraform.exe apply -target="vsphere_virtual_machine.ans01"
Save ANS01 plan	.\terraform.exe plan -target="vsphere_virtual_machine.ans01" -out=ans01.tfplan
Apply saved plan	.\terraform.exe apply ans01.tfplan
Plan DOCK01	.\terraform.exe plan -target="vsphere_virtual_machine.dock01"
Apply DOCK01	.\terraform.exe apply -target="vsphere_virtual_machine.dock01"
13. Important Terraform Syntax

Use the following syntax for targeting a specific VM:

.\terraform.exe plan -target="vsphere_virtual_machine.ans01"
.\terraform.exe apply -target="vsphere_virtual_machine.ans01"

For dock01:

.\terraform.exe plan -target="vsphere_virtual_machine.dock01"
.\terraform.exe apply -target="vsphere_virtual_machine.dock01"
Incorrect Syntax

Do not use:

-target=vsphere_virtual_machine = ans01

or:

-target=vsphere_virtual_machine=ans01

The Terraform resource address must use a dot (.) between the resource type and resource name:

vsphere_virtual_machine.ans01
14. Complete ANS01 Deployment

The recommended sequence is:

cd C:\terraform-vsphere

.\terraform.exe init

.\terraform.exe fmt

.\terraform.exe validate

.\terraform.exe plan -target="vsphere_virtual_machine.ans01" -out=ans01.tfplan

.\terraform.exe apply ans01.tfplan
15. Complete DOCK01 Deployment

The recommended sequence is:

cd C:\terraform-vsphere

.\terraform.exe validate

.\terraform.exe plan -target="vsphere_virtual_machine.dock01" -out=dock01.tfplan

.\terraform.exe apply dock01.tfplan
16. Verify Deployment

After Terraform completes successfully, verify the VM in vCenter.

Check:

VM exists
VM is powered on
Correct CPU and memory
Correct datastore
Correct network
Correct disk size
Correct VM template
IP address assigned
Operating system boots successfully
SSH connectivity is available

Example:

vCenter
  |
  +-- Datacenter
       |
       +-- Cluster
            |
            +-- ans01
            |
            +-- dock01
17. Troubleshooting
Terraform command not found

Verify that terraform.exe exists:

dir C:\terraform-vsphere\terraform.exe

Run:

.\terraform.exe version
Configuration validation failure

Run:

.\terraform.exe validate

Review the error message and correct the .tf files.

Then run:

.\terraform.exe fmt
.\terraform.exe validate
Plan shows unexpected changes

Run:

.\terraform.exe plan -target="vsphere_virtual_machine.ans01"

Review:

Template
Datastore
Network
CPU
Memory
Disk
VM name

Do not apply the configuration until the plan is understood.

18. Recommended Deployment Workflow

Use the following workflow for each new VM:

Login to win01
      |
      v
Create C:\terraform-vsphere
      |
      v
Copy terraform.exe
      |
      v
Copy Terraform configuration
      |
      v
terraform init
      |
      v
terraform fmt
      |
      v
terraform validate
      |
      v
terraform plan
      |
      v
Review plan
      |
      v
Save plan file
      |
      v
terraform apply <plan-file>
      |
      v
Verify VM in vCenter
      |
      v
Verify OS / Network / SSH
19. Notes
Prefer plan followed by apply <plan-file> for controlled deployments.
Use -target only when you intentionally need to operate on a specific resource.
Before applying changes, always review the Terraform plan.
Keep Terraform configuration and state files protected.
Do not commit passwords, vCenter credentials, or other secrets into Git.
For production environments, use a secure mechanism for Terraform variables and credentials.
20. Quick Reference
ANS01
cd C:\terraform-vsphere

.\terraform.exe init
.\terraform.exe fmt
.\terraform.exe validate

.\terraform.exe plan -target="vsphere_virtual_machine.ans01" -out=ans01.tfplan

.\terraform.exe apply ans01.tfplan
DOCK01
cd C:\terraform-vsphere

.\terraform.exe validate

.\terraform.exe plan -target="vsphere_virtual_machine.dock01" -out=dock01.tfplan

.\terraform.exe apply dock01.tfplan
