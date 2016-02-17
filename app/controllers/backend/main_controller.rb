class Backend::MainController < Backend::BaseController
  authorize_resource :class => "Backend"

  def root
    @navbar = :dashboard
  end
end
