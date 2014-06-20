require 'spec_helper'

describe Wheelie::Action do

  subject { described_class.new 'action' }

  describe '#post?' do
    it 'returns true when its method is :post' do
      subject.method = :post
      expect(subject.post?).to be true
    end

    it 'returns false when its method is :get' do
      subject.method = :get
      expect(subject.post?).to be false
    end
  end

  describe '#member?' do
    it 'returns true when its scope is :member' do
      subject.scope = :member
      expect(subject.member?).to be true
    end

    it 'returns false when its scope is :collection' do
      subject.scope = :collection
      expect(subject.member?).to be false
    end

    it 'returns false when it is an index action' do
      subject = described_class.new 'index'
      expect(subject.member?).to be false
    end
  end

  describe '#collection?' do
    it 'returns true when it is an index action' do
      subject = described_class.new 'index'
      expect(subject.collection?).to be true
    end
  end

end
