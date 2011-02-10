class Player < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :nickname, :birth_year, :birth_month, :birth_day, :birth_country, :birth_state, :birth_city, :death_year, :death_month, :death_day, :death_country, :death_state, :death_city, :weight, :height, :bats, :throws, :debut, :final_game, :college, :hof
end
