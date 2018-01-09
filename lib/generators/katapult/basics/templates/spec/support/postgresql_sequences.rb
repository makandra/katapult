# We initialize all Postgres sequences with high values so that tests setting
# specific ids will not accidentally reuse the same ids

RSpec.configure do |config|
  config.before(:suite) do

    connection = ActiveRecord::Base.connection
    sequences = connection.select_values("SELECT relname FROM pg_class WHERE pg_class.relkind = 'S'")

    sequences.each do |sequence|
      connection.execute("SELECT setval('#{sequence}', 1000000)")
    end

  end
end
