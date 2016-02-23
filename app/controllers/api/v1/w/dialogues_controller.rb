class Api::V1::W::DialoguesController < Api::V1::W::BaseController
  before_action { @watch = current_watch }
  authorize_resource :dialogue

  def create
    @dialogue = (!params[:force] and current_watch.available_dialogue) || Dialogue.create!(device: @watch)

    render json: {
      result: 0,
      code: @dialogue.code,
      state: @dialogue.state,
      topic: @dialogue.full_topic_name,
      updated_at: @dialogue.updated_at
    }
  end

  def destroy
    @dialogue = current_watch.available_dialogue
    return render json: { result: 0 } unless @dialogue

    if @dialogue.update!(state: :closed)
      render json: { result: 0 }
    else
      render json: { result: 1, error: "删除会话异常，请重试" }, status: :not_found
    end
  end

  def join
    @dialogue = Dialogue.open.where(code: params[:code]).take
    return render json: { result: 1, error: "没有找到此会话" }, status: :not_found unless @dialogue

    if DialogueAccession.create(device: current_watch, dialogue: @dialogue)
      render json: { result: 0 }
    else
      render json: { result: 1, error: "加入会话异常" }, status: :not_found
    end
  end

  def exit
    @dialogue = Dialogue.open.where(code: params[:code]).take
    return render json: { result: 1, error: "没有找到此会话" }, status: :not_found unless @dialogue

    if DialogueAccession.create(device: current_watch, dialogue: @dialogue, action: :out)
      render json: { result: 0 }
    else
      render json: { result: 1, error: "退出会话异常" }, status: :not_found
    end
  end

end