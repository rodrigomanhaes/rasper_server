source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.3'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'jruby-openssl'

gem 'rasper'
gem 'warbler'

group :development do
  gem 'listen'
end

group :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'docsplit'
end
