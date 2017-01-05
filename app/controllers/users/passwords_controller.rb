class Users::PasswordsController < Devise::PasswordsController

  def update
    super do |user|
      user.password_is_required_for_validation = true
      user.validate
    end
  end
end