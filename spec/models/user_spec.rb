# frozen_string_literal: true

RSpec.describe User do
  subject { build(:user) }

  let!(:other_user) { create(:user, email: 'other_user@example.com', username: 'other_user') }

  describe 'validations' do
    describe '#email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    describe '#username' do
      it { is_expected.to validate_presence_of(:username) }

      describe 'uniqueness' do
        subject { build(:user, username: other_user.username) }

        it { is_expected.to be_valid }
      end
    end
  end

  # describe '#join' do
  #   subject(:join) { user.join(round.id) }

  #   it { expect { join }.to change { round.users.count }.from(0).to(1) }

  #   it { expect { join }.to change { round.users.first }.from(nil).to(user) }

  #   context 'when already joined' do
  #     before { join }

  #     it { expect { join }.not_to(change { round.users.count }) }
  #   end
  # end

  # describe '#leave' do
  #   subject(:leave) { user.leave(round.id) }

  #   before { user.join(round.id) }

  #   it { expect { leave }.to change { round.users.count }.from(1).to(0) }

  #   it { expect { leave }.to change { round.users.first }.from(user).to(nil) }

  #   context 'when already left' do
  #     before { leave }

  #     it { expect { leave }.not_to(change { round.users.count }) }
  #   end
  # end

  # describe '.with_estimation_of_task' do
  #   subject { described_class.with_estimation_of_task(task.id) }

  #   let!(:task) { create(:task) }
  #   let!(:round) { task.round }
  #   let!(:mike) { create(:user) }
  #   let!(:john) { create(:user) }

  #   before do
  #     mike.join(round.id)
  #     john.join(round.id)
  #   end

  #   it { is_expected.to be_empty }

  #   context 'with estimations' do
  #     before { create(:estimation, task:, user: john, value: 3) }

  #     it { is_expected.to contain_exactly(john) }
  #   end
  # end
end
