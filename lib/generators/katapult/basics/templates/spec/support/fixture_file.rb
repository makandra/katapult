include ActionDispatch::TestProcess

def fixture_file(file_name)
  file_path = Rails.root.join('spec/assets', file_name)
  File.open(file_path)
end
