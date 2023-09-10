# frozen_string_literal: true

RSpec.describe Estimation do
  subject { estimation }

  let(:estimation) { build(:estimation) }

  it { is_expected.to be_valid }

  describe 'value' do
    context 'when value is blank' do
      let(:estimation) { build(:estimation, value: nil) }

      it { is_expected.not_to be_valid }
    end

    context 'when value is not integer' do
      let(:estimation) { build(:estimation, value: 1.5) }

      it { is_expected.not_to be_valid }
    end

    context 'when value is not positive' do
      let(:estimation) { build(:estimation, value: -1) }

      it { is_expected.not_to be_valid }
    end
  end
end
