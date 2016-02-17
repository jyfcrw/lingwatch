class Mq::AuthController < Mq::BaseController
  def authenticate
    @device = Device.where(code: params[:cid]).take!
    if params[:mode] == "digest"
      signature = Digest::MD5.hexdigest(@device.code + ":" + params[:ts] + ":" + @device.secret)
    end
    render json: { token: signature }
  end

  def pulbish
    render json: { mode: "basic", value: "true"}
  end

  def subscribe
    render json: { mode: "basic", value: "true"}
  end
end
