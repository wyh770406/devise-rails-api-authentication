require 'devise'

module DeviseRailsApiAuthentication
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      devise :database_authenticatable, :trackable
      before_save :ensure_authentication_token
    end

    def ensure_authentication_token
      self.authentication_token = generate_authentication_token if authentication_token.blank?
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token if self.class.where(authentication_token: token).count == 0
      end
    end
  end
end