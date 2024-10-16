# frozen_string_literal: true

class UpdatePreferences < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_column :preferences, :restriction, :boolean, default: false, null: false ## rubocop:disable Rails/ReversibleMigration
      change_column_null :preferences, :user_id, false
      change_column_null :preferences, :name, false
      change_column_null :preferences, :description, false
      add_foreign_key :preferences, :users
    end
  end
end
