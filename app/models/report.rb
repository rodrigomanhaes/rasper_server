require 'base64'

class Report
  def self.create(options)
    name, content, images = options[:name], options[:content], options[:images]
    filename = Rails.root.join('report', "#{name}.jrxml")
    File.open(filename, 'w') {|f| f.write(content) }
    images.each do |hash|
      image_name = File.join(Rasper::Report.image_dir, hash['name'])
      File.open(image_name, 'wb') {|f| f.write(Base64.decode64(hash['content'])) }
    end if images
    Rasper::Compiler.compile(filename.to_s)
  end

  def self.generate(name, data, params)
    Rasper::Report.generate(name, data, params)
  end
end