class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :boards
      t.integer :player_count
      t.integer :player_turn

      t.timestamps null: false
    end
  end
end
