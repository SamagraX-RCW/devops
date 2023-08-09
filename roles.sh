#!/bin/bash

# Function to create a new Ansible role directory structure
create_ansible_role() {
    # vars file path
    vars_dir="ansible_workspace_dir/vars"
    
    # Ask for role name
    read -p "Enter the name of the role: " role_name

    # Create role directory
    role_dir="ansible_workspace_dir/roles/${role_name}"
    mkdir -p "${role_dir}"

    # Create main directories
    mkdir -p "${role_dir}/tasks"
    mkdir -p "${role_dir}/templates"
    mkdir -p "${role_dir}/vars"
    mkdir -p "${role_dir}/defaults"
    mkdir -p "${role_dir}/meta"
    mkdir -p "${role_dir}/handlers"
    mkdir -p "${role_dir}/test"

    # Create empty main.yml files
    echo "---
# defaults file for deploy-sb-ext" > "${role_dir}/defaults/main.yml"
    echo "---
# handlers file for deploy-sb-ext" > "${role_dir}/handlers/main.yml"
    echo "galaxy_info:
  author: your name
  description: your description
  company: your company (optional)

  # If the issue tracker for your role is not on github, uncomment the
  # next line and provide a value
  # issue_tracker_url: http://example.com/issue/tracker

  # Some suggested licenses:
  # - BSD (default)
  # - MIT
  # - GPLv2
  # - GPLv3
  # - Apache
  # - CC-BY
  license: license (GPLv2, CC-BY, etc)

  min_ansible_version: 1.2

  # If this a Container Enabled role, provide the minimum Ansible Container version.
  # min_ansible_container_version:

  # Optionally specify the branch Galaxy will use when accessing the GitHub
  # repo for this role. During role install, if no tags are available,
  # Galaxy will use this branch. During import Galaxy will access files on
  # this branch. If Travis integration is configured, only notifications for this
  # branch will be accepted. Otherwise, in all cases, the repo's default branch
  # (usually master) will be used.
  #github_branch:

  #
  # platforms is a list of platforms, and each platform has a name and a list of versions.
  #
  # platforms:
  # - name: Fedora
  #   versions:
  #   - all
  #   - 25
  # - name: SomePlatform
  #   versions:
  #   - all
  #   - 1.0
  #   - 7
  #   - 99.99

  galaxy_tags: []
    # List tags for your role here, one per line. A tag is a keyword that describes
    # and categorizes the role. Users find roles by searching for tags. Be sure to
    # remove the '[]' above, if you add tags to this list.
    #
    # NOTE: A tag is limited to a single word comprised of alphanumeric characters.
    #       Maximum 20 tags per role.

dependencies: []
  # List your role dependencies here, one per line. Be sure to remove the '[]' above,
  # if you add dependencies to this list." > "${role_dir}/meta/main.yml"

    echo "---
# # tasks file for deploy-sb-ext" > "${role_dir}/tasks/main.yml"

    echo "---" > "${role_dir}/test/test.yml"

    echo "---
# vars file for deploy-sb-ext
# For script" > "${role_dir}/vars/main.yml"

    # Display success message
    echo "Ansible role '${role_name}' created successfully!"


    # Read the existing data from vars.yml into a variable
    existing_data=$(cat templates/vars_template/main.yml)

    # Extract host port and docker port into separate variables
    host_port=$(echo "$existing_data" | awk -F ': ' '/service_service_name_host_port/ {print $2}')
    docker_port=$(echo "$existing_data" | awk -F ': ' '/service_service_name_docker_port/ {print $2}')


    # Loop to create vars section for each service
        read -p "${role_name} image: " image
        read -p "${role_name} secret path: " secret_path
        read -p "Number of replicas for ${role_name}: " replicas
        
        echo "" >> "${vars_dir}/main.yml"
        echo "${role_name}_service: ${role_name}" >> "${vars_dir}/main.yml"
        echo "${role_name}_host_port: ${host_port}" >> "${vars_dir}/main.yml"
        echo "${role_name}_docker_port: ${docker_port}" >> "${vars_dir}/main.yml"
        echo "network_alias_${role_name}_service: ${role_name}" >> "${vars_dir}/main.yml"
        echo "image_${role_name}_service: ${image}" >> "${vars_dir}/main.yml"
        echo "${role_name}_logs: mydata/logs/${role_name}" >> "${vars_dir}/main.yml"
        echo "force_reload_${role_name}_service: true" >> "${vars_dir}/main.yml"
        echo "${role_name}_secret_path: ${secret_path}" >> "${vars_dir}/main.yml"
        echo "service_replicas_${role_name}_service: ${replicas}" >> "${vars_dir}/main.yml"

    # Display success message
    echo "Ansible role '${role_name}' created successfully!"

    # Increase the port numbers by 1
    new_host_port=$((host_port + 1))
    new_docker_port=$((docker_port + 1))

    # Update the data with new port numbers
    updated_data="${existing_data/service_service_name_host_port: $host_port/service_service_name_host_port: $new_host_port}"
    updated_data="${updated_data/service_service_name_docker_port: $docker_port/service_service_name_docker_port: $new_docker_port}"

    # Write the updated data back to vars.yml file
    echo "$updated_data" > templates/vars_template/main.yml
}

# Main script execution
create_ansible_role
