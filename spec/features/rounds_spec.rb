# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage rounds list.', js: true do
  let!(:round) { create(:round, :with_tasks) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'index' do
    before do
      sign_in user
      visit rounds_path
    end

    it 'displays all rounds', aggregate_failures: true do
      expect(page).to have_text(round.title)
    end

    it 'allows to go to round' do
      click_link(round.title)
      expect(page).to have_text(round.tasks.first.title)
    end
  end

  describe 'show' do
    it 'shows tasks' do
      sign_in user
      visit round_path(round)
      expect(page).to have_text(round.tasks.first.title)
    end
  end

  describe 'create' do
    it 'saves round', aggregate_failures: true do
      sign_in user
      visit rounds_path
      click_on 'New round'
      fill_in 'round_title', with: 'My first round'
      click_on 'Save'
      expect(page).to have_content 'My first round'
      visit rounds_path
      expect(page).to have_content 'My first round'
    end

    it 'streams new round to other users' do # rubocop:disable RSpec/ExampleLength
      using_session 'other_user' do
        sign_in other_user
        visit rounds_path
        sleep 0.5
      end
      using_session 'user' do
        sign_in user
        visit rounds_path
        click_on 'New round'
        fill_in 'round_title', with: 'My first round'
        click_on 'Save'
      end
      using_session 'other_user' do
        expect(page).to have_content 'My first round'
      end
    end
  end

  describe 'update' do
    it 'allows to update round' do
      sign_in user
      visit rounds_path
      click_on 'Edit', match: :first
      fill_in 'round_title', with: 'Updated round'
      click_on 'Save'
      expect(page).to have_content 'Updated round'
    end

    it 'streams updates to other users' do # rubocop:disable RSpec/ExampleLength
      using_session 'other_user' do
        sign_in other_user
        visit rounds_path
        sleep 0.5
      end
      using_session 'user' do
        sign_in user
        visit rounds_path
        click_on 'Edit', match: :first
        fill_in 'round_title', with: 'Updated round'
        click_on 'Save'
      end
      using_session 'other_user' do
        expect(page).to have_content 'Updated round'
      end
    end
  end

  describe 'destroy' do
    it 'allows do destroy round' do
      sign_in user
      visit rounds_path
      click_on 'Delete', match: :first
      expect(page).not_to have_content(round.title)
    end

    it 'streams updates to other users' do # rubocop:disable RSpec/ExampleLength
      using_session 'other_user' do
        sign_in other_user
        visit rounds_path
        sleep 0.5
      end
      using_session 'user' do
        sign_in user
        visit rounds_path
        click_on 'Delete', match: :first
      end
      using_session 'other_user' do
        expect(page).not_to have_content(round.title)
      end
    end
  end
end
