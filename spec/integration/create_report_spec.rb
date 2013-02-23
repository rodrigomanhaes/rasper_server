require 'spec_helper'
require 'fileutils'

feature 'create report' do
  before(:each) do
    %w(jrxml jasper).each {|x| FileUtils.rm_rf(File.join(report_dir, "*.#{x}")) }
  end

  scenario 'send report to server' do
    post '/add', {}, {'RAW_POST_DATA' => { 'name' => 'programmers',
      'content' => Base64.encode64(resource('programmers.jrxml')) }.to_json }
    Dir[Rails.root.join('report', 'programmers.*')].map(&:to_s).should =~ \
      %w(programmers.jrxml programmers.jasper).map {|s|
        Rails.root.join('report', s).to_s
      }
  end
end