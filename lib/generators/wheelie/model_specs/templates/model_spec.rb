require 'rails_helper'

describe <%= model.name :class %> do
<% specable_attrs.each do |attr| -%>

  describe '#<%= attr.name %>' do
  <%- if attr.assignable_values.present? -%>
    it { is_expected.to allow_value(<%= assignable_value_for(attr).inspect %>).for(:<%= attr.name %>) }
    it { is_expected.to_not allow_value(<%= unassignable_value_for(attr).inspect %>).for(:<%= attr.name %>) }
  <%- end -%>
  <%- unless attr.default.nil? -%>

    it 'has a default' do
      expect( subject.<%= attr.name %> ).to eql(<%= attr.default.inspect %>)
    end
  <%- end -%>
  end
<% end -%>

end
