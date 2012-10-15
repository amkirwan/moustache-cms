module MoustacheCms
  module Deviseable
    extend ActiveSupport::Concern

    included do
      devise :database_authenticatable, :recoverable, :rememberable, :trackable, :timeoutable

      # -- Devise Authenticatable -----
      field :email
      field :encrypted_password

      # -- Devise Recoverable ---
      field :reset_password_token
      field :reset_password_sent_at, :type => Time

      # -- Devise Rememberable ---
      field :remember_created_at, :type => Time

      # -- Devise Trackable ---
      field :sign_in_count,      :type => Integer
      field :current_sign_in_at, :type => Time
      field :last_sign_in_at,    :type => Time
      field :current_sign_in_ip
      field :last_sign_in_ip
    end

  end
end
