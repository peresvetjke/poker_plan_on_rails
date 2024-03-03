# frozen_string_literal: true

RSpec.describe Tasks::Start do
  subject(:service_call) { described_class.new(task:).call }

  let(:task) { create(:task, state:) }
  let(:round) { task.round }

  context 'when idle' do
    let(:state) { :idle }

    it 'starts task' do
      expect { service_call }.to change { task.reload.state }.from('idle').to('ongoing')
    end

    describe 'broadcasts update' do
      let(:user) { create(:round_user, round: task.round).user }

      it 'initiates estimation panels for all users', aggregate_failures: true do
        estimation_panel = instance_double(Broadcasts::EstimationPanel)
        allow(Broadcasts::EstimationPanel).to receive(:new).with(round:, user:).and_return(estimation_panel)
        allow(estimation_panel).to receive(:update)

        service_call

        expect(estimation_panel).to have_received(:update).with(current_task: task, current_value: nil)
      end
    end
  end

  context 'when ongoing' do
    let(:state) { :ongoing }

    it 'stops task' do
      expect { service_call }.to change { task.reload.state }.from('ongoing').to('idle')
    end

    describe 'broadcasts update' do
      let(:user) { create(:round_user, round:).user }

      it 'hides estimation panels', aggregate_failures: true do
        estimation_panel = instance_double(Broadcasts::EstimationPanel)
        allow(Broadcasts::EstimationPanel).to receive(:new).with(round:, user:).and_return(estimation_panel)
        allow(estimation_panel).to receive(:hide)

        service_call

        expect(estimation_panel).to have_received(:hide)
      end
    end

    context 'with previous estimations' do
      before do
        round_user = create(:round_user, round: task.round)
        user = round_user.user
        create(:round_user, round: task.round)
        create(:estimation, task:, user:)
      end

      it 'destroys previous estimations' do
        expect { service_call }.to change { task.estimations.count }.from(1).to(0)
      end
    end
  end

  context 'when finished' do
    let(:state) { :finished }

    it 'does not change task state' do
      expect { service_call }.not_to(change { task.reload.state })
    end
  end
end
