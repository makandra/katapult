require 'generators/katapult/clearance/clearance_generator'

module Katapult
  class Authentication < Element

    # @attr name: The user model name
    attr_accessor :system_email

    def ensure_user_model_attributes_present
      user_attrs = user.attrs.map(&:name)

      user.attr(:email) unless user_attrs.include?('email')
      user.attr(:password, type: :password, skip_db: true) unless user_attrs.include?('password')
    end

    def render(options = {})
      Generators::ClearanceGenerator.new(self, options).invoke_all
    end

    def user
      @user ||= application_model.get_model!(name)
    end

  end
end
