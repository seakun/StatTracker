class HomeController < ApplicationController
autocomplete :player, :name, :display_value => :auto_search, :full => true
autocomplete :franchise, :name, :display_value => :auto_search, :full => true

  def index
  end

  def search
    @query = params[:query]
    @players = Player.search(@query)
    @franchises = Franchise.search(@query)
    @total_hits = @players.size + @franchises.size
    if @total_hits == 1
      if @players.first != nil
        redirect_to @players.first
      end
      if @franchises.first != nil
        redirect_to @franchises.first
      end
    end
  end
  
  def batting_leaders
	stat = params[:stat].downcase.gsub(" ", "_")
	type = params[:type]
	post =  params[:post]
	if post.nil?
		redirect_to '/leaders/' + type + '/batting/' + stat
	else redirect_to '/leaders/' + type + '/batting_post/' + stat
	end
  end
  
  def pitching_leaders
	stat = params[:stat].downcase.gsub(" ", "_")
	type = params[:type]
	post =  params[:post]
	if post.nil?
		redirect_to '/leaders/' + type + '/pitching/' + stat
	else redirect_to '/leaders/' + type + '/pitching_post/' + stat
	end
  end
  def years_players
	@comp = params[:comp]
	@players = params[:players]
	@player = []
	@player_ids = []
	@players.each { |p|
		if p != ""
			first_name, last_name, year, dash = p.split(" ")
			last_name.chomp!(",")
			@player.push(Player.find(:all, :select => [:id], :conditions => ['first_name = ? AND last_name = ?', first_name, last_name]))
		end
	}
	@player.each { |p|
		if p[0].nil?
		else
			id = p[0].id.to_s
			@player_ids.push(id)
		end
	}
	@years_array = []
	@player_ids.each { |p|
		@year = []
		@years = []
		if p[0].nil?
		else
			@year = BattingStat.find(:all, :select => [:team_id], :conditions => ['player_id =?', p])
		end
		@year.each { |y|
			@years.push(y.year)
		}
		@years_array.push(@years)
	}
	@type = params[:type]

	render :partial => 'years_players'
  end
  
  def compare_players
	@years = params[:years]
	@comp = params[:comp]
	@type = params[:type]
	@players = params[:players]
	
	if @type == 'career'
		string = "/" + @players.join('/')
		redirect_to '/compare/career/' + @comp + string
	elsif @type == 'season'
		new = []
		i = 0
		@players.each { |p|
			new.push(p + "." + @years[i])
			i += 1
		}
		string = "/" + new.join("/")
		redirect_to '/compare/season/' + @comp + string
	else 
		new = []
		i = 0
		@players.each { |p|
			new.push(p + "." + @years[i] + ':' + @years[i+1])
			i += 2
		}
		string = '/' + new.join('/')
		redirect_to '/compare/multi/' + @comp + string
	end
	
  end
  
  def compare
  end
  
  def franchise_compare
  end
  
  def years_franchises
	@franchises = params[:franchises]
	@franchise= []
	@franchise_ids = []
	@franchises.each { |f|
		@franchise.push(Franchise.find(:all, :select => [:id], :conditions => ['name = ?', f]))
	}
	@franchise.each { |f|
		if f[0].nil?
		else
			id = f[0].id.to_s
			@franchise_ids.push(id)
		end
	}
	@years_array = []
	@franchise_ids.each { |f|
		@year = []
		@years = []
		if !f[0].nil?
			@year = Team.find(:all, :select => [:year], :conditions => ['franchise_id =?', f])
		end
		@year.each { |y|
			@years.push(y.year)
		}
		@years_array.push(@years)
	}
	@type = params[:type]
	puts @years_array
	puts @type
	render :partial => 'years_franchises'
  end
  
  def compare_franchises
	@years = params[:years]
	@type = params[:type]
	@franchises = params[:franchises]
	
	if @type == 'career'
		string = @franchises.join('/')
		redirect_to '/franchise_compare/career/' + string
	elsif @type == 'season'
		new = []
		i = 0
		@franchises.each { |p|
			new.push(p + "." + @years[i])
			i += 1
		}
		string = new.join("/")
		redirect_to '/franchise_compare/season/' + string
	else 
		new = []
		i = 0
		@franchises.each { |p|
			new.push(p + "." + @years[i] + ':' + @years[i+1])
			i += 2
		}
		string = new.join('/')
		redirect_to '/franchise_compare/multi/' + string
	end
	
  end
  
end
