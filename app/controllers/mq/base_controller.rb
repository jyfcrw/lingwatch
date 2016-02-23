class Mq::BaseController < ActionController::Base
  before_action :find_device

protected

  def find_device
    @device = Device.where(code: params[:cid]).take
    render json: { error: "找不到设备[#{params[:cid]}]" } unless @device
  end
end
