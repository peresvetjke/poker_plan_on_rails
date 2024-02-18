# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage rounds list.', js: true do
  let!(:round) { create(:round, :with_tasks) }

  before { visit rounds_path }

  describe 'index' do
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
      visit round_path(round)
      expect(page).to have_text(round.tasks.first.title)
    end
  end

  describe 'create' do
    it 'saves round' do
      click_on 'New round'
      fill_in 'round_title', with: 'My first round'
      click_on 'Save'
      visit rounds_path
      expect(page).to have_content 'My first round'
    end
  end

  describe 'update' do
    it 'allows to update round' do
      click_on 'Edit', match: :first
      fill_in 'round_title', with: 'Updated round'
      click_on 'Save'
      expect(page).to have_content 'Updated round'
    end
  end

  describe 'destroy' do
    it 'allows do destroy round' do
      click_on 'Delete', match: :first
      expect(page).not_to have_content(round.title)
    end
  end
end
