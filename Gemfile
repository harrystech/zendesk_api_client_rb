source 'https://rubygems.org'

gem "simplecov", :platforms => :ruby_19, :group => :test
gem "jruby-openssl", :platforms => :jruby

group :test do
  gem "byebug", :platform => [:ruby_20, :ruby_21]
  gem "json", :platform => :ruby_18
  gem "pry"

  # only used for uploads testing
  gem "actionpack", "~> 3.2"
end

gemspec
