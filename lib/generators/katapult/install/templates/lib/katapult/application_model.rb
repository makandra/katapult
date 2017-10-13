# In this file, you model your application. Refer to the README or get inspired
# by the full-fledged example below (which you can generate right away).

# Define models
model 'user' do |user|
  user.attr :email
  user.attr :name
  user.attr :last_visit, type: :datetime
  user.attr :locked, type: :flag, default: false
end

model 'product' do |product|
  product.attr :title
  product.attr :price, type: :money
  product.attr :mode, assignable_values: %w[public private]
  product.attr :provider, type: :url
  product.attr :import_data, type: :json
end

# Add web user interfaces
wui 'user' do |wui|
  wui.crud # Creates all CRUD actions: index, new, show, etc.
  wui.action :lock, scope: :member, method: :post
end

wui 'product', &:crud

# Have a main menu
navigation

# Add authentication
authenticate 'user', system_email: 'system@example.com'
