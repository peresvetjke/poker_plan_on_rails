# frozen_string_literal: true

require 'rails_helper'

feature 'User can manage rounds list.', js: true do
  let!(:round) { create(:round) }

  scenario 'showing a round' do
    visit rounds_path
    click_link(round.title)

    expect(page).to have_selector 'h1', text: round.title
  end

  scenario 'creating a new round' do
    visit rounds_path
    expect(page).to have_selector 'h1', text: 'Rounds'

    click_on 'New round'
    fill_in 'Title', with: 'My first round'

    expect(page).to have_selector 'h1', text: 'Rounds'
    click_on 'Create round'

    expect(page).to have_selector 'h1', text: 'Rounds'
    expect(page).to have_content 'My first round'
  end

  scenario 'updating a round' do
    visit rounds_path
    expect(page).to have_selector 'h1', text: 'Rounds'

    click_on 'Edit', match: :first
    fill_in 'Title', with: 'Updated round'

    expect(page).to have_selector 'h1', text: 'Rounds'
    click_on 'Update round'

    expect(page).to have_selector 'h1', text: 'Rounds'
    expect(page).to have_content 'Updated round'
  end

  scenario 'destroying round' do
    visit rounds_path
    expect(page).to have_content round.title

    click_on 'Delete', match: :first
    expect(page).not_to have_content round.title
  end
end
