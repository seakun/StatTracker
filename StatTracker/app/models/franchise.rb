class Franchise < ActiveRecord::Base
    attr_accessible :name, :active
	
	has_many :teams
	scope :active, where('active = ?', true)

  def show_active
    return "not active" if !active
    "active"
  end

end
