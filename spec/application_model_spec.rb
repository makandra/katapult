require 'katapult/application_model'

describe Katapult::ApplicationModel do

  describe '#crud' do
    it 'adds a model plus a web UI with CRUD actions' do
      model = <<-MODEL
crud 'user' do |user|
  user.attr :age
end
      MODEL

      subject = described_class.parse(model)
      expect(subject.models.count).to be 1
      user = subject.models.first
      expect(user.name).to eq 'user'
      expect(user.attrs.count).to be 1
      expect(user.attrs.first.name).to eq 'age'

      expect(subject.web_uis.count).to be 1
      web_ui = subject.web_uis.first
      expect(web_ui.actions.map(&:name)).to match Katapult::WebUI::RAILS_ACTIONS
    end
  end

end
