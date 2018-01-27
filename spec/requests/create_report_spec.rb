require 'rails_helper'
require 'fileutils'

RSpec.describe 'create report', type: :request do
  before(:each) do
    %w(jrxml jasper).each {|x| FileUtils.rm_rf(File.join(report_dir, "*.#{x}")) }
  end

  it 'sends report to server' do
    post '/add', params: {
      'name' => 'programmers',
      'content' => Base64.encode64(resource('programmers.jrxml'))
    }.to_json

    files = Dir[Rails.root.join('report', 'programmers.*')].map(&:to_s)
    expect(files).to match_array \
      %w(programmers.jrxml programmers.jasper).
        map {|s| Rails.root.join('report', s) }.map(&:to_s)
  end

  it 'sends only images(s)' do
    post '/add', params: {
      'images' => [
        {
          'name' => 'imagem.jpg',
          'content' => Base64.encode64(resource('imagem.jpg'))
        }
      ]
    }.to_json

    image_files = Dir[Rails.root.join('report', '*.*')].
      map {|f| File.basename(f) }
    expect(image_files).to eq %w[imagem.jpg]
  end
end
