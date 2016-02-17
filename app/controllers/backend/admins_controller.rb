class Backend::AdminsController < Backend::BaseController
  before_action -> { @navbar = :admin }
  load_and_authorize_resource

  def index
    @admins = @admins.page(params[:page])
  end

  def new
  end

  def create
    if @admin.save
      flash[:notice] = i18n('create.success', model: Admin, scope: 'flash')
      redirect_to_ok_url_or_default backend_admins_path
    else
      render :new
    end
  end

  def destroy
    @admin.destroy
    flash[:notice] = i18n('destroy.success', model: Admin, scope: 'flash')
    redirect_to_ok_url_or_default backend_admins_path
  end

protected
  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation) if params[:admin]
  end
end
