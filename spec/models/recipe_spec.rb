# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text             not null
#  ingredients :text             not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Recipe do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:ingredients) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
