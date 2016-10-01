class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    super
    if resource.errors.empty?
      # => mail to admin
    end
  end
end
