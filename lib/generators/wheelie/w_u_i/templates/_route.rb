% rails_actions = wui.actions - wui.custom_actions
resources <%= model_name(:symbols) %>, only: <%= rails_actions.map(&:name).map(&:to_sym) %> do
    member do
% wui.custom_actions.select(&:member?).each do |action|
      <%= action.method %> '<%= action.name %>'
% end
    end
    collection do
% wui.custom_actions.select(&:collection?).each do |action|
      <%= action.method %> '<%= action.name %>'
% end
    end
  end
