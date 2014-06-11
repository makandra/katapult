require 'spec_helper'

describe Wheelie::Names do

  let(:model) { Wheelie::Model.new('test_model') }
  subject { described_class.new(model) }

  describe '#symbol' do
    it 'returns its model’s name as symbol' do
      model.name = 'customer'
      expect(subject.symbol).to eql(':customer')
    end
  end

end
