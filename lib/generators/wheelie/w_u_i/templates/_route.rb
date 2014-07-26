% rails_actions = wui.actions.select{ |a| WUI::RAILS_ACTIONS.include? a.name }
resources :<%= plural_name %>, only: <%= rails_actions.map(&:name).map(&:to_sym) %> do
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
