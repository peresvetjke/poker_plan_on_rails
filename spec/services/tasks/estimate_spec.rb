# frozen_string_literal: true

RSpec.describe Tasks::Estimate do
  subject(:service_call) { described_class.new(task:, user:).call(value) }

  let(:task) { create(:task, state: state) }
  let(:user) { create(:user) }
  let(:value) { 1 }
  let!(:round_user) { create(:round_user, user: user, round: task.round) }

  context 'when task is ongoing' do
    let(:state) { :ongoing }

    it 'creates estimation' do
      expect { service_call }.to change(Estimation, :count).by(1)
    end

    it 'returns estimation', aggregate_failures: true do
      expect(service_call).to be_an(Estimation)
      expect(service_call.value).to eq(value)
      expect(task.estimations.first.value).to eq(value)
    end

    describe 'broadcast view update' do
      it 'broadcasts update' do
        users_list = instance_double(Views::UsersList)
        allow(Views::UsersList).to receive(:new).and_return(users_list)
        expect(users_list).to receive(:estimation_added)
        service_call
      end

      context 'when destroying estimation' do
        before { create(:estimation, task:, user:, value:) }

        it 'broadcasts update' do
          users_list = instance_double(Views::UsersList)
          allow(Views::UsersList).to receive(:new).and_return(users_list)
          expect(users_list).to receive(:estimation_removed)
          service_call
        end
      end
    end

    describe 'finish task' do
      context 'when last estimation' do
        it 'finishes task' do
          expect { service_call }.to change(task, :state).from('ongoing').to('finished')
        end
      end

      context 'when not last estimation' do
        before { create(:round_user, round: task.round) }

        it 'does not finish task' do
          expect { service_call }.not_to change(task, :state)
        end
      end
    end

    context 'when estimation already exists' do
      context 'with the same value' do
        before { create(:estimation, task:, user:, value: value) }

        it 'destroys estimation', aggregate_failures: true do
          expect { service_call }.to change(Estimation, :count).from(1).to(0)
          expect(service_call).to be_nil
        end
      end

      context 'with other value' do
        before { create(:estimation, task:, user:, value: value + 1) }

        it 'updates estimation', aggregate_failures: true do
          expect { service_call }.not_to change(Estimation, :count)
          expect(service_call).to be_an(Estimation)
          expect(service_call.value).to eq(value)
          expect(task.estimations.first.value).to eq(value)
        end
      end
    end

    context 'when user is not in the round' do
      before { round_user.destroy }

      it 'does not create estimation' do
        expect { service_call }.not_to change(Estimation, :count)
      end
    end
  end

  context 'when task is idle' do
    let(:state) { :idle }

    it 'does not create estimation' do
      expect { service_call }.not_to change(Estimation, :count)
    end
  end

  context 'when task is finished' do
    let(:state) { :finished }

    it 'does not create estimation' do
      expect { service_call }.not_to change(Estimation, :count)
    end
  end
end
