class Report
  def self.create(options)
    name, content = options[:name], options[:content]
    filename = Rails.root.join('report', "#{name}.jrxml")
    File.open(filename, 'w') {|f| f.write(content) }
    Rasper::Compiler.compile(filename.to_s)
  end
end