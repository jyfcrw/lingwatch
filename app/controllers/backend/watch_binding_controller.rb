class Backend::WatchBindingController < Backend::BaseController
  before_action -> { @navbar = :watch }
  before_action :find_watch_binding
  load_and_authorize_resource :class => "Watch"

  def show
  end

  def create
    @user = User.where(phone: params[:phone]).take!
    if @watch.update(user: @user, activated_at: Time.now)
      flash[:notice] = "绑定成功"
    else
      flash[:error] = "绑定失败"
    end
    redirect_to backend_watch_binding_path(@watch)
  end

  def destroy
    if @watch.binding.destroy
      flash[:notice] = "解绑完成"
    else
      flash[:error] = "解绑失败"
    end
    redirect_to backend_watch_binding_path(@watch)
  end

protected

  def find_watch_binding
    @watch = Watch.find(params[:watch_id])
    @watch_binding = @watch.binding
  end
end