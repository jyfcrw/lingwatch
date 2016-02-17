class Backend::UsersController < Backend::BaseController
  before_action -> { @navbar = :user }
  load_and_authorize_resource

  def index
    @q = @users.registered.search(params[:q])
    @q.sorts = 'created desc' if @q.sorts.empty?
    @users = @q.result.page(params[:page])
  end

  def new
  end

  def create
    if @user.save
      flash[:notice] = i18n('create.success', model: User, scope: 'flash')
      redirect_to_ok_url_or_default backend_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = i18n('update.success', model: User, scope: 'flash')
      redirect_to_ok_url_or_default backend_users_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = i18n('destroy.success', model: User, scope: 'flash')
    redirect_to_ok_url_or_default backend_users_path
  end

protected
  def user_params
    params.require(:user).permit([
      :phone,
      :name,
      :avatar,
      :remove_avatar,
      :password,
      :password_confirmation,
      :sms_confirmed_at,
      :active
    ])
  end
end
