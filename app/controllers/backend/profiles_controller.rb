class Backend::ProfilesController < Backend::BaseController
  before_action -> { @navbar = :admin }
  before_action -> { @admin = current_admin }
  authorize_resource :admin

  def edit
  end

  def update
    @admin.require_current_password!
    if @admin.update(admin_params)
      flash[:notice] = "密码修改成功"
      redirect_to_ok_url_or_default backend_root_path
    else
      render :edit
    end
  end

protected
  def admin_params
    params.require(:admin).permit(:password, :password_confirmation, :current_password) if params[:admin]
  end
end

