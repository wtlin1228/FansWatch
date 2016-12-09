# frozen_string_literal: true
require 'simplecov' 
SimpleCov.start

require 'yaml' 
require 'minitest/autorun' 
require 'minitest/rg' 
require 'vcr' 
require 'webmock'

require_relative '../lib/fanswatch'

FIXTURES_FOLDER = 'spec/fixtures' 
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes" 
CASSETTE_FILE = 'facebook_api' 

if File.file?('config/credentials.yml') 
  credentials = YAML.load(File.read('config/credentials.yml')) 
  ENV['FB_CLIENT_ID'] = credentials[:client_id] 
  ENV['FB_CLIENT_SECRET'] = credentials[:client_secret] 
  ENV['FB_ACCESS_TOKEN'] = credentials[:access_token] 
  ENV['FB_PAGE_ID'] = credentials[:page_id] 
end

RESULT_FILE = "#{FIXTURES_FOLDER}/results.yml" 
FB_RESULT = YAML.load(File.read(RESULT_FILE))
INVALID_PAGE_ID = 'error_page_id'
HAPPY_PAGE_URL = 'https://www.facebook.com/time'

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<ACCESS_TOKEN>') do
    URI.unescape(ENV['FB_ACCESS_TOKEN'])
  end

  c.filter_sensitive_data('<ACCESS_TOKEN_ESCAPED>') do
    ENV['FB_ACCESS_TOKEN']
  end

  c.filter_sensitive_data('<CLIENT_ID>') { ENV['FB_CLIENT_ID'] }
  c.filter_sensitive_data('<CLIENT_SECRET>') { ENV['FB_CLIENT_SECRET'] }

end