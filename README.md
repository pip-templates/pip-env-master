# Overview

The Environment Management scripts are used to create, update or delete operating environments.
The environments support types: cloud. 
Depending on requirements, they can be used for development, testing and production.

The scriptable environments follow "Infrastructure as a Code" principles and allow to:
* Have controllable and verifiable environment structure
* Quickly spin up fully-functional environments in minutes
* Minimize differences between environments
* Provide developers with environment to run and test their components integrated into the final system and expand their area of responsibilities

To have full environment magament you need to follow the [Combine kubernetes and database template](#combine-kubernetes-and-database-template) instructions

# Usage

Environment management scripts should be executed from management station. Management station can be created by create_mgmt.ps1 script

`
./create_mgmt.ps1 -c <path to config file>
`

This script will create cloud virtual machine and copy environment management project to /home/ubuntu/pip-templates-envmgmt

Before you can run environment management scripts you must install prerequisites. That step is required to be done once:

`
./install_prereq_<os>.ps1
`

To create a new environment prepare an environment configuration file (see below) and execute the following script:

`
./create_env.ps1 -c <path to config file>
`

As the result, the script will create the environment following your spec and place addresses of the created resources
into a resource file in the same folder where config file is located.

Deleting environment can be done as:

`
./destroy_env.ps1 -c <path to config file>
`

It is possible to execute individual phases of the process by running specific scripts.
For instance, you can create only kubernetes cluster or database, or install kubernetes components by running scripts from *cloud* folder by executing script with -c parameter.

# Project structure
This is a blank template for environment management, so it stores only root scripts and lib folder, all other folders and scripts stored in pip-templates repositories on github.
| Folder | Description |
|----|----|
| Lib | Scripts with support functions like working with configs, templates etc. | 

# Combine kubernetes and database template

Environment management templates separated by their functions and platforms - aws/azure cloud providers, kubernetes clusters, database clusters (mongodb, couchbase). They all stored on https://github.com/pip-templates 

For example, you need AKS (azure kubernetes service) and cloud couchbase.
1. Download the entire template https://github.com/pip-templates/pip-templates-env-aks and copy all folders except *lib* to pip-template-env-blank. 
2. Next we need copy directories and files from https://github.com/pip-templates/pip-templates-db-cloud
cloud script files from directory “cloud”
manually copy unique variables from “config.example”
templates files from directory “templates”
3. Make sure that root scripts (create_env/delete_env) corresponds to *cloud* scripts (by default pip-templates-env-black root scripts calling mongo db scripts).
