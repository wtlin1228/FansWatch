# frozen_string_literal: true
require 'rake/testtask'

task default: :spec

namespace :credentials do
  require 'yaml'

  desc 'generate access_token to STDOUT'
  task :get_access_token do
    credentials = YAML.load(File.read('config/credentials.yml'))
    require_relative 'lib/fanswatch/fb_api'
    ENV['FBAPI_CLIENT_ID'] = credentials[:client_id]
    ENV['FBAPI_CLIENT_SECRET'] = credentials[:client_secret]

    puts "Access Token: #{FansWatch::FbApi.access_token}"
  end

  desc 'Export sample credentials from file to bash'
  task :export do
    credentials = YAML.load(File.read('config/credentials.yml'))
    puts 'Please run the following in bash:'
    puts "export FB_CLIENT_ID=#{credentials[:client_id]}"
    puts "export FB_CLIENT_SECRET=#{credentials[:client_secret]}"
  end
end

desc 'run tests' 
task :spec do 
  sh 'ruby spec/fanswatch_spec.rb' 
end

desc 'delete cassette fixtures'
task :wipe do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No casseettes found')
  end
end
