#!/bin/bash

# Function to create a new Ansible role directory structure
create_ansible_role() {
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

    echo "# ---
# # tasks file for deploy-sb-ext" > "${role_dir}/tasks/main.yml"

    echo "---" > "${role_dir}/test/test.yml"

    echo "---
# vars file for deploy-sb-ext
# For script" > "${role_dir}/vars/main.yml"

    # Display success message
    echo "Ansible role '${role_name}' created successfully!"
}

# Main script execution
create_ansible_role
