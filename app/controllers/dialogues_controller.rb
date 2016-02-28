class DialoguesController < ApplicationController
  layout "mobile"

  def show
    render :show, locals: { err: nil }
  end

  def create
    return render :show, locals: { err: "请输入有效的会话号" } unless params[:join]

    join_params = params.require(:join).permit(:code)

    @dialogue = Dialogue.where(code: join_params[:code]).take

    return render :show, locals: { err: "没有找到该会话" } unless @dialogue

    session[:dialogue_code] = @dialogue.code

    redirect_to room_dialogue_path
  end

  def room
    return redirect_to dialogue_path unless session[:dialogue_code]

    @dialogue = Dialogue.where(code: session[:dialogue_code]).take

    session[:dialogue_username] = session[:dialogue_username] || "000000" + SecureRandom.hex(7)
    session[:dialogue_password] = session[:dialogue_password] || SecureRandom.hex(10)

    @browser = OpenStruct.new
    @browser.username = session[:dialogue_username]
    @browser.password = session[:dialogue_password]

    return redirect_to dialogue_path unless @dialogue
  end
end