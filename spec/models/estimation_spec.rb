# frozen_string_literal: true

RSpec.describe Estimation do
  describe 'validations' do
    describe '#value' do
      it { is_expected.to validate_presence_of(:value) }
      it { is_expected.to validate_numericality_of(:value).only_integer.is_greater_than(0) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('User') }
    it { is_expected.to belong_to(:task).class_name('Task') }
  end
end
