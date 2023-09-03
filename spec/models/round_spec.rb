# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Round do
  subject { round }

  let(:round) { build(:round) }

  it { is_expected.to be_valid }

  context 'when title is blank' do
    let(:round) { build(:round, title: nil) }

    it { is_expected.not_to be_valid }
  end

  context 'when title is not unique' do
    before { create(:round, title: round.title) }

    it { is_expected.not_to be_valid }
  end
end
