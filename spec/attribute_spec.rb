require 'spec_helper'
require 'katapult/attribute'

describe Katapult::Attribute do

  it 'is of type :string by default' do
    expect(described_class.new('name').type).to eql(:string)
    expect(described_class.new('address').type).to eql(:string)
  end

  it 'requires a default for :flag attributes' do
    expect do
      described_class.new('attr', type: :flag)
    end.to raise_error(Katapult::Attribute::MissingOptionError,
      "The :flag attribute 'attr' requires a default (true or false).")
  end

  describe '#flag?' do
    it 'returns whether it is of type :flag' do
      expect(described_class.new('attr', type: :flag, default: false).flag?).to be true
      expect(described_class.new('attr', type: :string).flag?).to be false
    end
  end

  describe 'available types' do
    it 'raises an error if the specified type is not supported' do
      expect do
        described_class.new('attr', type: :undefined)
      end.to raise_error(Katapult::Attribute::UnknownTypeError,
        "Attribute type :undefined is not supported. Use one of #{Katapult::Attribute::TYPES.inspect}."
      )
    end
  end

  describe 'password attributes' do
    it 'recognizes password attributes' do
      expect(described_class.new('password').type).to eql(:password)
      expect(described_class.new('encrypted_password').type).to eql(:password)
      expect(described_class.new('name').type).to_not eql(:password)
    end

    it 'does not overwrite a given type' do
      expect(described_class.new('password', type: :string).type).to eql(:string)
      expect(described_class.new('password_updated_at', type: :datetime).type).to eql(:datetime)
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
