class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    super
    if resource.errors.empty?
      # Works with sidekiq
      # AdminMailer.new_registration(resource.id).deliver_later
      AdminMailer.new_registration(resource.id).deliver_now
    end
  end
end
