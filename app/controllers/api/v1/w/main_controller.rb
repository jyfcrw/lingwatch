class Api::V1::W::MainController < ApiBaseController

  skip_authorization_check

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: "请求提交失败，参数错误或服务异常" }, status: :not_found
  end

  def root
  end

  def auth
    case params[:step]
    when "sms"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]

      if @user = User.registered.where(phone: params[:phone]).take
        if @user.send_sms_confirmation_instructions
          token = params[:sms_token] || generate_sms_token
          return render json: { phone: params[:phone], forward: 1, sms_token: token, send_at: @user.sms_last_request_at }, status: 419
        else
          return render json: { errors: "请不要获取短信太频繁" }, status: :not_found
        end
      else
        @user = User.where(unconfirmed_phone: params[:phone]).first_or_create!
        if @user.send_sms_confirmation_instructions_to_unconfirmed_phone
          token = params[:sms_token] || generate_sms_token
          return render json: { phone: params[:phone], sms_token: token, send_at: @user.sms_last_request_at }, status: 419
        else
          return render json: { errors: "请不要获取短信太频繁" }, status: :not_found
        end
      end
    when "password"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]
      return render json: { errors: "密码参数错误" }, status: :not_found unless params[:password] and params[:password_confirmation] and params[:sms_code]
      return render json: { errors: "两次输入的密码不相同" }, status: :not_found unless params[:password] == params[:password_confirmation]
      @user = User.where(unconfirmed_phone: params[:phone], sms_confirmed_at: nil).take
      return render json: { errors: "短信验证码错误" }, status: :not_found unless @user and sms_token_valid? and @user.validate_sms_confirmation(params[:sms_code])

      if @user.update!({
        phone: @user.unconfirmed_phone,
        unconfirmed_phone: nil,
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        sms_confirmed_at: Time.now,
        sms_confirmation_code: nil })
        @user.reset_single_access_token
        render_access_token
      else
        return render json: { errors: "激活失败" }, status: :not_found
      end
    when "forward"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]
      @user = User.registered.where(phone: params[:phone]).take
      return render json: { errors: "短信验证码错误" }, status: :not_found unless @user and sms_token_valid? and @user.validate_sms_confirmation(params[:sms_code])
      if @user.update!(sms_confirmation_code: nil)
        render_access_token
      else
        return render json: { errors: "激活失败" }, status: :not_found
      end
    else
      return render json: {
        errors: "请使用step参数指定注册步骤, 可选值为 sms|password|forward"
      }, status: :not_found
    end
  end

  def bind
    return render json: { errors: "缺少必要参数" }, status: :not_found unless params[:uid] or params[:token]
    @user = User.find_by_single_access_token(params[:token])
    @watch = Watch.where(uid: params[:uid]).take
    return render json: { errors: "不存在该设备" }, status: :not_found unless @watch

    unless @watch.user
      return render json: { errors: "激活出错，请重新尝试" }, status: :not_found unless @watch.update(user: @user, activated_at: Time.now)
    end
    return render json: { errors: "没有权限激活此设备" }, status: :not_found unless @watch.user == @user

    render json: { code: @watch.code, uid: @watch.uid, secret: @watch.secret }, status: :ok
  end

protected

  def sms_token_valid?
    Redis.current.exists("#{Rails.application.class.parent_name.downcase}:sms:token:#{params[:phone]}_#{params[:sms_token]}")
  end

  def generate_sms_token
    token = SecureRandom.hex(10)
    Redis.current.setex("#{Rails.application.class.parent_name.downcase}:sms:token:#{params[:phone]}_#{token}", 10.minutes.to_i, 1)
    token
  end

  def render_access_token
    {
      access_token: @user.single_access_token,
      last_login_ts: @user.last_login_at,
      current_login_ts: Time.now
    }.tap { |t| render json: t.compact }
  end
end