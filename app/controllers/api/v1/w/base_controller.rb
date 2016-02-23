class Api::V1::W::BaseController < ApiBaseController
  before_action do
    render json: { message: "请先验证，再重试" }, status: :unauthorized unless current_watch and current_user
  end

  rescue_from CanCan::AccessDenied do
    render json: { errors: "没有请求的权限" }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: "没有找到请求的对象" }, status: :not_found
  end

protected
  def current_watch
    return @current_watch if defined?(@current_watch)
    authenticate_with_http_basic { |c, s| @current_watch = Watch.where(code: c, secret: s).take }
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_watch.user if current_watch
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
