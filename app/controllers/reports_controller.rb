class ReportsController < ApplicationController
  respond_to :json

  def create
    Report.create(params[:report])
    respond_with success: true
  end
end