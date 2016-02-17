class Mq::DeviceController < Mq::BaseController
  def state
    @device = Device.where(code: params[:cid]).take!
    if params[:state] and @device.update(state: params[:state]) # params[:ts]
      render json: { result: 0 }, status: :ok
    else
      render json: { result: 1, error: "设备状态更新失败" }, status: :not_found
    end
  end

  def update
  end
end
