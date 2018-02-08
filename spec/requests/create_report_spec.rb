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

    expect(response_body).to eq('success' => true)
    expect(response.status).to eq 200

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

    expect(response_body).to eq('success' => true)
    expect(response.status).to eq 200

    image_files = Dir[Rails.root.join('report', '*.*')].
      map {|f| File.basename(f) }
    expect(image_files).to eq %w[imagem.jpg]
  end

  describe 'exception handling' do
    it 'java error' do
      expect {
        post '/add', params: {
          'name' => 'programmers',
          'content' => Base64.encode64(resource('groovy-programmers.jrxml'))
        }.to_json
      }.to_not raise_error

      expect(response_body).to eq \
        'success' => false,
        'exception' => 'java.lang.NoClassDefFoundError',
        'message' => 'org/codehaus/groovy/control/CompilationFailedException'
      expect(response.status).to eq 500
    end

    it 'ruby error' do
      expect { post '/add', params: 'no_hash' }.to_not raise_error
      expect(response_body).to eq('success' => false)
      expect(response.status).to eq 500
    end
  end
end
