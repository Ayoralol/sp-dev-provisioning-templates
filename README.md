# Site Generation Script

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
