class League < ActiveRecord::Base
    attr_accessible :league_name, :active
	
	has_many :divisions
	
end
