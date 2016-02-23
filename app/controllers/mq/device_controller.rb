class Mq::DeviceController < Mq::BaseController
  def state
    if params[:state] and @device.update(state: params[:state]) # params[:ts]
      render json: { result: 0 }, status: :ok
    else
      render json: { result: 1, error: "设备状态更新失败" }, status: :not_found
    end
  end

  # 接口用户更新设备其他属性
  def update
  end
end
