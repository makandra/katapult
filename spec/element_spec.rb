require 'spec_helper'
require 'katapult/element'

describe Katapult::Element do
  subject { described_class.new('element') }

  describe '#name' do
    it 'raises an error when passed an unknown formatting kind' do
      expect do
        subject.name(:foobar)
      end.to raise_error(Katapult::Element::UnknownFormattingError,
        'Unknown name formatting: :foobar')
    end
  end

end
