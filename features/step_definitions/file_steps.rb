When /^I replace "(.*?)" with "(.*?)" inside "(.*?)"$/ do |a, b, path|
  in_test_app do
    content = File.read(path)
    content.gsub! a, b
    File.open(path, 'w') { |file| file.puts(content) }
  end
end

Then /^there should be a migration with:$/ do |migration|
  migrations_path = File.join(current_dir, 'db', 'migrate', '*.rb')

  all_migrations = Dir.glob(migrations_path).map(&File.method(:read)).join
  all_migrations.should include(migration)
end
