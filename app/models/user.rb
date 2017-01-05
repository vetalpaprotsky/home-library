class User < ActiveRecord::Base
  has_many :books, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :evaluations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

  # Sometimes password is required for validation.
  # When omniauth user creates password in profile or reset password using email
  attr_accessor :password_is_required_for_validation

  # Send an email asynchronously if Sidekiq is in use
  # def send_devise_notification(notification, *args)
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end

  def self.from_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth[:info][:email]
      user.skip_confirmation!
    end
  end

  def password_in_use?(options = {})
    if options[:reload_encrypted_password]
      self.encrypted_password = User.find(id).encrypted_password
    end
    self.provider.blank? || self.encrypted_password.present?
  end

  # Overridden devise method
  def password_required?
    super && (password_in_use? || password_is_required_for_validation)
  end

  # Overridden devise method
  def update_with_password(params, *options)
    if !password_in_use?
      if params[:password].blank? && params[:password_confirmation].present?
        self.password_is_required_for_validation = true
      end
      update_attributes(params, *options)
    else
      super
    end
  end
end
