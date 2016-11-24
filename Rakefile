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
