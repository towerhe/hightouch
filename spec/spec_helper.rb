require 'rspec'

require 'middleman'
require 'factory_girl'

require 'hightouch'

Dir[File.join(File.dirname(__FILE__), "factories/**/*.rb")].each {|f| require f}

RSpec.configure do |c|
  c.mock_with :rspec
end
