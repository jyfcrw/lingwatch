class Mq::MessageController < Mq::BaseController

  def create
    topic_set = params[:topic].split("/")
    return render json: { error: "错误的消息" }, status: :not_found if topic_set.length < 2

    if topic_set[0] == Dialogue.to_s and topic_set[1] == @device.available_dialogue.code
      @dialogue = Dialogue.open.where(code: topic_set[1]).take
    end

    if DialogueMessage.create(
      device: @device,
      dialogue: @dialogue,
      topic: params[:topic],
      content: params[:payload],
      created_at: params[:ts]
    )
      render json: { result: 0 }, status: :ok
    else
      render json: { result: 1, error: "创建消息记录失败" }, status: :ok
    end
  end
end