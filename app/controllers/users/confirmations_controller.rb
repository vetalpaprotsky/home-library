class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    super
    if resource.errors.empty?
      AdminMailer.new_registration(resource.id).deliver_later
    end
  end
end
