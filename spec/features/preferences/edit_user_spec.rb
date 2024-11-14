# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'Edit user' do
#   let!(:admin_user) { create(:user, email: 'admin@test.com', password: '123123123') }
#   let!(:user) { create(:user, email: 'member@test.com', first_name: 'John', last_name: 'Doe') }

#   before do
#     sign_in admin_user
#     visit users_path
#   end

#   describe '#update' do
#     context 'with valid attributes' do
#       it 'updates the requested user' do
#         edit_first_user('new@test.com')
#         expect(page).to have_content('User successfully updated.')
#         expect(page).to have_content('new@test.com')
#         expect(page).to have_content('Test Name')
#         expect(page).to have_content('Test Last Name')
#       end
#     end

#     context 'with invalid attributes' do
#       it 'renders the edit template with error messages' do
#         edit_first_user(admin_user.email)
#         expect(page).to have_text('Email has already been taken', wait: 5)
#       end
#     end
#   end

#   def edit_first_user(email)
#     within all('tbody tr').first do
#       click_on 'Edit'
#     end
#     fill_in 'Email', with: email
#     fill_in 'Name', with: 'Test Name'
#     fill_in 'Last Name', with: 'Test Last Name'
#     click_on 'Update User'
#   end
# end
