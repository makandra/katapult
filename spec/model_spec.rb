require 'spec_helper'
require 'katapult/model'
require 'katapult/attribute'

describe Katapult::Model do

  subject { described_class.new('model') }

  describe '#label_attr' do
    it 'returns the model’s first renderable attribute' do
      subject.attr 'first_attr', type: :json
      subject.attr 'second_attr'
      subject.attr 'third_attr'

      expect(subject.label_attr.name).to eql('second_attr')
    end
  end

end
