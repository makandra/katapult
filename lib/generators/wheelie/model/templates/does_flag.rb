module DoesFlag
  as_trait do |field, options|

    options ||= {}

    default = options[:default]
    virtual = options[:virtual]
    field_var = "@#{field}"
    set_field = "#{field}="
    field_query = "#{field}?"

    validates_inclusion_of field.to_sym, :in => [true, false], :allow_nil => !!virtual

    unless default.nil?
      has_defaults field.to_sym => default
    end

    if virtual

      attr_reader field

      define_method field_query do
        send(field)
      end

      define_method set_field do |value|
        value = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
        instance_variable_set(field_var, value)
      end

    end

  end
end
