class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is_admin? || user.role.name == "Admin"
      can :manage, :all
    else     
      user.role.permissions.each do |permission|
       can permission.action_name.to_sym, permission.object_type.constantize
      end

      if user.role.name == "Cliente"
        can [:edit_password, :update_password], User
      end

      can :update_position, [PageImage, Banner, Image]

    end
  end
end
