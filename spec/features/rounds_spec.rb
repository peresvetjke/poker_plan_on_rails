# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage rounds list.', :js do
  let!(:round) { create(:round, :with_tasks) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'index' do
    before do
      sign_in user
      visit rounds_path
    end

    it 'displays all rounds', :aggregate_failures do
      expect(page).to have_text(round.title)
    end

    it 'allows to go to round' do
      click_link_or_button round.title
      expect(page).to have_text(round.tasks.first.title)
    end
  end

  describe 'show' do
    it 'shows tasks', :aggregate_failures do
      sign_in user
      visit round_path(round)
      round.tasks.each do |task|
        expect(page).to have_text(task.title)
      end
    end
  end

  describe 'create' do
    it 'saves round', :aggregate_failures do
      sign_in user
      visit rounds_path
      click_on 'New round'
      fill_in 'round_title', with: 'My first round'
      click_on 'Save'
      expect(page).to have_content 'My first round'
      visit rounds_path
      expect(page).to have_content 'My first round'
    end

    it 'streams new round to other users' do
      sign_in other_user
      visit rounds_path
      sleep 0.5

      using_session 'user' do
        sign_in user
        visit rounds_path
        click_on 'New round'
        fill_in 'round_title', with: 'My first round'
        click_on 'Save'
      end

      expect(page).to have_content 'My first round'
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

    it 'streams updates to other users' do
      sign_in other_user
      visit rounds_path
      sleep 0.5

      using_session 'user' do
        sign_in user
        visit rounds_path
        click_on 'Edit', match: :first
        fill_in 'round_title', with: 'Updated round'
        click_on 'Save'
      end

      expect(page).to have_content 'Updated round'
    end
  end

  describe 'destroy' do
    it 'allows do destroy round' do
      sign_in user
      visit rounds_path
      click_on 'Delete', match: :first
      expect(page).to have_no_content(round.title)
    end

    it 'streams updates to other users' do
      sign_in other_user
      visit rounds_path
      sleep 0.5

      using_session 'user' do
        sign_in user
        visit rounds_path
        click_on 'Delete', match: :first
      end

      expect(page).to have_no_content(round.title)
    end
  end
end
