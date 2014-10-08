require 'spec_helper'
require 'wheelie/attribute'

describe Wheelie::Attribute do

  it 'is of type :string by default' do
    expect(described_class.new('name').type).to eql(:string)
    expect(described_class.new('address').type).to eql(:string)
  end

  it 'requires a default for :flag attributes' do
    expect do
      described_class.new('attr', type: :flag)
    end.to raise_error(Wheelie::Attribute::MissingOptionError,
      "The :flag attribute 'attr' requires a default (true or false).")
  end

  describe '#flag?' do
    it 'returns whether it is of type :flag' do
      expect(described_class.new('attr', type: :flag).flag?).to be true
      expect(described_class.new('attr', type: :string).flag?).to be false
    end
  end

  describe 'available types' do
    it 'raises an error if the specified type is not supported' do
      expect do
        described_class.new('attr', type: :undefined)
      end.to raise_error(Wheelie::Attribute::UnknownTypeError,
        "Attribute type :undefined is not supported. Use one of #{Wheelie::Attribute::TYPES.inspect}."
      )
    end
  end

  describe 'email attributes' do
    it 'recognizes email attributes' do
      expect(described_class.new('email').type).to eql(:email)
      expect(described_class.new('customer_email').type).to eql(:email)
      expect(described_class.new('name').type).to_not eql(:email)
    end

    it 'does not overwrite a given type' do
      expect(described_class.new('email', type: :url).type).to eql(:url)
      expect(described_class.new('email_updated_at', type: :datetime).type).to eql(:datetime)
    end
  end

end
