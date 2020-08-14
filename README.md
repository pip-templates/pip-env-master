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

Environment management scripts should be executed from management station. Management station can be created by create_mgmt.ps1 script

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

It is possible to execute individual phases of the process by running specific scripts.
For instance, you can create only kubernetes cluster or database, or install kubernetes components by running scripts from *src* folder by executing script with -c parameter.

# Project structure

Master templates should be completed by build-in templates with actual scripts (src folder) and other files.

| Folder | Description |
|----|----|
| Src | Scripts related to management cloud environment. |  
| Config | Config files for scripts. Store *example* configs for each environment, recommendation is not change this files with actual values, set actual values in duplicate config files without *example* in name. Also stores *resources* files, created automaticaly. | 
| Lib | Scripts with support functions like working with configs, templates etc. | 
| Temp | Folder for storing automatically created temporary files. | 
| Templates | Folder for storing templates, such as kubernetes yml files, cloudformation templates, etc. | 

# Configuration file

Master template have json config file with common values for all build-in templates, but before executing scripts it must be completed by *config/*.json.add* files, which stored in build-in template repository.
Description of config variables stored in build-in README.md files.

# Combine kubernetes and database template

For example, you need AKS (azure kubernetes service) and cloud couchbase.

1. Download [master template](https://github.com/pip-templates/pip-templates-env-master)
2. Copy *config/config.example.json* to *config* folder and rename it accordingly to your environment, for example *config.pip-stage.json*
3. Download the [AKS template](https://github.com/pip-templates/pip-templates-env-aks)
4. Copy *src* and *templates* folder from AKS template to master template 
5. Copy content of *config/config.k8s.json.add* to *config.pip-stage.json*
6. Download the [cloud couchbase template](https://github.com/pip-templates/pip-templates-db-cloud)
7. Copy *src* and *templates* folder from AKS template to master template 
8. Copy content of *config/config.db.json.add* to *config.pip-stage.json*

Now you are ready to execute environment management scripts.
