class Api::V1::BaseController < ApiBaseController
  before_action do
    return render json: { message: "请先登录后，再重试" }, status: :unauthorized unless current_user
  end

  rescue_from CanCan::AccessDenied do
    render json: { errors: "没有请求的权限" }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: "没有找到请求的对象" }, status: :not_found
  end

protected
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by_single_access_token(request.authorization)
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
