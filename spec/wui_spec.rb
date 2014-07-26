require 'spec_helper'
require 'wheelie/wui'
require 'wheelie/metamodel'

describe Wheelie::WUI do

  subject { described_class.new 'wui' }

  describe '#path' do
    it 'raises an error if the given action does not exist' do
      expect do
        subject.path(:foobar)
      end.to raise_error(Wheelie::WUI::UnknownActionError,
        "Unknown action 'foobar'"
      )
    end
  end

end
