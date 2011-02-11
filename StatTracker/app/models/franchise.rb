class Franchise < ActiveRecord::Base
    attr_accessible :name, :active
	
	has_many :teams
	
end
