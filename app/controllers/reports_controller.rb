require 'base64'

class ReportsController < ApplicationController
  respond_to :json

  def add
    req = JSON.parse(request.body.read).symbolize_keys
    Report.create(req)
    render json: { success: true }
  end

  def generate
    req = JSON.parse(request.body.read).symbolize_keys
    content = Base64.encode64(
      Report.generate(req[:name], req[:data], req[:parameters]))
#    binding.pry
    render json: { content: content }
  end
end


# curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"data": [{"name": "Linus", "software": "Linux" }, {"name": "Guido", "software": "Python"}], "params": {"DATA": "agora", "LOCAL": "aqui"}}'  http://localhost:3000/reports/programmers