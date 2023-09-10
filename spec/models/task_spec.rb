# frozen_string_literal: true

RSpec.describe Task do
  subject { task }

  let!(:john) { create(:user) }
  let!(:mike) { create(:user) }
  let!(:task) { create(:task, state) }
  let!(:state) { :idle }

  describe 'validations' do
    let!(:task) { build(:task) }

    it { is_expected.to be_valid }

    context 'when title is blank' do
      before { task.title = nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#start!' do
    subject(:start) { task.start! }

    context 'when idle' do
      let!(:other_task) { create(:task, :ongoing, round_id: task.round.id) }

      it { expect { start }.to change(task, :state).from('idle').to('ongoing') }

      it { expect { start }.to change { other_task.reload.state }.from('ongoing').to('idle') }
    end

    context 'when ongoing' do
      let(:task) { build(:task, :ongoing) }

      it { expect { start }.not_to change(task, :state) }
    end

    context 'when finished' do
      let(:task) { build(:task, :finished) }

      it { expect { start }.not_to change(task, :state) }
    end
  end

  describe '#stop!' do
    subject(:stop) { task.stop! }

    context 'when ongoing' do
      let(:task) { build(:task, :ongoing) }

      it { expect { stop }.to change(task, :state).from('ongoing').to('idle') }
    end

    context 'when idle' do
      let(:task) { build(:task, :idle) }

      it { expect { stop }.not_to change(task, :state) }
    end

    context 'when finished' do
      let(:task) { build(:task, :finished) }

      it { expect { stop }.not_to change(task, :state) }
    end
  end

  describe '#estimate' do
    subject(:estimate) { task.estimate(john, value) }

    let(:state) { :ongoing }
    let(:value) { 3 }

    before do
      john.join(task.round_id)
      mike.join(task.round_id)
    end

    context 'when task is ongoing' do
      it { expect { estimate }.to change(Estimation, :count).from(0).to(1) }

      it { expect { estimate }.not_to change(task, :state) }

      # rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
      context 'with existing estimation' do
        before { create(:estimation, task: task, user: john, value: old_value) }

        context 'with same value' do
          let(:old_value) { value }

          it { expect { estimate }.to change(Estimation, :count).by(-1) }
        end

        context 'with different value' do
          let(:old_value) { value + 1 }

          it { expect { estimate }.not_to change(Estimation, :count) }

          it { expect { estimate }.to change { Estimation.first.reload.value }.from(old_value).to(value) }
        end
      end

      context 'when last user estimation' do
        before { create(:estimation, task: task, user: mike, value: 1) }

        it { expect { estimate }.to change(task, :state).from('ongoing').to('finished') }
      end
      # rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
    end

    context 'when task is idle' do
      let(:state) { :idle }

      it { expect { estimate }.not_to change(Estimation, :count) }
    end

    context 'when task is finished' do
      let(:state) { :finished }

      it { expect { estimate }.not_to change(Estimation, :count) }
    end
  end
end
