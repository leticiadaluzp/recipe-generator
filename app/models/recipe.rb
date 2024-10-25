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
class Recipe < ApplicationRecord
  belongs_to :user

  validates :name, :description, :ingredients, presence: true
end
