require 'base64'

class ReportsController < ApplicationController
  def add
    req = JSON.parse(request.body.read).symbolize_keys
    Report.create(req)
    render json: { success: true }
  rescue Exception => e
    handle_exception(e)
  end

  def generate
    encoded_content = JSON.parse(request.body.read)['data']
    decoded_content = Base64.decode64(encoded_content)
    req = JSON.parse(decoded_content).symbolize_keys
    content = Base64.encode64(
      Report.generate(req[:name], req[:data],
        req[:parameters] == nil ? {} : req[:parameters]))
    render json: { content: content }
  end

  private

  def handle_exception(e)
    if e.respond_to?(:java_class) && e.java_class.present?
      render \
        json: {
          success: false, exception: e.java_class.to_s, message: e.message
        },
        status: 500
    else
      render json: { success: false }, status: 500
    end
  end
end
