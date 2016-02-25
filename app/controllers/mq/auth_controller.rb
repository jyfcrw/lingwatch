class Mq::AuthController < Mq::BaseController

  def authenticate
    if params[:mode] == "digest"
      signature = Digest::MD5.hexdigest(@device.code + ":" + params[:ts] + ":" + @device.secret)
    end
    render json: { token: signature }
  end

  # params[:topic], params[:data], params[:ts]
  def pulbish
    return render json: { error: "会话号不能为空" }, status: :not_found unless params[:topic]

    topic_set = params[:topic].split("/")
    return render json: { error: "错误的会话号格式" }, status: :not_found if topic_set.length < 2

    authed = false
    if topic_set[0] == Device.to_s and topic_set[1] == @device.code
      authed = true
    elsif topic_set[0] == Dialogue.to_s and topic_set[1] == @device.available_dialogue.code
      authed = true
    end

    if authed
      render json: { mode: "basic", value: true }
    else
      render json: { mode: "basic", value: false }
    end
  end

  def subscribe
    return render json: { error: "会话号不能为空" }, status: :not_found unless params[:topic]

    topic_set = params[:topic].split("/")
    return render json: { error: "错误的会话号格式" }, status: :not_found if topic_set.length < 2

    authed = false
    if topic_set[0] == Device.to_s
      authed = topic_set[1] === @device.code
    end

    if topic_set[0] == Dialogue.to_s
      @dialogue = Dialogue.open.where(code: topic_set[1]).take

      return render json: { error: "不存在的会话" }, status: :not_found unless @dialogue

      return render json: { mode: "basic", value: true } if @dialogue.device == @device

      @accession = @dialogue.dialogue_accessions.where(device: @device).last
      authed = true if @accession and @accession.action === :in
    end

    if authed
      render json: { mode: "basic", value: true }
    else
      render json: { mode: "basic", value: false }
    end
  end
end
