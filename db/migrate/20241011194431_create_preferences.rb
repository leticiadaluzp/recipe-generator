# frozen_string_literal: true

class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences do |t|
      t.string :name
      t.text :description
      t.boolean :restriction ## rubocop:disable Rails/ThreeStateBooleanColumn
      t.references :user, index: true

      t.timestamps
    end
  end
end
