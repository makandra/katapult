% rails_actions = web_ui.actions - web_ui.custom_actions
resources <%= model_name(:symbols) %>, only: <%= rails_actions.map(&:name).map(&:to_sym) %> do
    member do
% web_ui.custom_actions.select(&:member?).each do |action|
      <%= action.method %> '<%= action.name %>'
% end
    end
    collection do
% web_ui.custom_actions.select(&:collection?).each do |action|
      <%= action.method %> '<%= action.name %>'
% end
    end
  end
