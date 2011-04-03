class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
	  t.string :name
      t.string :nickname
      t.integer :birth_year
      t.integer :birth_month
      t.integer :birth_day
      t.string :birth_country
      t.string :birth_state
      t.string :birth_city
      t.integer :death_year
      t.integer :death_month
      t.integer :death_day
      t.string :death_country
      t.string :death_state
      t.string :death_city
      t.integer :weight
      t.integer :height
      t.string :bats
      t.string :throws
      t.datetime :debut
      t.datetime :final_game
      t.string :college
      t.boolean :hof
	  t.timestamps
    end

  def self.down
    drop_table :players
  end

end

end