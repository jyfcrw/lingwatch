class Backend::SessionsController < Backend::BaseController
  skip_authorization_check

  def new
    @admin_session = AdminSession.new
  end

  def create
    @admin_session = AdminSession.new(params[:admin_session])
    if @admin_session.save
      flash[:notice] = "登陆后台成功！"
      redirect_to_ok_url_or_default backend_root_path
    else
      render :new
    end
  end

  def destroy
    current_admin_session.destroy
    flash[:notice] = "注销成功!"
    redirect_to new_admin_session_path
  end
end
