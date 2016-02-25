class Mq::DeviceController < Mq::BaseController
  def state
    return render json: { result: 1, error: "请求参数错误" }, status: :not_found unless params[:state]
    return render json: { result: 0 }, statue: :unprocessable_entity if @device.state_timestamp and @device.state_timestamp > params[:ts]

    if @device.update(state: params[:state], state_timestamp: params[:ts])
      render json: { result: 0 }, status: :ok
    else
      render json: { result: 1, error: "设备状态更新失败" }, status: :not_found
    end
  end

  # 接口用户更新设备其他属性
  def update
  end
end
