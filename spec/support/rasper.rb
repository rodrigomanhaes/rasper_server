%w(report java).
  map {|dir| Rails.root.join(dir) }.
  each {|dir| Dir.mkdir(dir) unless File.exists?(dir) }

Rasper::Config.configure do |config|
  config.jar_dir = Rails.root.join('java')
  config.jasper_dir = Rails.root.join('report')
  config.image_dir = Rails.root.join('report')
end

RSpec.configure do |config|
  config.before :each do
    [Rasper::Config.jasper_dir, Rasper::Config.image_dir].each do |directory|
      Dir["#{directory}/*.*"].each {|f| File.delete(f) }
    end
  end
end
