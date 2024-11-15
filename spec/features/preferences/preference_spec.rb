# frozen_string_literal: true

# # frozen_string_literal: true

# require 'rails_helper'

# describe 'Preferences' do
#   describe 'when logged in' do
#     let(:user) { create(:user) }
#     let!(:preference) { create(:preference, user_id: user.id) }

#     before { sign_in user }

#     describe 'pagination' do
#       let!(:preferences) { create_list(:preference, 29, user_id: user.id) }

#       it 'show only 20 preferences' do
#         visit preferences_path
#         # 20 preferences + 1 row with headers
#         expect(page).to have_css('tr', count: 21)
#       end

#       it 'shows the remaining preferences in the next page' do
#         visit preferences_path(page: 2)
#         # 10 preferences + 1 row with headers
#         expect(page).to have_css('tr', count: 11)
#       end
#     end
#   end
# end
