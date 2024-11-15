# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show preference', :js do
  let(:user) { create(:user) }
  let!(:preference) { create(:preference, name: 'MyString', description: 'MyText', restriction: false, user_id: user.id) }
 
  before do
    sign_in user
    visit preferences_path
    show_first_preference
  end

  describe '#show' do
    context 'when clicking on some preference' do
      it 'show the data of the requested preference' do
        within '#panel' do
          expect(page).to have_content('Name')
          expect(page).to have_content('Description')
          expect(page).to have_content('Restriction')
        end
      end

      it 'the data it\'s not editable' do
        expect(page).to have_field('preference[name]', disabled: true)
        expect(page).to have_field('preference[description]', disabled: true)
        expect(page).to have_field('preference[restriction]', disabled: true)
      end
    end
  end

  def show_first_preference
    within all('tbody tr').first do
      click_on 'Show'
    end
  end
end
