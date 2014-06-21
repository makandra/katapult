require 'rails_helper'

describe <%= model.name :class %> do
<% attrs_with_default.select(&:flag?).each do |attr| -%>
  it { is_expected.to<%= '_not' if attr.default == false %> be_<%= attr.name %> }
<% end -%>
<% attrs_with_default.reject(&:flag?).each do |attr| -%>

  describe '#<%= attr.name %>' do
    it 'has a default' do
      expect( subject.<%= attr.name %> ).to eql(<%= attr.default.inspect %>)
    end
  end
<% end -%>

end
