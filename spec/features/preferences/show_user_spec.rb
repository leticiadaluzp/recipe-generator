# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'Show user', :js do
#   let(:admin_user) { create(:user, email: 'admin@test.com', password: '123123123') }
#   let(:user) { create(:user, email: 'member@test.com', first_name: 'John', last_name: 'Doe') }

#   before do
#     sign_in admin_user
#     visit users_path
#     show_first_user
#   end

#   describe '#show' do
#     context 'when clicking on some user' do
#       it 'show the data the requested user' do
#         within '#panel' do
#           expect(page).to have_content('Name')
#           expect(page).to have_content('Last Name')
#           expect(page).to have_content('Email')
#         end
#       end

#       it 'the data it\'s not editable' do
#         expect(page).to have_field('user[first_name]', disabled: true)
#         expect(page).to have_field('user[last_name]', disabled: true)
#         expect(page).to have_field('user[email]', disabled: true)
#       end
#     end
#   end

#   def show_first_user
#     within all('tbody tr').first do
#       click_on 'Show'
#     end
#   end
# end
