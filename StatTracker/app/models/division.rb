class Division < ActiveRecord::Base
    attr_accessible :division_name, :league_id
	
	has_many :teams
	belongs_to :league
	
end
