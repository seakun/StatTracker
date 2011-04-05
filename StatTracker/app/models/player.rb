class Player < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :name, :nickname, :birth_year, :birth_month, :birth_day, :birth_country, :birth_state, :birth_city, :death_year, :death_month, :death_day, :death_country, :death_state, :death_city, :weight, :height, :bats, :throws, :debut, :final_game, :college, :hof

    has_many :batting_stats
	has_many :batting_post_stats
	has_many :pitching_stats
	has_many :pitching_post_stats
	has_many :fielding_stats
	has_many :fielding_post_stats
	
	def age(year)
		birthday = DateTime.new(y=birth_year, m = birth_month, d = birth_day)
		season_start = DateTime.new(y=year, m = 7, d = 1, h=0, m=0, s=0)
		(season_start-birthday).to_i/365
	end
	
	def heightFeet
		(height/12).to_s+"\' "+(height%12).to_s+"\""
	end

	def birthPlace
	if birth_state.nil?
	return birth_city+ ", "+birth_country
	elsif birth_city.nil? && birth_state.nil?
	return birth_country
	elsif !birth_city.nil? && !birth_state.nil? && !birth_country.nil?
	return birth_city+ ", "+birth_state+ ", "+birth_country
	end
	end

  # search for all the players in the system by either first or last name
  def self.search(search)
    search_condition = "%" + search.downcase + "%"
    find(:all, :conditions => ["lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(first_name) || ' ' || lower(last_name) LIKE ?", search_condition, search_condition, search_condition])
  end
  
  def auto_search
	if !debut.nil?
		if final_game.nil?
			name + ", " + debut.year.to_s + " - "
		else 
			name + ", " + debut.year.to_s + " - " + final_game.year.to_s
		end
	end
  end

  def filter
    @players = Player.paginate :page => params[:page], :order => 'last_name',
         :conditions=>["last_name LIKE ? or last_name LIKE ? or last_name LIKE ? last_name like ?",
         'A%', 'B%', 'C%', 'D%']
  end
end
