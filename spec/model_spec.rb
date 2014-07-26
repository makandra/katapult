require 'spec_helper'
require 'wheelie/model'
require 'wheelie/attribute'

describe Wheelie::Model do

  subject { described_class.new('model') }

  describe '#label_attr=' do
    it 'raises an error if the specified attribute does not exist' do
      expect do
        subject.label_attr = :unknown_attr
      end.to raise_error(Wheelie::Model::UnknownAttributeError)
    end
  end

  describe '#label_attr' do
    it 'returns the label attribute as an attribute object' do
      subject.attr('some_attr')
      subject.label_attr = :some_attr

      expect(subject.label_attr.name).to eql('some_attr')
      expect(subject.label_attr).to be_a(Wheelie::Attribute)
    end

    it 'returns the model’s first attribute if no label attribute is set' do
      subject.attr('first_attr')
      subject.attr('second_attr')
      subject.attr('third_attr')

      expect(subject.label_attr.name).to eql('first_attr')
    end
  end

end
