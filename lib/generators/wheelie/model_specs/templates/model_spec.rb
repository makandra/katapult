require 'rails_helper'

describe <%= model.name :class %> do
<% attrs_with_default.select(&:flag?).each do |attr| -%>
  it { is_expected.to<%= '_not' if attr.default == false %> be_<%= attr.name %> }
<% end -%>
<% model.attrs.each do |attr| -%>

  describe '#<%= attr.name %>' do
<% if attr.assignable_values.present? -%>
    it { is_expected.to allow_value(<%= assignable_value_for(attr).inspect %>).for(:<%= attr.name %>) }
    it { is_expected.to_not allow_value(<%= unassignable_value_for(attr).inspect %>).for(:<%= attr.name %>) }
<% if attr.default.present? -%>

    it 'has a default' do
      expect( subject.<%= attr.name %> ).to eql(<%= attr.default.inspect %>)
    end
<% end -%>
<% end -%>
  end
<% end -%>

end
