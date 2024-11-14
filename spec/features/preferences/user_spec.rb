# # frozen_string_literal: true

# require 'rails_helper'

# describe 'Users' do
#   describe 'when logged in' do
#     let!(:user) { create(:user) }

#     before { sign_in user }

#     describe 'pagination' do
#       let!(:users) { create_list(:user, 29) } # 30 users in total counting the Super Admin

#       it 'show only 20 users' do
#         visit users_path
#         # 20 users + 1 row with headers
#         expect(page).to have_css('tr', count: 21)
#       end

#       it 'shows the remaining users in the next page' do
#         visit users_path(page: 2)
#         # 10 users + 1 row with headers
#         expect(page).to have_css('tr', count: 11)
#       end
#     end
#   end
# end
