DatabaseCleaner.clean_with(:deletion) # clean once, now
DatabaseCleaner.strategy = :transaction
Cucumber::Rails::Database.javascript_strategy = :deletion
