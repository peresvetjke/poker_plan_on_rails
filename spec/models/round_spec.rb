# frozen_string_literal: true

RSpec.describe Round do
  let!(:round) { create(:round) }
  let(:user) { create(:user) }

  describe 'validations' do
    subject { round }

    it { is_expected.to be_valid }

    context 'when title is blank' do
      before { round.title = nil }

      it { is_expected.not_to be_valid }
    end

    context 'when title is not unique' do
      let!(:other_round) { create(:round) }

      before { round.title = other_round.title }

      it { is_expected.not_to be_valid }
    end
  end
end
