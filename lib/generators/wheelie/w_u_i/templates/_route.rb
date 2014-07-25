resources :<%= plural_name %>, only: <%= wui.rails_actions.map(&:name).map(&:to_sym) %> do
    member do
% wui.member_actions.each do |action|
      <%= action.method %> '<%= action.name %>'
% end
    end
    collection do
% wui.collection_actions.each do |action|
      <%= action.method %> '<%= action.name %>'
% end
    end
  end
