class Backend::UserAgentsController < Backend::BaseController
  before_action -> { @navbar = :user }
  load_and_authorize_resource :user
  load_and_authorize_resource

  def index
    @q = @user.user_agents.search(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @user_agents = @q.result.page(params[:page]).per(40)
  end

end