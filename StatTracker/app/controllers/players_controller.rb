class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
	if @player.final_game.nil?
    @google_image = GoogleImage.all(@player.name+" rotoworld headshot", 0).first
	else
	@google_image = GoogleImage.all(@player.name+" baseball player", 0).first
	end
    @batting_stats=BattingStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart = GoogleVisualr::Table.new
		@chart.add_column('string' , 'Year')
		@chart.add_column('string' , 'Age')
		@chart.add_column('string' , 'Team')
		@chart.add_column('string' , 'League')
		@chart.add_column('string' , 'G')
		@chart.add_column('string' , 'PA')
    @chart.add_column('string' , 'AB')
    @chart.add_column('string' , 'R')
    @chart.add_column('string' , 'H')
    @chart.add_column('string' , '2B')
    @chart.add_column('string' , '3B')
    @chart.add_column('string' , 'HR')
    @chart.add_column('string' , 'RBI')
    @chart.add_column('string' , 'SB')
    @chart.add_column('string' , 'CS')
    @chart.add_column('string' , 'BB')
    @chart.add_column('string' , 'K')
    @chart.add_column('string' , 'BA')
    @chart.add_column('string' , 'SLG')
    @chart.add_column('string' , 'TB')
    @chart.add_column('string' , 'OBP')
    @chart.add_column('string' , 'OPS')
    @chart.add_column('string' , 'ISO')
    @chart.add_rows(@batting_stats.size+1)
    i=0
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
    @chart.set_cell(i, 0,	b.team.year.to_s)
    @chart.set_cell(i, 1, b.player.age(b.team.year).to_s)
    @chart.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
    @chart.set_cell(i, 3, b.team.division.league.name.to_s)
    @chart.set_cell(i, 4, b.games.to_s)
    @chart.set_cell(i, 5, b.plate_appearances.to_s)
	  @chart.set_cell(i, 6, b.at_bats.to_s)
	  @chart.set_cell(i, 7, b.runs.to_s)
	  @chart.set_cell(i, 8, b.hits.to_s)
    @chart.set_cell(i, 9, b.doubles.to_s)
    @chart.set_cell(i, 10, b.triples.to_s)
    @chart.set_cell(i, 11, b.home_runs.to_s)
    @chart.set_cell(i, 12, b.rbi.to_s)
    @chart.set_cell(i, 13, b.stolen_bases.to_s)
    @chart.set_cell(i, 14, b.caught_stealing.to_s)
    @chart.set_cell(i, 15, b.walks.to_s)
    @chart.set_cell(i, 16, b.strikeouts.to_s)
    @chart.set_cell(i, 17, b.batting_average.to_s)
    @chart.set_cell(i, 18, b.slugging_percentage.to_s)
    @chart.set_cell(i, 19, b.total_bases.to_s)
    @chart.set_cell(i, 20, b.on_base_percentage.to_s)
    @chart.set_cell(i, 21, b.on_base_plus_slugging.to_s)
    @chart.set_cell(i, 22, b.isolated_power.to_s)
		}
    i+=1
    @chart.set_cell(i, 0, "Totals")
    @chart.set_cell(i, 4, BattingStat.get_stat_total(params[:id], :runs))
    @chart.set_cell(i, 5, BattingStat.get_stat_total(params[:id], :plate_appearances))
	  @chart.set_cell(i, 6, BattingStat.get_stat_total(params[:id], :at_bats))
	  @chart.set_cell(i, 7, BattingStat.get_stat_total(params[:id], :runs))
	  @chart.set_cell(i, 8, BattingStat.get_stat_total(params[:id], :hits))
    @chart.set_cell(i, 9, BattingStat.get_stat_total(params[:id], :doubles))
    @chart.set_cell(i, 10, BattingStat.get_stat_total(params[:id], :triples))
    @chart.set_cell(i, 11, BattingStat.get_stat_total(params[:id], :home_runs))
    @chart.set_cell(i, 12, BattingStat.get_stat_total(params[:id], :rbi))
    @chart.set_cell(i, 13, BattingStat.get_stat_total(params[:id], :stolen_bases))
    @chart.set_cell(i, 14, BattingStat.get_stat_total(params[:id], :caught_stealing))
    @chart.set_cell(i, 15, BattingStat.get_stat_total(params[:id], :walks))
    @chart.set_cell(i, 16, BattingStat.get_stat_total(params[:id], :strikeouts))
  options = { :width => 900, :allowHtml =>true }
  options.each_pair do | key, value |
    @chart.send "#{key}=", value
  end
   @batting_stats_post=BattingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('string' , 'Year')
		@chart2.add_column('string' , 'Age')
		@chart2.add_column('string' , 'Team')
		@chart2.add_column('string' , 'League')
		@chart2.add_column('string' , 'G')
		@chart2.add_column('string' , 'PA')
    @chart2.add_column('string' , 'AB')
    @chart2.add_column('string' , 'R')
    @chart2.add_column('string' , 'H')
    @chart2.add_column('string' , '2B')
    @chart2.add_column('string' , '3B')
    @chart2.add_column('string' , 'HR')
    @chart2.add_column('string' , 'RBI')
    @chart2.add_column('string' , 'SB')
    @chart2.add_column('string' , 'CS')
    @chart2.add_column('string' , 'BB')
    @chart2.add_column('string' , 'K')
    @chart2.add_column('string' , 'BA')
    @chart2.add_column('string' , 'SLG')
    @chart2.add_column('string' , 'TB')
    @chart2.add_column('string' , 'OBP')
    @chart2.add_column('string' , 'OPS')
    @chart2.add_column('string' , 'ISO')
    @chart2.add_rows(@batting_stats_post.size+1)
    i=0
    @batting_stats_post.each { |b|
			i = @batting_stats_post.index(b)
    @chart2.set_cell(i, 0,	b.team.year.to_s)
    @chart2.set_cell(i, 1, b.player.age(b.team.year).to_s)
    @chart2.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
    @chart2.set_cell(i, 3, b.team.division.league.name.to_s)
    @chart2.set_cell(i, 4, b.games.to_s)
    @chart2.set_cell(i, 5, b.plate_appearances.to_s)
	  @chart2.set_cell(i, 6, b.at_bats.to_s)
	  @chart2.set_cell(i, 7, b.runs.to_s)
	  @chart2.set_cell(i, 8, b.hits.to_s)
    @chart2.set_cell(i, 9, b.doubles.to_s)
    @chart2.set_cell(i, 10, b.triples.to_s)
    @chart2.set_cell(i, 11, b.home_runs.to_s)
    @chart2.set_cell(i, 12, b.rbi.to_s)
    @chart2.set_cell(i, 13, b.stolen_bases.to_s)
    @chart2.set_cell(i, 14, b.caught_stealing.to_s)
    @chart2.set_cell(i, 15, b.walks.to_s)
    @chart2.set_cell(i, 16, b.strikeouts.to_s)
    @chart2.set_cell(i, 17, b.batting_average.to_s)
    @chart2.set_cell(i, 18, b.slugging_percentage.to_s)
    @chart2.set_cell(i, 19, b.total_bases.to_s)
    @chart2.set_cell(i, 20, b.on_base_percentage.to_s)
    @chart2.set_cell(i, 21, b.on_base_plus_slugging.to_s)
    @chart2.set_cell(i, 22, b.isolated_power.to_s)
		}
    i+=1
    @chart2.set_cell(i, 0, "Totals")
    @chart2.set_cell(i, 4, BattingPostStat.get_stat_total(params[:id], :runs))
    @chart2.set_cell(i, 5, BattingPostStat.get_stat_total(params[:id], :plate_appearances))
	  @chart2.set_cell(i, 6, BattingPostStat.get_stat_total(params[:id], :at_bats))
	  @chart2.set_cell(i, 7, BattingPostStat.get_stat_total(params[:id], :runs))
	  @chart2.set_cell(i, 8, BattingPostStat.get_stat_total(params[:id], :hits))
    @chart2.set_cell(i, 9, BattingPostStat.get_stat_total(params[:id], :doubles))
    @chart2.set_cell(i, 10, BattingPostStat.get_stat_total(params[:id], :triples))
    @chart2.set_cell(i, 11, BattingPostStat.get_stat_total(params[:id], :home_runs))
    @chart2.set_cell(i, 12, BattingPostStat.get_stat_total(params[:id], :rbi))
    @chart2.set_cell(i, 13, BattingPostStat.get_stat_total(params[:id], :stolen_bases))
    @chart2.set_cell(i, 14, BattingPostStat.get_stat_total(params[:id], :caught_stealing))
    @chart2.set_cell(i, 15, BattingPostStat.get_stat_total(params[:id], :walks))
    @chart2.set_cell(i, 16, BattingPostStat.get_stat_total(params[:id], :strikeouts))
  options = { :width => 900, :allowHtml =>true }
  options.each_pair do | key, value |
    @chart2.send "#{key}=", value
  end
