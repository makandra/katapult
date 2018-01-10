require 'katapult/parser'

describe Katapult::Parser do

  describe '#crud' do
    it 'creates a model plus a web UI with crud actions' do
      model = <<-MODEL
crud 'user' do |user|
  user.attr :age
end
      MODEL

      parsed_model = subject.parse(model)
      expect(parsed_model.models.count).to be 1
      user = parsed_model.models.first
      expect(user.name).to eq 'user'
      expect(user.attrs.count).to be 1
      expect(user.attrs.first.name).to eq 'age'

      expect(parsed_model.web_uis.count).to be 1
      web_ui = parsed_model.web_uis.first
      expect(web_ui.actions.map(&:name)).to match Katapult::WebUI::RAILS_ACTIONS
    end
  end

end
