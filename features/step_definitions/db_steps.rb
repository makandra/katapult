Then(/^a db table named "(.*?)" should exist$/) do |table|
  require 'sequel'
  db_path = "sqlite://#{current_dir}/db/development.sqlite3"
  
  Sequel.connect(db_path) { |db|
    db.table_exists?(table)
  }.should == true
end
