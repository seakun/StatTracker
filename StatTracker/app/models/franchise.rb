class Franchise < ActiveRecord::Base
    attr_accessible :name, :active
	
	has_many :teams
	scope :active, where('active = ?', true)

  def self.search(search)
    search_condition = "%" + search.downcase + "%"
    find(:all, :conditions => ['lower(name) LIKE ?', search_condition])
  end

end
