require "simple_captcha"

class Api::V1::MainController < ApiBaseController
  include SimpleCaptcha::ControllerHelpers
  include SimpleCaptcha::ViewHelper

  skip_authorization_check

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: "请求提交失败，参数错误或服务异常" }, status: :not_found
  end

  def root
  end

  def sign_in
    session_params = params.slice(:phone, :password, :uid)
    return render json: { errors: "提交了错误的参数" }, status: :not_found if session_params.blank?

    @user_session = UserSession.new(session_params.slice(:phone, :password))
    if @user_session.save
      @user = @user_session.record
      render_access_token
    else
      render json: { errors: "登录失败，用户名或者密码错误" }, status: :not_found
    end
  end

  def sign_up
    case params[:step]
    when "captcha"
      return render_captcha_required
    when "sms"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]
      return render json: { errors: "图片验证码错误" }, status: :not_found unless sms_token_valid? or simple_captcha_valid?
      return render json: { errors: "您已经注册过了，直接去登录吧" }, status: 418 if User.registered.exists?(phone: params[:phone])

      @user = User.where(unconfirmed_phone: params[:phone]).first_or_create!
      if @user.send_sms_confirmation_instructions_to_unconfirmed_phone
        token = params[:sms_token] || generate_sms_token
        return render json: { phone: params[:phone], sms_token: token, send_at: Time.now }, status: 419
      else
        return render json: { errors: "请不要获取短信太频繁" }, status: :not_found
      end
    when "password"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]
      return render json: { errors: "密码参数错误" }, status: :not_found unless params[:password] and params[:password_confirmation] and params[:sms_code]
      return render json: { errors: "两次输入的密码不相同" }, status: :not_found unless params[:password] == params[:password_confirmation]
      @user = User.where(unconfirmed_phone: params[:phone], sms_confirmed_at: nil).take
      return render json: { errors: "短信验证码错误" }, status: :not_found unless @user and @user.validate_sms_confirmation(params[:sms_code])

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
        return render json: { errors: "注册失败" }, status: :not_found
      end
    else
      return render json: {
        errors: "请使用step参数指定注册步骤, 可选值为 captcha|sms|password"
      }, status: :not_found
    end
  end

  def password_recovery
    case params[:step]
    when "captcha"
      return render_captcha_required
    when "sms"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]
      return render json: { errors: "图片验证码错误" }, status: :not_found unless sms_token_valid? or simple_captcha_valid?
      @user = User.registered.where(phone: params[:phone]).take
      return render json: { errors: "手机号还没有注册，马上去注册吧" }, status: 418 unless @user

      if @user.send_sms_confirmation_instructions
        token = params[:sms_token] || generate_sms_token
        return render json: { phone: params[:phone], sms_token: token, send_at: Time.now }, status: 419
      else
        return render json: { errors: "请不要获取短信太频繁" }, status: :not_found
      end
    when "password"
      return render json: { errors: "缺少手机号参数" }, status: :not_found unless params[:phone]
      return render json: { errors: "密码参数错误" }, status: :not_found unless params[:password] and params[:password_confirmation] and params[:sms_code]
      return render json: { errors: "两次输入的密码不相同" }, status: :not_found unless params[:password] == params[:password_confirmation]
      @user = User.registered.where(phone: params[:phone]).take
      return render json: { errors: "短信验证码错误" }, status: :not_found unless @user and @user.validate_sms_confirmation(params[:sms_code])

      if @user.update({
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        sms_confirmation_code: nil })
        @user.reset_single_access_token
        render_access_token
      else
        return render json: { errors: "密码修改失败，请重新尝试" }, status: :not_found
      end
    else
      return render json: {
        errors: "请使用step参数指定密码找回步骤, 可选值为 captcha|sms|password"
      }, status: :not_found
    end
  end

protected

  def sms_token_valid?
    Redis.current.exists("secuper:sms:token:#{params[:phone]}_#{params[:sms_token]}")
  end

  def generate_sms_token
    return unless simple_captcha_valid?

    token = SecureRandom.hex(10)
    Redis.current.setex("secuper:sms:token:#{params[:phone]}_#{token}", 10.minutes.to_i, 1)
    token
  end

  def render_access_token
    {
      access_token: @user.single_access_token,
      last_login_ts: @user.last_login_at,
      current_login_ts: Time.now
    }.tap { |t| render json: t.compact }
  end

  def render_captcha_required
    # request captcha image
    key = simple_captcha_key
    set_simple_captcha_data(key)
    result = { captcha_key: key, captcha_image_url: simple_captcha_image_url(key) }
    result = result.merge({errors: "图片验证失败，请重新输入"}) if params[:captcha]
    return render json: result, status: :payment_required
  end

  def simple_captcha_image_url(simple_captcha_key)
    defaults = {}
    defaults[:time] = Time.now.to_i
    defaults[:code] = simple_captcha_key
    querystring = defaults.map { |key, value| "#{key}=#{value}" }.join('&')
    public_url("/simple_captcha?#{querystring}")
  end
  helper_method :simple_captcha_image_url
end