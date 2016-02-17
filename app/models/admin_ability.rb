class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    return if admin.nil?

    assign_administrator_permissions(admin)
  end

  def assign_administrator_permissions(admin)
    can    :manage, :sidekiq
    can    :manage,  Admin
    cannot :destroy, admin

    can    :manage,  Backend
    can    :manage,  User
    can    :manage,  Device
    can    :manage,  DeviceBinding
  end
end
