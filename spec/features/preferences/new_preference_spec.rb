# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preference creation' do
  let(:user) { create(:user) }
  let(:new_preference_data) do
    {
      name: 'MyString',
      description: 'MyText',
      restriction: [true, false].sample
    }
  end

  before { sign_in user }

  def create_preference(data = new_preference_data)
    visit '/preferences'
    click_on 'New Preference'
    fill_in 'Name', with: data[:name]
    fill_in 'Description', with: data[:description]
    data[:restriction] ? check('Restriction') : uncheck('Restriction')
    click_on 'Create Preference'
  end

  context 'with valid data' do
    it 'creates a new preference successfully' do
      create_preference

      expect(page).to have_content(I18n.t('views.preferences.create_success'))
      expect(page).to have_content(new_preference_data[:name])
      expect(page).to have_content(new_preference_data[:description])
    end
  end

  context 'with invalid data' do
    it 'handles missing name' do
      new_preference_data[:name] = ''
      create_preference(new_preference_data)

      expect(page).to have_content(I18n.t('errors.messages.blank'))
    end
  end

  context 'when navigation' do
    it 'returns to preferences index after clicking cancel' do
      visit '/preferences/new'
      click_on 'Cancel'
      expect(page).to have_current_path('/preferences')
    end

    it 'returns the correct path after click on New Preference button' do
      visit '/preferences'
      click_on 'New Preference'
      expect(page).to have_current_path('/preferences/new')
    end
  end
end
