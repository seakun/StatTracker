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
  
  def leaders
	redirect 
  end
end
