class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
  	@player = Player.find(params[:id])
    @batting_stats=BattingStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart = GoogleVisualr::Table.new
		@chart.add_column('number' , 'Year')
		@chart.add_column('number' , 'Age')
		@chart.add_column('string' , 'Team')
		@chart.add_column('string' , 'League')
		@chart.add_column('number' , 'G')
		@chart.add_column('number' , 'PA')
    @chart.add_column('number' , 'AB')
    @chart.add_column('number' , 'R')
    @chart.add_column('number' , 'H')
    @chart.add_column('number' , '2B')
    @chart.add_column('number' , '3B')
    @chart.add_column('number' , 'HR')
    @chart.add_column('number' , 'RBI')
    @chart.add_column('number' , 'SB')
    @chart.add_column('number' , 'CS')
    @chart.add_column('number' , 'BB')
    @chart.add_column('number' , 'K')
    @chart.add_column('string' , 'BA')
    @chart.add_column('string' , 'SLG')
    @chart.add_column('number' , 'TB')
    @chart.add_column('string' , 'OBP')
    @chart.add_column('string' , 'OPS')
    @chart.add_column('string' , 'ISO')
    @chart.add_column('number' , 'RC')

    @chart.add_rows(@batting_stats.size)
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
    @chart.set_cell(i, 0,	b.team.year)
    @chart.set_cell(i, 1, b.player.age(b.team.year))
    @chart.set_cell(i, 2, b.team.name)
    @chart.set_cell(i, 3, b.team.division.league.name)
    @chart.set_cell(i, 4, b.games)
    @chart.set_cell(i, 5, b.plate_appearances)
	  @chart.set_cell(i, 6, b.at_bats)
	  @chart.set_cell(i, 7, b.runs)
	  @chart.set_cell(i, 8, b.hits)
    @chart.set_cell(i, 9, b.doubles)
    @chart.set_cell(i, 10, b.triples)
    @chart.set_cell(i, 11, b.home_runs)
    @chart.set_cell(i, 12, b.rbi)
    @chart.set_cell(i, 13, b.stolen_bases)
    @chart.set_cell(i, 14, b.caught_stealing)
    @chart.set_cell(i, 15, b.walks)
    @chart.set_cell(i, 16, b.strikeouts)
    @chart.set_cell(i, 17, b.batting_average.to_s)
    @chart.set_cell(i, 18, b.slugging_percentage.to_s)
    @chart.set_cell(i, 19, b.total_bases)
    @chart.set_cell(i, 20, b.on_base_percentage.to_s)
    @chart.set_cell(i, 21, b.on_base_plus_slugging.to_s)
    @chart.set_cell(i, 22, b.isolated_power.to_s)
	  @chart.set_cell(i, 23, b.runs_created)
		}

  options = { :width => 900 }
  options.each_pair do | key, value |
    @chart.send "#{key}=", value
  end
   @batting_stats_post=BattingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('number' , 'Year')
		@chart2.add_column('number' , 'Runs')
		@chart2.add_column('number' , 'Hits')
		@chart2.add_column('number' , 'Home Runs')
		@chart2.add_column('number' , 'RBI')
		@chart2.add_column('number' , 'Stolen Bases')
    @chart2.add_rows(@batting_stats_post.size)
    @batting_stats_post.each { |b|
			i = @batting_stats_post.index(b)
			@chart2.set_cell(i, 0, b.team.year)
			@chart2.set_cell(i, 1, b.runs)
      @chart2.set_cell(i, 2, b.hits)
      @chart2.set_cell(i, 3, b.home_runs)
      @chart2.set_cell(i, 4, b.rbi)
      @chart2.set_cell(i, 5, b.stolen_bases)
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart2.send "#{key}=", value
  end
  @fielding_stats=FieldingStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart3 = GoogleVisualr::Table.new
		@chart3.add_column('number' , 'Year')
		@chart3.add_column('string' , 'Position')
		@chart3.add_column('number' , 'Inning Outs')
		@chart3.add_column('number' , 'Double Plays')
		@chart3.add_column('number' , 'Errors')
    @chart3.add_rows(@fielding_stats.size)
    @fielding_stats.each { |b|
			i = @fielding_stats.index(b)
			@chart3.set_cell(i, 0, b.team.year)
			@chart3.set_cell(i, 1, b.position)
      @chart3.set_cell(i, 2, b.inning_outs)
      @chart3.set_cell(i, 3, b.double_plays)
      @chart3.set_cell(i, 4, b.errors_made)
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart3.send "#{key}=", value
  end
  @fielding_stats_post=FieldingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart4 = GoogleVisualr::Table.new
		@chart4.add_column('number' , 'Year')
		@chart4.add_column('string' , 'Position')
		@chart4.add_column('number' , 'Inning Outs')
		@chart4.add_column('number' , 'Double Plays')
		@chart4.add_column('number' , 'Errors')
    @chart4.add_rows(@fielding_stats_post.size)
    @fielding_stats_post.each { |b|
			i = @fielding_stats_post.index(b)
			@chart4.set_cell(i, 0, b.team.year)
			@chart4.set_cell(i, 1, b.position)
      @chart4.set_cell(i, 2, b.inning_outs)
      @chart4.set_cell(i, 3, b.double_plays)
      @chart4.set_cell(i, 4, b.errors_made)
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart4.send "#{key}=", value
  end
@pitching_stats=PitchingStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart5 = GoogleVisualr::Table.new
		@chart5.add_column('number' , 'Year')
		@chart5.add_column('number' , 'Wins')
		@chart5.add_column('number' , 'Losses')
    @chart5.add_column('number' , 'Earned Runs')
		@chart5.add_column('number' , 'Walks')
		@chart5.add_column('number' , 'Strike Outs')
    @chart5.add_rows(@pitching_stats.size)
    @pitching_stats.each { |b|
			i = @pitching_stats.index(b)
			@chart5.set_cell(i, 0, b.team.year)
			@chart5.set_cell(i, 1, b.wins)
      @chart5.set_cell(i, 2, b.losses)
      @chart5.set_cell(i, 3, b.earned_runs)
      @chart5.set_cell(i, 4, b.walks)
      @chart5.set_cell(i, 4, b.strikeouts)
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart5.send "#{key}=", value
  end
  @pitching_stats_post=PitchingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart6 = GoogleVisualr::Table.new
		@chart6.add_column('number' , 'Year')
		@chart6.add_column('number' , 'Wins')
		@chart6.add_column('number' , 'Losses')
    @chart6.add_column('number' , 'Earned Runs')
		@chart6.add_column('number' , 'Walks')
		@chart6.add_column('number' , 'Strike Outs')
    @chart6.add_rows(@pitching_stats_post.size)
    @pitching_stats_post.each { |b|
			i = @pitching_stats_post.index(b)
			@chart6.set_cell(i, 0, b.team.year)
			@chart6.set_cell(i, 1, b.wins)
      @chart6.set_cell(i, 2, b.losses)
      @chart6.set_cell(i, 3, b.earned_runs)
      @chart6.set_cell(i, 4, b.walks)
      @chart6.set_cell(i, 4, b.strikeouts)
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart6.send "#{key}=", value
  end
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(params[:player])
    if @player.save
      flash[:notice] = "Successfully created player."
      redirect_to @player
    else
      render :action => 'new'
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      flash[:notice] = "Successfully updated player."
      redirect_to player_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    flash[:notice] = "Successfully destroyed player."
    redirect_to players_url
  end

end
