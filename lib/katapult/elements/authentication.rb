require 'generators/katapult/clearance/clearance_generator'

module Katapult
  class Authentication < Element

    # attr name: The user model name
    attr_accessor :system_email

    def ensure_user_model_attributes_present
      user_model = application_model.get_model!(name)
      user_attrs = user_model.attrs.map(&:name)

      user_model.attr(:email) unless user_attrs.include?('email')
      user_model.attr(:password, type: :password, skip_db: true) unless user_attrs.include?('password')
    end

    def render
      Generators::ClearanceGenerator.new(self).invoke_all
    end

  end
end