@pitching_stats=PitchingStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart3 = GoogleVisualr::Table.new
    @chart3.add_column('string' , 'Year')
		@chart3.add_column('string' , 'Age')
		@chart3.add_column('string' , 'Team')
		@chart3.add_column('string' , 'League')
		@chart3.add_column('string' , 'W')
		@chart3.add_column('string' , 'L')
		@chart3.add_column('string' , 'WL%')
    @chart3.add_column('string' , 'ERA')
		@chart3.add_column('string' , 'G')
		@chart3.add_column('string' , 'GS')
    @chart3.add_column('string' , 'GF')
    @chart3.add_column('string' , 'CG')
    @chart3.add_column('string' , 'SHO')
    @chart3.add_column('string' , 'IP')
    @chart3.add_column('string' , 'H')
    @chart3.add_column('string' , 'R')
    @chart3.add_column('string' , 'ER')
    @chart3.add_column('string' , 'HR')
    @chart3.add_column('string', 'BB')
    @chart3.add_column('string' , 'IBB')
    @chart3.add_column('string' , 'K')
    @chart3.add_column('string' , 'HBP')
    @chart3.add_column('string' , 'BK')
    @chart3.add_column('string' , 'WP')
    @chart3.add_column('string' , 'BF')
    @chart3.add_column('string' , 'WHIP')
    @chart3.add_column('string' , 'H/9')
    @chart3.add_column('string' , 'HR/9')
    @chart3.add_column('string' , 'BB/9')
    @chart3.add_column('string' , 'K/9')
    @chart3.add_column('string' , 'K/BB')
    @chart3.add_rows(@pitching_stats.size)
    @pitching_stats.each { |b|
			i = @pitching_stats.index(b)
			@chart3.set_cell(i, 0, b.team.year.to_s)
      @chart3.set_cell(i, 1, b.player.age(b.team.year).to_s)
      @chart3.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
      @chart3.set_cell(i, 3, b.team.division.league.name.to_s)
			@chart3.set_cell(i, 4, b.wins.to_s)
      @chart3.set_cell(i, 5, b.losses.to_s)
      @chart3.set_cell(i, 6, b.win_loss_percentage.to_s )
      @chart3.set_cell(i, 7, b.era.to_s )
      @chart3.set_cell(i, 8, b.games.to_s )
      @chart3.set_cell(i, 9, b.games_started.to_s )
      @chart3.set_cell(i, 10, b.games_finished.to_s )
      @chart3.set_cell(i, 11, b.complete_games.to_s )
      @chart3.set_cell(i, 12, b.shutouts.to_s)
      @chart3.set_cell(i, 13, b.saves.to_s )
      @chart3.set_cell(i, 14, b.innings_pitched.to_s )
      @chart3.set_cell(i, 15, b.hits.to_s )
      @chart3.set_cell(i, 16, b.runs.to_s )
      @chart3.set_cell(i, 17, b.earned_runs.to_s)
      @chart3.set_cell(i, 18, b.home_runs.to_s)
      @chart3.set_cell(i, 19, b.walks.to_s)
      @chart3.set_cell(i, 20, b.intentional_walks.to_s )
      @chart3.set_cell(i, 21, b.strikeouts.to_s)
      @chart3.set_cell(i, 22, b.hit_by_pitch.to_s )
      @chart3.set_cell(i, 23, b.balks.to_s )
      @chart3.set_cell(i, 24, b.wild_pitches.to_s)
      @chart3.set_cell(i, 25, b.batters_faced.to_s )
      @chart3.set_cell(i, 26, b.walks_and_hits_innings_pitched.to_s )
      @chart3.set_cell(i, 27, b.hits_innings.to_s )
      @chart3.set_cell(i, 28, b.home_runs_innings.to_s )
      @chart3.set_cell(i, 29, b.walks_innings.to_s )
      @chart3.set_cell(i, 30, b.strikeouts_innings.to_s )
      @chart3.set_cell(i, 31, b.strikeouts_walks.to_s )
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart3.send "#{key}=", value
  end
  @pitching_stats_post=PitchingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart4 = GoogleVisualr::Table.new
		@chart4.add_column('number' , 'Year')
		@chart4.add_column('number' , 'Wins')
		@chart4.add_column('number' , 'Losses')
    @chart4.add_column('number' , 'Earned Runs')
		@chart4.add_column('number' , 'Walks')
		@chart4.add_column('number' , 'Strike Outs')
    @chart4.add_rows(@pitching_stats_post.size)
    @pitching_stats_post.each { |b|
			i = @pitching_stats_post.index(b)
			@chart4.set_cell(i, 0, b.team.year)
			@chart4.set_cell(i, 1, b.wins)
      @chart4.set_cell(i, 2, b.losses)
      @chart4.set_cell(i, 3, b.earned_runs)
      @chart4.set_cell(i, 4, b.walks)
      @chart4.set_cell(i, 4, b.strikeouts)
		}

  options = { :width => 600 }
  options.each_pair do | key, value |
    @chart4.send "#{key}=", value
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
