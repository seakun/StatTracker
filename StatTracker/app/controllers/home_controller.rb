class HomeController < ApplicationController
  def index
  end

  def search
    @query = params[:query]
    @players = Player.search(@query)
    @teams = Team.search(@query)
    @total_hits = @players.size + @teams.size
  end

  def soundex

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
  
end
