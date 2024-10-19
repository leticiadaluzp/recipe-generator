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
FactoryBot.define do
  factory :recipe do
    name { "MyString" }
    description { "MyText" }
    ingredients { "MyText" }
  end
end
