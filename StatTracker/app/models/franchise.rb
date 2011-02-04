class Franchise < ActiveRecord::Base
    attr_accessible :franchise_name, :active
	
	has_many :teams
	
end
