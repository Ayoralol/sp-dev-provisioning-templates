## Site Generation Script

The script is written within [./tenant/contosoworks/script.ps1](./tenant/contosoworks)

The script is written to be able to be used with any template, simply move the script into the folder above /source/ that contains your template.xml  
It will take the /source/ folder and create a template.pnp out of it, upload the template to "Shared Documents" on SharePoint, and use that to apply to the sites.  
The script first prompts your credentials and creates a credentials.xml file within the same folder as the script, and can then be used on subsequent executions

### Script Requirements

- Install-Module PnP.Powershell
- Install-Module ThreadJob

- Edit the script file to output the desired amount of sites and batch amounts
- **add credentials.xml to .gitignore**

## #6 On demand via Azure

To apply this template on demand via Azure, we could create a Function App on the Azure portal and make the runtime stack Powershell  
We could make this function a HTTP trigger and configure it to user a PowerShell script that applies the SharePoint template  
To use the same script that I wrote, I could edit it to accept parameters via the HTTP request  
Then deploy the script to the Azure function and trigger it with the HTTP request using the correct parameters

## #7 Azure solution on other systems

The Azure function triggered via HTTP endpoint makes it accessible through REST API calls, Allowing for integration with other apps/pipelines/automation tools

Azure Logic Apps can also connect to Sharepoint and create automated workflows that can create and apply templates to SharePoint sites based on events or schedules

# SharePoint Provisioning Templates

Repository for SharePoint PnP Provisioning templates to automate site / tenant level provisioning logic. Templates are divided on different folders based on the structure and needed permissions.

- Site - These templates contain site level provisioning logic. They can be provisioned and used by any site collection administrator and no tenant scoped permissions are needed.

- Tenant - These templates contain tenant level provisioning. They could contain for example multiple site collections, site designs, taxonomy configurations etc. You will need to have tenant level permissions to apply these templates.

Sub folders in specific folders are actual templates. Each template has at least one screenshot file and readme file. The readme file should follow the readme template available in the root of this repository. Each template also has a mandatory json file, which has to follow the provided json file structure. This json file information is used to surface metadata on a web site from where the templates can be used.

# Contributing

This project welcomes contributions and suggestions on service texts, but not for the templates. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
