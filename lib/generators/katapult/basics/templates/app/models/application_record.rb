class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def these(arg)
      where(id: arg.collect_ids)
    end

    def find_by_anything(identifier)
      matchable_columns = columns.reject { |column| [:binary, :boolean].include?(column.type) }
      query_clauses = matchable_columns.collect do |column|
        qualified_column_name = "#{table_name}.#{column.name}"
        is_mysql = connection.class.name =~ /mysql/i
        target_type = is_mysql ? 'CHAR' : 'TEXT' # CHAR is only 1 character in PostgreSQL
        column_as_string = "CAST(#{qualified_column_name} AS #{target_type})"
        "#{column_as_string} = ?"
      end
      bindings = [identifier] * query_clauses.size
      where([query_clauses.join(' OR '), *bindings]).first
    end

    def find_by_anything!(identifier)
      find_by_anything(identifier) or raise ActiveRecord::RecordNotFound,
        "No column equals #{identifier.inspect}"
    end
  end

end
