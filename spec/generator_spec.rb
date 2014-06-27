require 'spec_helper'
require 'wheelie/generator'

describe Wheelie::Generator do

  describe '.new' do
    context 'when passed the --wheelie-model option' do
      it 'should raise a NotImplementedError' do
        Wheelie::Reference.instance.should_receive('model').with('name')

        expect {
          described_class.new ['name'], { wheelie_model: 'model' }
        }.to raise_error(NotImplementedError, /must override/)
      end
    end
  end

end
