class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    if resource.persisted?
      #mail to admin
    end
  end
end
