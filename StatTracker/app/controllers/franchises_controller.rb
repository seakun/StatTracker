class FranchisesController < ApplicationController
  def index
    @franchises = Franchise.all
  end

  def show
    @franchise = Franchise.find(params[:id])
    @google_image = GoogleImage.all(@franchise.name+" logo wiki", 0).first
    @teams= Team.find(:all, :conditions => ['franchise_id = ?', params[:id]])
    @teams.reverse!
    if @franchise.active?
    @current_team=@teams.first
    end
    @chart = GoogleVisualr::Table.new
		@chart.add_column('string' , 'Team')
    @chart.add_column('number' , 'Year')
		@chart.add_column('string' , 'League')
		@chart.add_column('number' , 'Wins')
		@chart.add_column('number' , 'Losses')
    @chart.add_column('number' , 'Rank')
    @chart.add_rows(@teams.size)
    @teams.each { |b|
			i = @teams.index(b)
			@chart.set_cell(i, 0, "<a href='/teams/#{b.id}'>#{b.name}</a>")
			@chart.set_cell(i, 1, b.year)
      @chart.set_cell(i, 2, b.division.league.name)
      @chart.set_cell(i, 3, b.wins)
      @chart.set_cell(i, 4, b.losses)
      @chart.set_cell(i, 5, b.rank)
    }
    options = { :width => 600, :allowHtml => true }
    options.each_pair do | key, value |
    @chart.send "#{key}=", value
  end
  end


end
