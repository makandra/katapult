require 'spec_helper'
require 'wheelie/model'

describe Wheelie::Model do

  subject { described_class.new('model') }

  describe '#label_attr=' do
    it 'fetches and sets the real attribute object' do
      subject.attr('some_attr')
      some_attr = subject.attrs.last

      subject.label_attr = :some_attr
      expect(subject.label_attr).to eql(some_attr)
    end

    it 'raises an error if the specified attribute does not exist' do
      expect do
        subject.label_attr = :unknown_attr
      end.to raise_error(Wheelie::Model::UnknownAttribute)
    end
  end

end
