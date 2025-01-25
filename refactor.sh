#!/bin/bash

# fail on errors
set -e

# Check if there are git changes
if [[ $(git status --porcelain) ]]; then
    echo "Error: Working directory not clean"
    git status
    exit 1
fi

# Switch to refactoring branch and reset it to refactoring-with-script
git checkout refactoring-local
git reset --hard refactoring-with-script

# Define book names
books=("netplan" "environment" "nvme" "ceph" "lvmcluster" "ovn" "incus")

# Create Ansible role directories
for book in "${books[@]}"; do

    # Assert that there are no staged git files
    if [[ $(git diff --cached --name-only) ]]; then
        echo "Error: There are staged git files. Please commit or unstage them before running this script."
        exit 1
    fi

    # Create role directories
    mkdir -p "roles/${book}/tasks" "roles/${book}/vars" "roles/${book}/files" "roles/${book}/templates" "roles/${book}/defaults" "roles/${book}/meta" "roles/${book}/handlers"

    # defaults
    sed -n -e '/^  vars:/,/^  [a-z]/{//!p}' "ansible/books/${book}.yaml" | sed 's/^    //g' | grep 'default(.*)' | awk  '!x[$0]++' | sed -E -e '1i---' -e 's/^([a-z_]*):.*default\(([^a-z].*)\).*$/\1: \2/g' -e 's/^([a-z_]*): *"\{\{ *[a-z_]* *\| *default\(([a-z].*)\) *\}\}"$/\1: "{{ \2 }}"/g' | sed -e "s/task_/${book}_/g"  -e "s|../data/|data/|g" -e "s|\.tpl|.j2|g" > "roles/${book}/defaults/main.yaml"
    git add "roles/${book}/defaults/main.yaml"

    # vars
    sed -n -e '1i---' -e '/^  vars:/,/^  [a-z]/{//!p}' "ansible/books/${book}.yaml" | sed 's/^    //g' | grep -v 'default(.*)' | awk  '!x[$0]++' | sed -e"s/task_/${book}_/g" -e "s|../files/${book}/||g"  -e "s|../data/|data/|g" -e "s|\.tpl|.j2|g" > "roles/${book}/vars/main.yaml"
    git add "roles/${book}/vars/main.yaml"

    # tasks
    sed -n -e '1i---' -e '/^  tasks:/,/^  [a-z]\|^-/{//!p}' -e 's/^- name:/\n- name: Run all notified handlers\n  meta: flush_handlers\n\n#/p' "ansible/books/${book}.yaml" | sed 's/^    //g' | sed -e "s/task_/${book}_/g" -e "s|../files/${book}/||g" -e "s|../data/|data/|g" -e "s|\.tpl|.j2|g" -e '$a\- name: Run all notified handlers\n  meta: flush_handlers\n' > "roles/${book}/tasks/main.yaml"
    git add "roles/${book}/tasks/main.yaml"

    # handlers
    sed -n -e '1i---' -e '/^  handlers:/,/^-/{//!p}' "ansible/books/${book}.yaml" | sed 's/^    //g' | sed -e "s/task_/${book}_/g" -e "s|../files/${book}/||g" -e "s|../data/|data/|g" -e "s|\.tpl|.j2|g" > "roles/${book}/handlers/main.yaml"
    git add "roles/${book}/handlers/main.yaml"

    # Move files to templates if they exist
    if [ -d "ansible/files/${book}" ]; then
        for file in ansible/files/${book}/*.tpl; do
            if [ -f "$file" ]; then
                newname=$(basename "$file" .tpl).j2
                mv "$file" "roles/${book}/templates/$newname"
            fi
        done
        [ "$(ls -A "ansible/files/${book}")" ] && \
        mv "ansible/files/${book}"/* "roles/${book}/files/"

        # Replace task var prefixes and remove relative path references
        sed -i -e "s/task_/${book}_/g" -e "s|../files/${book}/||g" -e "s|\.tpl|.j2|g" "roles/${book}/templates"/*

        # Add templates to git
        git rm -r "ansible/files/${book}"
        git add "roles/${book}/templates" "roles/${book}/files"
    fi

    # Remove playbook
    git rm "ansible/books/${book}.yaml"

    # Commit with book-specific message
    git commit --signoff -m "Refactor the ${book} playbook to role structure (automated transformation)"


    if [[ $(git status --porcelain) ]]; then
        echo "Error: Working directory not clean"
        git status
        exit 1
    fi

done

sed -n -e '/^## Ceph/,/^##/p' ansible/README.md | sed -E -e '$d' -e '2i## Variables' -e 's/^##(.*)$/#\1 Role/g' > roles/ceph/README.md
sed -n -e '/^## Incus/,/^##/p' ansible/README.md | sed -E -e '$d' -e '2i## Variables' -e 's/^##(.*)$/#\1 Role/g' > roles/incus/README.md
sed -n -e '/^## Netplan/,/^##/p' ansible/README.md | sed -E -e '$d' -e '2i## Variables' -e 's/^##(.*)$/#\1 Role/g' > roles/netplan/README.md
sed -n -e '/^## NVME/,/^##/p' ansible/README.md | sed -E -e '$d' -e '2i## Variables' -e 's/^##(.*)$/#\1 Role/g' > roles/nvme/README.md
sed -n -e '/^## LVM cluster/,/^##/p' ansible/README.md | sed -E -e '$d' -e '2i## Variables' -e 's/^##(.*)$/#\1 Role/g' > roles/lvmcluster/README.md
sed -n -e '/^## OVN/,/^##/p' ansible/README.md | sed -E -e '$d' -e '2i## Variables' -e 's/^##(.*)$/#\1 Role/g' > roles/ovn/README.md
git add roles/*/README.md
git rm ansible/README.md
git commit --signoff -m "Place the README into the separate role folders"

# fix refactoring of incus (end_play)
git cherry-pick b7d7525

# fix refactoring of ceph (end_play)
git cherry-pick 901d836

# fix incus ovn var
git cherry-pick 2db876b

# Remove the refactoring script
git rm refactor.sh
git commit --signoff -m "Remove the refactoring script"

# Tag the refactoring with timestamp
refactoring_tag="refactoring-$(date -u +"%Y%m%d%H%M%S")"
git tag "$refactoring_tag" HEAD
