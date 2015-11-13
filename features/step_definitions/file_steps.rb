When /^I replace "(.*?)" with "(.*?)" inside "(.*?)"$/ do |a, b, path|
  in_current_dir do
    content = File.read(path)
    content.gsub! a, b
    File.open(path, 'w') { |file| file.puts(content) }
  end
end

Then /^there should be a migration with:$/ do |migration|
  migrations_path = File.join(current_dir, 'db', 'migrate', '*.rb')

  all_migrations = Dir.glob(migrations_path).map(&File.method(:read)).join
  expect(all_migrations).to include(migration)
end

Then /^the file named "(.+?)" should contain "(.+?)" exactly once$/ do |file_name, content|
  cd '.' do
    occurrences = File.read(file_name).scan(content)

    expect( occurrences.count ).to eq(1), <<-ERROR_MESSAGE
      Expected file "#{ file_name }" to contain "#{ content }"
      once, but had it #{ occurrences.count } times.
    ERROR_MESSAGE
  end
end
