require 'spec_helper'
require 'wheelie/wui'
require 'wheelie/model'
require 'wheelie/application_model'

describe Wheelie::WUI do

  subject { described_class.new 'wui' }

  let(:application_model) { Wheelie::ApplicationModel.new }

  describe '#path' do
    it 'raises an error if the given action does not exist' do
      expect do
        subject.path(:foobar)
      end.to raise_error(Wheelie::WUI::UnknownActionError)
    end
  end

  describe '#model' do
    it 'returns the model object' do
      subject = described_class.new('Customer', model: 'User')
      model = Wheelie::Model.new('User')

      application_model.add_wui(subject)
      application_model.add_model(model)

      expect(subject.model).to eql(model)
    end

    it 'detects the model from its own name, if not stated explicitly' do
      subject = described_class.new('Customer')
      model = Wheelie::Model.new('Customer')

      application_model.add_wui(subject)
      application_model.add_model(model)

      expect(subject.model).to eql(model)
    end

    it 'raises an error if it cannot find the model' do
      subject = described_class.new('MissingModel')
      application_model.add_wui(subject)

      expect{ subject.model }.to raise_error(Wheelie::WUI::UnknownModelError)
    end
  end

  describe '#model' do
    it 'returns the model object' do
      subject = described_class.new('Customer', model: 'User')
      model = Wheelie::Model.new('User')

      application_model.add_wui(subject)
      application_model.add_model(model)

      expect(subject.model).to eql(model)
    end

    it 'detects the model from its own name, if not stated explicitly' do
      subject = described_class.new('Customer')
      model = Wheelie::Model.new('Customer')

      application_model.add_wui(subject)
      application_model.add_model(model)

      expect(subject.model).to eql(model)
    end
  end

end
