class Backend::SimpleDevicesController < Backend::BaseController
  before_filter :find_simple_devices_by_user, only: :index
  before_action -> { @user.nil? ? @navbar = :simple_device : @navbar = :user }
  load_and_authorize_resource

  def index
    @q = @simple_devices.search(params[:q])
    @q.sorts = 'code desc' if @q.sorts.empty?
    @simple_devices = @q.result.page(params[:page]).per(40)
  end

  def new
  end

  def create
    if @simple_device.save
      flash[:notice] = i18n('create.success', model: SimpleDevice, scope: 'flash')
      redirect_to_ok_url_or_default backend_simple_devices_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @simple_device.update(simple_device_params)
      flash[:notice] = i18n('update.success', model: SimpleDevice, scope: 'flash')
      redirect_to_ok_url_or_default backend_simple_devices_path
    else
      render :edit
    end
  end

  def destroy
    if @simple_device.destroy
      flash[:notice] = i18n('destroy.success', model: SimpleDevice, scope: 'flash')
    else
      flash[:error] = "删除拒绝，设备的绑定关系未解除"
    end
    redirect_to_ok_url_or_default backend_simple_devices_path
  end

protected
  def simple_device_params
    permitable_params = [
      :model_type,
      :name,
      :code,
      :secret,
      :mac,
      :state,
      :poster,
      :remove_poster,
      :activated_at,
    ]

    params.require(:simple_device).permit(permitable_params) if params[:simple_device]
  end

  def find_simple_devices_by_user
    if params[:user_id].present?
      @user = User.find(params[:user_id].to_i)
      @simple_devices = @user.simple_devices
    end
  end
end