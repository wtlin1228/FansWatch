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
CREDENTIALS = YAML.load(File.read('config/credentials.yml')) 
RESULT_FILE = "#{FIXTURES_FOLDER}/results.yml" 
FB_RESULT = YAML.load(File.read(RESULT_FILE))

if File.file?('config/credentials.yml') 
  credentials = YAML.load(File.read('config/credentials.yml')) 
  ENV['FB_CLIENT_ID'] = credentials[:client_id] 
  ENV['FB_CLIENT_SECRET'] = credentials[:client_secret] 
  ENV['FB_ACCESS_TOKEN'] = credentials[:access_token] 
  ENV['FB_PAGE_ID'] = credentials[:page_id] 
end

INVALID_PAGE_ID = 'error_page_id'
