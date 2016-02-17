class Api::V1::UserController < Api::V1::BaseController
  before_action { @user = current_user }
  authorize_resource :user, singleton: true

  def profile
  end

  def change_profile
    if @user.update(params.permit(:name, :avatar))
      return render json: { msg: "更新个人信息成功" }, status: :ok
    else
      return render json: { errors: "更新个人信息失败" }, status: :not_found
    end
  end

  def change_password
    return render json: { errors: "提交的参数不正确" }, status: :not_found unless params[:password] and params[:old_password] and params[:password_confirmation]
    return render json: { errors: "两次输入的密码不相同" }, status: :not_found unless params[:password] == params[:password_confirmation]
    return render json: { errors: "旧密码不正确" }, status: :not_found unless @user.valid_password?(params[:old_password])

    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save!
      return render json: { msg: "密码修改成功" }, status: :ok
    else
      return render json: { errors: "修改密码失败" }, status: :not_found
    end
  end

  def sign_out
    # @user.reset_single_access_token
    return render json: { msg: "退出登录成功" }, status: :ok
  end
end
