# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage users list.', js: true do
  let!(:round) { create(:round, :with_tasks) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'users list' do
    describe 'new user' do
      it 'streams round users', aggregate_failures: true do
        sign_in other_user
        visit round_path(round)
        sleep 0.5

        using_session 'user' do
          sign_in user
          visit round_path(round)
          expect(page).to have_content(other_user.username)
        end

        expect(page).to have_content(user.username)
      end
    end

    describe 'kicking user' do
      let(:round_user) { RoundUser.find_by(user_id: other_user, round_id: round.id) }

      it 'streams round users', aggregate_failures: true do
        sign_in other_user
        visit round_path(round)
        within("#users_list") { expect(page).to have_content(other_user.username) }
        sleep 0.5

        using_session 'user' do
          sign_in user
          visit round_path(round)
          within("#round_user_#{round_user.id}") { click_on 'Delete' }
        end

        within("#users_list") { expect(page).not_to have_content(other_user.username) }
      end
    end
  end
end
