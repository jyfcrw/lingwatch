class Mq::MainController < Mq::BaseController

  def root
    render json: { result: 0 }, status: :ok
  end
end