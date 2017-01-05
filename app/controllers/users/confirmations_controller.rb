class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    super
    if resource.errors.empty?
      # Send an email asynchronously if Sidekiq is in use
      # AdminMailer.new_registration(resource.id).deliver_later
      AdminMailer.new_registration(resource.id).deliver_now
    end
  end
end
