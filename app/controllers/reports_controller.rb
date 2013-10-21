require 'base64'

class ReportsController < ApplicationController
  respond_to :json

  def add
    req = JSON.parse(request.body.read).symbolize_keys
    Report.create(req)
    render json: { success: true }
  end

  def generate
    encoded_content = JSON.parse(request.body.read)['data']
    decoded_content = Base64.decode64(encoded_content)
    req = JSON.parse(decoded_content).symbolize_keys
    content = Base64.encode64(
      Report.generate(req[:name], req[:data], req[:parameters]))
    render json: { content: content }
  end
end