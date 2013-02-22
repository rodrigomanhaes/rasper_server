require 'spec_helper'
require 'base64'
require 'tmpdir'

feature 'create report' do
  before(:each) do
    post reports_path, report: {
      'name' => 'programmers',
      'content' => File.read(File.join(resources_dir, 'programmers.jrxml')),
      'images' => [{
        'name' => 'imagem.jpg',
        'content' =>
          Base64.encode64(
            open(File.join(resources_dir, 'imagem.jpg'), 'rb', &:read))}] }
  end

  scenario 'send report to server' do
    post generate_report_path('programmers', 'json',
      data: [
        { name: 'Linus', software: 'Linux' },
        { name: 'Yukihiro', software: 'Ruby' },
        { name: 'Guido', software: 'Python' }
      ],
      parameters: {
        'CITY' => 'Campos dos Goytacazes, Rio de Janeiro, Brazil',
        'DATE' => '02/01/2013'
      }
    )
    pdf_content = Base64.decode64(JSON.parse(response.body)['content'])
    Dir.mktmpdir do |temp_dir|
      pdf_file_name = File.join(temp_dir, "output.pdf")
      File.open(pdf_file_name, 'wb') {|f| f.write(pdf_content) }
      Docsplit.extract_text(pdf_file_name, ocr: false, output: temp_dir)
      output_file_name = File.join(temp_dir, "output.txt")
      content = File.read(output_file_name)
      content.lines.reject(&:blank?).map(&:strip).map(&:chomp).should =~ \
        ["Campos dos Goytacazes, Rio de Janeiro, Brazil, 02/01/2013",
         "Name: Linus", "Software: Linux",
         "Name: Yukihiro", "Software: Ruby",
         "Name: Guido", "Software: Python"]
    end
  end
end