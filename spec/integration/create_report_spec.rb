require 'rails_helper'
require 'fileutils'

RSpec.describe 'create report', type: :request do
  before(:each) do
    %w(jrxml jasper).each {|x| FileUtils.rm_rf(File.join(report_dir, "*.#{x}")) }
  end

  it 'sends report to server' do
    post '/add', {}, {'RAW_POST_DATA' => { 'name' => 'programmers',
      'content' => Base64.encode64(resource('programmers.jrxml')) }.to_json }
    expect(Dir[Rails.root.join('report', 'programmers.*')].map(&:to_s)).to match_array \
      %w(programmers.jrxml programmers.jasper).map {|s|
        Rails.root.join('report', s).to_s
      }
  end

  it 'puts files into namespaces when provided' do
    post '/add', {}, {'RAW_POST_DATA' => { 'name' => 'my-awesome-app/programmers',
      'content' => Base64.encode64(resource('programmers.jrxml')),
      'images' => [{
        'name' => 'my-awesome-app/imagem.jpg',
        'content' => Base64.encode64(resource('imagem.jpg'))}] }.to_json }
    dirname = Rails.root.join('report', 'my-awesome-app')
    filenames = Dir[File.join(dirname, '*.*')].map(&:to_s)
    expect(filenames).to match_array \
      %w(programmers.jrxml programmers.jasper imagem.jpg).map {|s|
        File.join(dirname , s).to_s
      }
  end

  it 'sends only images(s)' do
    post '/add', {}, {'RAW_POST_DATA' => {
      'images' => [{
        'name' => 'imagem.jpg',
        'content' =>
          Base64.encode64(resource('imagem.jpg'))}] }.to_json }
    expect(Dir[Rails.root.join('report', '*.*')].map {|f| File.basename(f) }).
      to eq ['imagem.jpg']
  end
end
