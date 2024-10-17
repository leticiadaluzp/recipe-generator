<<<<<<< HEAD
=======
# frozen_string_literal: true

#
>>>>>>> main
# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
<<<<<<< HEAD
#  name        :string
#  description :text
#  restriction :boolean
#  user_id     :bigint
=======
#  name        :string           not null
#  description :text             not null
#  restriction :boolean          default(FALSE), not null
#  user_id     :bigint           not null
>>>>>>> main
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
require 'rails_helper'

<<<<<<< HEAD
RSpec.describe Preference, type: :model do
=======
RSpec.describe Preference do
>>>>>>> main
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
