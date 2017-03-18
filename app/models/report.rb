require 'base64'
require 'fileutils'

class Report
  def self.create(options)
    name, content, images = options.values_at(:name, :content, :images)
    if name
      content = Base64.decode64(content).force_encoding('UTF-8')
      filename = [Rasper::Config.jasper_dir, "#{name}.jrxml"].join('/')
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, 'w') {|f| f.write(content) }
    end
    images.each do |hash|
      image_name = File.join(Rasper::Config.image_dir, hash['name'])
      File.open(image_name, 'wb') {|f| f.write(Base64.decode64(hash['content'])) }
    end if images
    Rasper::Compiler.compile(filename.to_s) if name
  end

  def self.generate(name, data, params)
    Rasper::Report.generate(name, data, params)
  end
end
