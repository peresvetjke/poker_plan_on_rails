# frozen_string_literal: true

RSpec.describe Round do
  subject { build(:round) }

  describe 'validations' do
    describe '#title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_uniqueness_of(:title) }
    end
  end
end
