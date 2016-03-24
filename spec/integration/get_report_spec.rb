require 'rails_helper'
require 'base64'
require 'tmpdir'

RSpec.describe 'get report', type: :request do
  before(:each) do
    post '/add', {}, {'RAW_POST_DATA' => {
      'name' => 'programmers',
      'content' => Base64.encode64(resource('programmers.jrxml')),
      'images' => [{
        'name' => 'imagem.jpg',
        'content' =>
          Base64.encode64(resource('imagem.jpg'))}] }.to_json }
  end

  it 'generates report' do
    post_data = Base64.encode64({
      name: 'programmers',
      data: [
        { name: 'Linus', software: 'Linux' },
        { name: 'Yukihiro', software: 'Ruby' },
        { name: 'Guido', software: 'Python' }
      ],
      parameters: {
        'CITY' => 'Campos dos Goytacazes, Rio de Janeiro, Brazil',
        'DATE' => '02/01/2013'
      }
    }.to_json)
    post '/generate', {}, { 'RAW_POST_DATA' => { data: post_data }.to_json }
    pdf_content = Base64.decode64(JSON.parse(response.body)['content'])
    Dir.mktmpdir do |temp_dir|
      pdf_file_name = File.join(temp_dir, "output.pdf")
      File.open(pdf_file_name, 'wb') {|f| f.write(pdf_content) }
      Docsplit.extract_text(pdf_file_name, ocr: false, output: temp_dir)
      output_file_name = File.join(temp_dir, "output.txt")
      content = File.read(output_file_name)
      expect(content.lines.reject(&:blank?).map(&:strip).map(&:chomp)).to eq [
        "Campos dos Goytacazes, Rio de Janeiro, Brazil, 02/01/2013",
        "Name: Linus", "Software: Linux",
        "Name: Yukihiro", "Software: Ruby",
        "Name: Guido", "Software: Python"]
    end
  end

  it 'generates report without parameters' do
    post_data = Base64.encode64({
      name: 'programmers',
      data: [
        { name: 'Linus', software: 'Linux' },
        { name: 'Yukihiro', software: 'Ruby' },
        { name: 'Guido', software: 'Python' }
      ]
    }.to_json)
    post '/generate', {}, { 'RAW_POST_DATA' => { data: post_data }.to_json }
    pdf_content = Base64.decode64(JSON.parse(response.body)['content'])
    File.open('/tmp/output.pdf', 'wb') {|f| f.write(pdf_content) }
    Dir.mktmpdir do |temp_dir|
      pdf_file_name = File.join(temp_dir, "output.pdf")
      File.open(pdf_file_name, 'wb') {|f| f.write(pdf_content) }
      Docsplit.extract_text(pdf_file_name, ocr: false, output: temp_dir)
      output_file_name = File.join(temp_dir, "output.txt")
      content = File.read(output_file_name)
      expect(content.lines.reject(&:blank?).map(&:strip).map(&:chomp)).to match_array [
        "Nowhere, no day",
        "Name: Linus", "Software: Linux",
        "Name: Yukihiro", "Software: Ruby",
        "Name: Guido", "Software: Python"]
    end
  end
end
