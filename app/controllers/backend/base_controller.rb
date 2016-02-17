class Backend::BaseController < ApplicationController
  check_authorization

  rescue_from CanCan::AccessDenied do
    if current_admin
      render text: "AccessDenied", status: :forbidden
    else
      redirect_to new_admin_session_path
    end
  end

  layout "backend"

protected
  def current_ability
    @current_ability ||= AdminAbility.new(current_admin)
  end

  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end

  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.record
  end
  helper_method :current_admin

end
