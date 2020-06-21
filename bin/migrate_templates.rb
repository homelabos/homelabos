#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.setup
require 'psych'
require 'fileutils'
require 'gitlab'
require 'pry'

group_vars = Psych.load_file 'group_vars/all'

services = group_vars['services']
services.each do |service, _value|
  filepath = "roles/#{service}/templates/docker-compose.#{service}.yml.j2"
  search_and_replace_in_template(filepath, service) if File.exist? filepath
end

BEGIN {

  def search_and_replace_in_template(filepath, service)
    lines = File.readlines(filepath)
    start_index = 0
    port = 0
    lines.dup.each_with_index do |l, i|
      if l.include? 'labels:'
        start_index = i + 1
        start_index.freeze
        next
      end
      if l.include? "traefik.http.services.#{service}.loadbalancer.server.port="
        port = l.scan(/\d{1,5}/).last
      end
      break if l.include? 'if traefik.dns_challenge_provider'

      lines.delete_at start_index if start_index != 0
    end
    array_to_insert = [
      "      - \"traefik.http.services.#{service}.loadbalancer.server.scheme=http\"",
      "      - \"traefik.http.services.#{service}.loadbalancer.server.port=#{port}\"",
      "{% include \'./labels.j2\' %}"
    ]
    lines.insert(start_index, *array_to_insert)
    File.open(filepath, 'w+') do |f|
      f.puts(lines)
    end
  end

}
