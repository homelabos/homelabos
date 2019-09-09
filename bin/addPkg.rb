#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'psych'
require 'fileutils'
require 'gitlab'
require 'pry'

gitlab_token = ENV['GITLAB_TOKEN'] || false
HOMELABOS_PROJECT_ID = 6853087
gl = Gitlab.client(endpoint: 'https://gitlab.com/api/v4', private_token: gitlab_token) if gitlab_token

@branch_name = ''
@iid = 0

puts 'Step 0. Gathering Info'
puts 'Enter the package name in title case: '
unsafe_package_name = gets
package_name = unsafe_package_name.chomp
package_file_name = package_name.downcase.gsub(/ /, '')
puts 'Enter the Package URL: '
unsafe_package_url = gets
package_url = unsafe_package_url.chomp
puts 'Enter one-liner package description: '
unsafe_package_one_liner = gets
package_one_liner = unsafe_package_one_liner.chomp

if gl
  puts 'Creating gitlab issue'
  issue_result = gl.create_issue(HOMELABOS_PROJECT_ID, 
                "Add #{package_name}", 
                :description => "Please add #{package_name}", 
                :labels => 'package,enhancement', :assignee_id => gl.user.id)
  @branch_name = "#{issue_result.iid}-#{package_name.gsub(/ /, '-')}"
  if issue_result.iid
    @iid = issue_result.iid
    branch_result = gl.create_branch(HOMELABOS_PROJECT_ID, 
                                      @branch_name,
                                      'HEAD')
    if !branch_result.nil?
      mr_result = gl.create_merge_request(HOMELABOS_PROJECT_ID, 
                                "WIP: Resolve \"#{issue_result.title}\"", 
                                :source_branch => @branch_name, 
                                :target_branch => 'dev')
    end
  end
end

%x{git fetch}
%x{git checkout #{@branch_name} }

puts 'Step 1. Creating role folder'
FileUtils.copy_entry "package_template/roles/template", "roles/#{package_file_name}"
puts 'Done!'

puts 'Step 2. Editing role tasks and renaming docker-compose template'
search_and_replace_in_file("roles/#{package_file_name}/tasks/main.yml", 'pkgtemplate', package_file_name)
FileUtils.mv "roles/#{package_file_name}/templates/docker-compose.template.yml.j2", "roles/#{package_file_name}/templates/docker-compose.#{package_file_name}.yml.j2"
search_and_replace_in_file("roles/#{package_file_name}/templates/docker-compose.#{package_file_name}.yml.j2", 'PackageFileName', package_file_name)
%x{git add roles/#{package_file_name}}
puts 'Done!'

puts 'Step 3. Copying doc template'
FileUtils.copy_entry "package_template/docs/software/template.md", "docs/software/#{package_file_name}.md"
puts 'Done!'

puts 'Step 4. Editing doc file'
search_and_replace_in_file("docs/software/#{package_file_name}.md", "PackageURL", "#{package_url}")
search_and_replace_in_file("docs/software/#{package_file_name}.md", "PackageOneLiner", "#{package_one_liner}")
search_and_replace_in_file("docs/software/#{package_file_name}.md", "PackageFileName", "#{package_file_name}")
search_and_replace_in_file("docs/software/#{package_file_name}.md", "PackageTitleCase", "#{package_name}")
%x{git add docs/software/#{package_file_name}.md}
puts 'Done!'

puts 'Step 5. Adding docs to mkdocs.yml'
# 'pages', 4, 'Included Software'
add_to_array_at_key('mkdocs.yml', ['pages', 4, 'Included Software'], {"#{package_name}" => "software/#{package_file_name}.md"})
%x{git add mkdocs.yml}
puts 'Done!'

puts 'Step 6. Adding service to Inventory file'
add_to_hash_at_key('group_vars/all', ['enabled_services'], {"#{package_file_name}" => "{{ enable_#{package_file_name} }}"})
%x{git add group_vars/all}
puts 'Done!'

puts 'Step 7. Adding service to Readme.md'
insert_in_config "README.md", "## Available Software", "- [#{package_name}](#{package_url}) - #{package_one_liner}"
%x{git add README.md}
puts 'Done!'

puts 'Step 8. Adding service to Config Template'
insert_in_config "roles/homelabos_config/templates/config.yml.j2", "#== PARSE ###", "enable_#{package_file_name}: {{ enable_#{package_file_name} | default(False) }}"
%x{git add roles/homelabos_config/templates/config.yml.j2}
puts 'Done!'

puts 'Step 9. Adding service to Changelog'
insert_in_config "CHANGELOG.md", '#', "- Added #{package_name} - #{package_one_liner}"
%x{git add CHANGELOG.md}
puts 'Done!'

puts "\nDon't forget to edit the docker-compose file"

puts "\n\nAll files added by this script, with the exception of the docker-compose file have been staged in git."

#Helper Methods
BEGIN {
  def search_and_replace_in_file(filepath, search_for, replace_with)
    IO.write(filepath, File.open(filepath) do |f|
        f.read.gsub(search_for, replace_with)
      end
    )
  end

  def add_to_array_at_key(ymlfile, key, to_append)
    yml = Psych.load_file ymlfile
    yml.dig(*key) << to_append
    File.write ymlfile, Psych.dump(yml)
  end

  def add_to_hash_at_key(ymlfile, key, to_append)
    yml = Psych.load_file ymlfile
    yml.dig(*key).merge!(to_append)
    File.write ymlfile, Psych.dump(yml)
  end

  def insert_in_config filename, start_tag, to_insert
    lines = File.readlines filename
    start_tag_found = false
    lines.dup.each_with_index do |l,i|
      if start_tag_found 
        if ((to_insert <=> l) == -1) && ((to_insert <=> lines[i-1]) == 1)
          lines.insert i, to_insert
          break
        end
      else 
        start_tag_found = true if l =~ /#{start_tag}/
      end 
    end 
    File.open(filename, "w+") do |f|
      f.puts(lines)
    end
  end
}
