require 'spec_helper'

describe Wheelie::Attribute do

  it 'is of type :string by default' do
    expect(described_class.new('name').type).to eql(:string)
    expect(described_class.new('address').type).to eql(:string)
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
