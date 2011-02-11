class League < ActiveRecord::Base
    attr_accessible :name, :active
	
	has_many :divisions
	
end
