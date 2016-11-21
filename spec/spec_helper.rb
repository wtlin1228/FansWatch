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