files = Dir.glob(File.join(File.dirname(__FILE__), 'facegroup/*.rb')) 
files.each { |lib| require_relative lib } 