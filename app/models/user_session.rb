class UserSession < Authlogic::Session::Base

  def credentials=(value)
    super
  end
end