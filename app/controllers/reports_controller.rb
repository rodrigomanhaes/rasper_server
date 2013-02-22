require 'base64'

class ReportsController < ApplicationController
  respond_to :json

  def create
    Report.create(params[:report])
    render json: { success: true }
  end

  def generate
    name = params[:id]
    content = Base64.encode64(
      Report.generate(name, params[:data], params[:parameters]))
#    binding.pry
    render json: { content: content }
  end
end


# curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"data": [{"name": "Linus", "software": "Linux" }, {"name": "Guido", "software": "Python"}], "params": {"DATA": "agora", "LOCAL": "aqui"}}'  http://localhost:3000/reports/programmers