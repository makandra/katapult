require 'katapult/elements/model'

describe Katapult::Model do

  subject { described_class.new('model') }

  describe '#label_attr' do
    it 'returns the model’s first renderable attribute' do
      subject.attr 'first_attr', type: :json
      subject.attr 'second_attr'
      subject.attr 'third_attr'

      expect(subject.label_attr.name).to eql('second_attr')
    end

    it 'raises an error when someone needs/wants/expect a label attribute but there is none' do
      expect{ subject.label_attr }.to raise_error Katapult::Model::MissingLabelAttributeError
    end
  end

end
