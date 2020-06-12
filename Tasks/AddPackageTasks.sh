#!/usr/bin/env bash

# Contains Tasks related to adding a new package to HomelabOS

# Use this task to walk through a wizard that helps you add a new package.
Task::add_package() {
  : @desc "Wizard to add a new Package"

  colorize green "This wizard will ask you a few questions and help you prototype the required changes to add a package"
  read -p "What's the name of this package in Title Case? " package_name
  read -p "What's a good URL for the package? " url
  read -p "Enter a one-line-ish description for the packge? " description

  local package_file_name=${package_name// /''} | awk '{print tolower($0)}'
  local branch_name=${package_name// /-}

  create_git_branch $branch_name

  search_and_replace_in_file 'baz' 'woot' "test"
  highlight "Creating role folder"
  cp -R package_template/roles/template roles/$package_file_name

  highlight "Editing Role Tasks & Renaming docker-compose template"
  search_and_replace_in_file 'pkgtemplate' $package_file_name "/roles/$package_file_name/tasks/main.yml"
  mv roles/$package_file_name/templates/docker-compose.template.yml.j2 roles/$package_file_name/templates/docker-compose.$package_file_name.yml.j2
  search_and_replace_in_file 'PackageFileName' $package_file_name roles/$package_file_name/templates/docker-compose.$package_file_name.yml.j2

  highlight "Copying Doc Template"
  cp package_template/docs/software/template.md docs/software/$package_file_name.md

  highlight "Editing Doc Template"
  local template="docs/software/$package_file_name.md"
  search_and_replace_in_file 'PackageURL' $url $template
  search_and_replace_in_file 'PackageOneLiner' $description $template
  search_and_replace_in_file 'PackageFileName' $package_file_name $template
  search_and_replace_in_file 'PackageTitleCase' $package_name $template

  highlight "Adding Docs to mkdocs.yml"

}

Task::create_git_branch() {
  git fetch
  git checkout dev
  git branch $1
  git checkout $1
}

function search_and_replace_in_file(){
  sed -i -e "s/$1/$2/g" $3
}
