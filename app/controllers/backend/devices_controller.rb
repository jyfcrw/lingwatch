class Backend::DevicesController < Backend::BaseController
  before_filter :find_devices_by_user, only: :index
  before_action -> { @user.nil? ? @navbar = :device : @navbar = :user }
  load_and_authorize_resource

  def index
    @q = @devices.search(params[:q])
    @q.sorts = 'code desc' if @q.sorts.empty?
    @devices = @q.result.page(params[:page]).per(40)
  end

protected
  def find_devices_by_user
    if params[:user_id].present?
      @user = User.find(params[:user_id].to_i)
      @devices = @user.devices
    end
  end
end