Then(/^there should be a migration with:$/) do |migration|
  migrations_path = File.join(current_dir, 'db', 'migrate', '*.rb')

  all_migrations = Dir.glob(migrations_path).map(&File.method(:read)).join
  all_migrations.should include(migration)
end
