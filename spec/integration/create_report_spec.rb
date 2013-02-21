require 'spec_helper'
require 'fileutils'

feature 'create report' do
  before(:each) do
    %w(jrxml jasper).each {|x| FileUtils.rm_rf(File.join(report_dir, "*.#{x}")) }
  end

  scenario 'send report to server' do
    post reports_path, report: {
      'name' => 'programmers',
      'content' => File.read(File.join(resources_dir, 'programmers.jrxml')) }
    Dir[Rails.root.join('report', '*')].map(&:to_s).should =~ \
      %w(programmers.jrxml programmers.jasper).map {|s|
        Rails.root.join('report', s).to_s
      }
  end
end