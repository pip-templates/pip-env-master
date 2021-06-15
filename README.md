# Overview

This is a master template for scripted environment management.
The Environment Management scripts are used to create, update or delete operating environments.
Depending on requirements, they can be used for development, testing and production.

The scriptable environments follow "Infrastructure as a Code" principles and allow to:
* Have controllable and verifiable environment structure
* Quickly spin up fully-functional environments in minutes
* Minimize differences between environments
* Provide developers with environment to run and test their components integrated into the final system and expand their area of responsibilities

Environment management templates separated by their functions and platforms - aws/azure cloud providers, kubernetes clusters, database clusters (mongodb, couchbase). They all stored on [github](https://github.com/pip-templates)

# Usage

Before you can use environment management scripts you need to get build-in templates and put them to master template. You can view how to do it in [Example of combining kubernetes and database template](#combine-kubernetes-and-database-template).

Environment management scripts should be executed from management station. If you are using local environment (minikube) then you machine considered as management station and you can skip this step. Management station can be created by create_mgmt.ps1 script

`
./create_mgmt.ps1 -c <path to config file>
`

This script will create cloud virtual machine and copy environment management project to /home/ubuntu/pip-templates-envmgmt

Then you need to install prerequisites on management station. That step is required to be done once:

`
./install_prereq_<os>.ps1
`

To create a new environment prepare an [environment configuration file](#configuration-file) and execute the following script:

`
./create_env.ps1 -c <path to config file>
`

As the result, the script will create the environment following your spec and place addresses of the created resources
into a resource file in the same folder where config file is located.

Deleting environment can be done by:

`
./destroy_env.ps1 -c <path to config file>
`

# Project structure

Master templates should be completed by build-in templates with actual scripts (component folders) and other files.

| Folder | Description |
|----|----|
| Environment | Scripts related to create info about environment |  
| Config | Config files for scripts. Stores *default* configs with default values which can be overwritten by actual config. | 
| Common | Scripts with support functions like working with configs, templates etc. | 
| Temp | Folder for storing automatically created temporary files. | 
| Logs | Folder for storing script logs. | 

# Configuration file

Master template have json config file with default values for all build-in templates, but before executing scripts it must be completed by *config/*.json.add* files, which stored in build-in template repository.
Description of config variables stored in build-in README.md files.

<!-- # Combine kubernetes and database template

For example, you need AKS (azure kubernetes service) and cloud couchbase.

1. Download [master template](https://github.com/pip-templates/pip-templates-env-master)
2. Copy *config/config.example.json* to *config* folder and rename it accordingly to your environment, for example *config.pip-stage.json*
3. Download the [AKS template](https://github.com/pip-templates/pip-templates-env-aks)
4. Copy *src* and *templates* folder from AKS template to master template 
5. Add content of *.ps1.add* files to correspondent files from master template
6. Add content of *config/config.k8s.json.add* to *config.pip-stage.json*
7. Download the [cloud couchbase template](https://github.com/pip-templates/pip-templates-db-cloud)
8. Copy *src* and *templates* folder from couchbase template to master template 
9. Add content of *.ps1.add* files to correspondent files from master template
10. Add content of *config/config.db.json.add* to *config.pip-stage.json*

Now you are ready to execute environment management scripts. -->
