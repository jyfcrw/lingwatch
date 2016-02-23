class Backend::WatchDialogueController < Backend::BaseController
  before_action -> { @navbar = :watch }
  before_action :find_watch_dialogue
  load_and_authorize_resource :class => "Watch"

  def show
  end

protected

  def find_watch_dialogue
    @watch = Watch.find(params[:watch_id])
    @watch_dialogue = @watch.available_dialogue
  end
end