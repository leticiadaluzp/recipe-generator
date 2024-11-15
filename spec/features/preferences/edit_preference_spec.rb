# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit user' do
  let(:user) { create(:user) }
  let!(:preference) { create(:preference, name: 'MyString', description: 'MyText', restriction: false, user_id: user.id) }

  before do
    sign_in user
    visit preferences_path
  end

  describe '#update' do
    context 'with valid attributes' do
      it 'updates the requested preference' do
        edit_first_preference('Test Name')
        expect(page).to have_content('views.preferences.update_success')
        expect(page).to have_content('Test Name')
        expect(page).to have_content('Test Description')
        #Should I include some expect related to the restriction?
      end
    end

    context 'with invalid attributes' do
      it 'renders the edit template with error messages' do
        edit_first_preference('')
        expect(page).to have_content(I18n.t('errors.messages.blank'))
      end
    end
  end

  # def edit_first_preference(other_name)
  #   within all('tbody tr').first do
  #     click_on 'Edit'
  #   end
  #   fill_in 'Name', with: other_name
  #   fill_in 'Description', with: 'Test Description'
  #   click_on 'Update Preference'
  # end
end
