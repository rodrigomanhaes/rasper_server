module DirUtils
  def resources_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'resources'))
  end

  def resource(name)
    File.read(File.join(resources_dir, name))
  end

  def report_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'report'))
  end
end

RSpec.configure do |config|
  config.include DirUtils
end
