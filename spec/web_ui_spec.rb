require 'katapult/elements/web_ui'
require 'katapult/elements/model'
require 'katapult/application_model'

describe Katapult::WebUI do

  subject { described_class.new 'web_ui' }

  let(:application_model) { Katapult::ApplicationModel.new }

  describe '#path' do
    it 'raises an error if the given action does not exist' do
      expect do
        subject.path(:foobar)
      end.to raise_error(Katapult::WebUI::UnknownActionError)
    end
  end

  describe '#crud_only?' do
    it 'is true for a crud WebUI' do
      subject.crud
      expect(subject.crud_only?).to be true
    end

    it 'is false if the WebUI has custom actions' do
      subject.crud
      subject.action :custom, method: :get, scope: :collection
      expect(subject.crud_only?).to be false
    end

    it 'is false if the WebUI does not have all CRUD actions' do
      subject.action :index
      subject.action :show
      expect(subject.crud_only?).to be false
    end
  end

  describe '#model' do
    it 'returns the model object' do
      application_model.model 'User'

      subject = described_class.new('Customer',
        model: 'User',
        application_model: application_model,
      )

      expect(subject.model).to be application_model.models.first
    end

    it 'detects the model from its own name, if not stated explicitly' do
      application_model.model 'Customer'
      subject = described_class.new('Customer', application_model: application_model)

      expect(subject.model).to be application_model.models.first
    end
  end

  describe '#render' do
    it 'raises an error when its model does not have a label attribute' do
      application_model.model 'user'
      application_model.web_ui 'user'

      subject = application_model.get_web_ui('user')
      expect{ subject.render }.to raise_error Katapult::WebUI::MissingLabelAttrError,
        'Cannot render a WebUI without a model with a label attribute'
    end
  end

end
