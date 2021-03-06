class Ability
  include CanCan::Ability

  def initialize(obj = nil)
    case obj
    when User
      user_permissions(obj)
    end

    yield(self) if block_given?
  end

  def user_permissions(user)
    can :manage, user
    can :manage, UserAgent
    can :manage, Device
    can :manage, DeviceBinding
    can :manage, Dialogue

  end
end
