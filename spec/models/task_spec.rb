# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  subject { task }

  let(:task) { build(:task) }

  it { is_expected.to be_valid }

  context 'when title is blank' do
    let(:task) { build(:task, title: nil) }

    it { is_expected.not_to be_valid }
  end
end
