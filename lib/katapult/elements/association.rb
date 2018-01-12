# Models an association between models

require 'katapult/element'

module Katapult
  class Association < Element

    IncompleteAssociationError = Class.new(StandardError)

    options :belongs_to

    def initialize(*args)
      super
      validate!

      self.belongs_to = belongs_to.to_s # Normalize
    end

    def model
      application_model.get_model! name
    end

    def belongs_to_model
      application_model.get_model! belongs_to
    end

    private

    def validate!
      belongs_to.present? or raise IncompleteAssociationError,
        'Missing :belongs_to option'
    end

  end
end
