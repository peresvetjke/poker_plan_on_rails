# frozen_string_literal: true

RSpec.describe Tasks::Start do
  subject(:service_call) { described_class.new(task:).call }

  let(:task) { create(:task, state:) }

  context 'when idle' do
    let(:state) { :idle }

    it 'starts task' do
      expect { service_call }.to change { task.reload.state }.from('idle').to('ongoing')
    end

    describe 'broadcasts update' do
      let(:round_users) { create_list(:round_user, 2, round: task.round) }
      let(:user1) { round_users.first.user }
      let(:user2) { round_users.last.user }

      it 'initiates estimation panels for all users', aggregate_failures: true do
        estimation_panel1 = instance_double(Views::UserEstimationPanel)
        estimation_panel2 = instance_double(Views::UserEstimationPanel)
        allow(Views::UserEstimationPanel).to receive(:new).with(round_id: task.round_id, task_id: task.id, user_id: user1.id).and_return(estimation_panel1)
        allow(Views::UserEstimationPanel).to receive(:new).with(round_id: task.round_id, task_id: task.id, user_id: user2.id).and_return(estimation_panel2)
        expect(estimation_panel1).to receive(:show)
        expect(estimation_panel2).to receive(:show)
        service_call
      end
    end
  end

  context 'when ongoing' do
    let(:state) { :ongoing }

    it 'stops task' do
      expect { service_call }.to change { task.reload.state }.from('ongoing').to('idle')
    end

    describe 'broadcasts update' do
      let(:round_users) { create_list(:round_user, 2, round: task.round) }
      let(:user1) { round_users.first.user }
      let(:user2) { round_users.last.user }

      it 'initiates estimation panels for all users', aggregate_failures: true do
        estimation_panel1 = instance_double(Views::UserEstimationPanel)
        estimation_panel2 = instance_double(Views::UserEstimationPanel)
        allow(Views::UserEstimationPanel).to receive(:new).with(round_id: task.round_id, task_id: task.id, user_id: user1.id).and_return(estimation_panel1)
        allow(Views::UserEstimationPanel).to receive(:new).with(round_id: task.round_id, task_id: task.id, user_id: user2.id).and_return(estimation_panel2)
        expect(estimation_panel1).to receive(:hide)
        expect(estimation_panel2).to receive(:hide)
        service_call
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
      expect { service_call }.not_to change { task.reload.state }
    end
  end
end
