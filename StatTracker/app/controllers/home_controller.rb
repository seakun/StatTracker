class HomeController < ApplicationController
autocomplete :player, :last_name, :display_value => :name

  def index
  end

  def search
    @query = params[:query]
    @players = Player.search(@query)
    @players = Player.search(@query)
    @teams = Team.search(@query)
    @total_hits = @players.size + @teams.size
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
  
  def years
	@comp = params[:comp]
	@players = params[:players]
	@player = []
	@player_ids = []
	@players.each { |p|
		first_name, last_name = p.split(" ")
		@player.push(Player.find(:all, :select => [:id], :conditions => ['first_name = ? AND last_name = ?', first_name, last_name]))
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
	
	render :partial => 'years'
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
	end
	
  end
  
  def compare
  end
  
end
