# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  restriction :boolean
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Preference, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
