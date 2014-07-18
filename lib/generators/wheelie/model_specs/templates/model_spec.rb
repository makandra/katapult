require 'rails_helper'

describe <%= model.name :class %> do

  describe '#to_s' do
  <%- if model.label_attr -%>
    it 'returns the #<%= model.label_attr.name %> attribute' do
      subject.<%= model.label_attr.name %> = <%= model.label_attr.test_value.inspect %>
      expect(subject.to_s).to eql(<%= model.label_attr.test_value.inspect %>)
    end
  <%- else -%>
    it 'returns its class name with its id' do
      subject.id = 17
      expect(subject.to_s).to eql("<%= model.name %>#17")
    end
  <%- end -%>
  end
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
