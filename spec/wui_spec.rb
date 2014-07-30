require 'spec_helper'
require 'wheelie/wui'
require 'wheelie/model'
require 'wheelie/metamodel'

describe Wheelie::WUI do

  subject { described_class.new 'wui' }

  let(:metamodel) { Wheelie::Metamodel.new }

  describe '#path' do
    it 'raises an error if the given action does not exist' do
      expect do
        subject.path(:foobar)
      end.to raise_error(Wheelie::WUI::UnknownActionError,
        "Unknown action 'foobar'"
      )
    end
  end

  describe '#model' do
    it 'returns the model object' do
      subject = described_class.new('Customer', model: 'User')
      model = Wheelie::Model.new('User')

      metamodel.add_wui(subject)
      metamodel.add_model(model)

      expect(subject.model).to eql(model)
    end

    it 'detects the model from its own name, if not stated explicitly' do
      subject = described_class.new('Customer')
      model = Wheelie::Model.new('Customer')

      metamodel.add_wui(subject)
      metamodel.add_model(model)

      expect(subject.model).to eql(model)
    end
  end

end
