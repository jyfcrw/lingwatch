class Backend::WatchesController < Backend::BaseController
  before_action :find_watches_by_user, only: :index
  before_action -> { @user.nil? ? @navbar = :watch : @navbar = :user }
  load_and_authorize_resource :class => "Watch"

  def index
    @q = @watches.search(params[:q])
    @q.sorts = 'code desc' if @q.sorts.empty?
    @watches = @q.result.page(params[:page]).per(40)
  end

  def new
  end

  def create
    if @watch.save
      flash[:notice] = i18n('create.success', model: Watch, scope: 'flash')
      redirect_to_ok_url_or_default backend_watches_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @watch.update(watch_params)
      flash[:notice] = i18n('update.success', model: Watch, scope: 'flash')
      redirect_to_ok_url_or_default backend_watches_path
    else
      render :edit
    end
  end

  def destroy
    if @watch.destroy
      flash[:notice] = i18n('destroy.success', model: Watch, scope: 'flash')
    else
      flash[:error] = "删除拒绝，设备的绑定关系未解除"
    end
    redirect_to_ok_url_or_default backend_watches_path
  end

protected
  def watch_params
    permitable_params = [
      :model_type,
      :name,
      :code,
      :secret,
      :uid,
      :mac,
      :state,
      :poster,
      :remove_poster,
      :activated_at,
    ]

    params.require(:watch).permit(permitable_params) if params[:watch]
  end

  def find_watches_by_user
    if params[:user_id].present?
      @user = User.find(params[:user_id].to_i)
      @watches = @user.watches
    end
  end
end