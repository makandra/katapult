require 'spec_helper'
require 'katapult/wui'
require 'katapult/model'
require 'katapult/application_model'

describe Katapult::WUI do

  subject { described_class.new 'wui' }

  let(:application_model) { Katapult::ApplicationModel.new }

  describe '#path' do
    it 'raises an error if the given action does not exist' do
      expect do
        subject.path(:foobar)
      end.to raise_error(Katapult::WUI::UnknownActionError)
    end
  end

  describe '#crud_only?' do
    it 'is true for a crud WUI' do
      subject.crud
      expect(subject.crud_only?).to be true
    end

    it 'is false if the WUI has custom actions' do
      subject.crud
      subject.action :custom, method: :get, scope: :collection
      expect(subject.crud_only?).to be false
    end

    it 'is false if the WUI does not have all CRUD actions' do
      subject.action :index
      subject.action :show
      expect(subject.crud_only?).to be false
    end
  end

  describe '#model' do
    it 'returns the model object' do
      subject = described_class.new('Customer', model: 'User')
      model = Katapult::Model.new('User')

      application_model.add_wui(subject)
      application_model.add_model(model)

      expect(subject.model).to eql(model)
    end

    it 'detects the model from its own name, if not stated explicitly' do
      subject = described_class.new('Customer')
      model = Katapult::Model.new('Customer')

      application_model.add_wui(subject)
      application_model.add_model(model)

      expect(subject.model).to eql(model)
    end

    it 'raises an error if it cannot find the model' do
      subject = described_class.new('MissingModel')
      application_model.add_wui(subject)

      expect{ subject.model }.to raise_error(Katapult::WUI::UnknownModelError)
    end
  end

end
