require 'katapult/elements/association'

describe Katapult::Association do

  subject { described_class.new('association') }

  it 'stores its :belongs_to as String' do
    subject = described_class.new('model', belongs_to: :other_model)
    expect(subject.belongs_to).to eq 'other_model'
  end

end
