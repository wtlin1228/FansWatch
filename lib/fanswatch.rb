files = Dir.glob(File.join(File.dirname(__FILE__), 'fanswatch/*.rb')) 
files.each { |lib| require_relative lib } 