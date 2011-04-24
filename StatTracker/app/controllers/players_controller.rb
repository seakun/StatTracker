class PlayersController < ApplicationController
autocomplete :player, :name, :full => true
  def index
    #@players = Player.all
  end

  def show
    @player = Player.find(params[:id])
	@position = FieldingStat.where("player_id = ?", @player.id).sort_by{|s| s.games}.last.position
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
    @chart.add_rows(@batting_stats.size+1)
    i=0
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
    games="Games"
	runs="Runs"
	bats="At Bats"
	plates="Plate Appearances"
	hits="Hits"
	doubles="Doubles"
	triples="Triples"
	home="Home Runs"
	rbi="RBI"
	stolen="Stolen Bases"
	caught="Caught Stealing"
	walks="Walks"
	strikes="Strikeouts"
	bases="Total Bases"
	totalgames="Total Games"
	totalruns="Total Runs"
	totalbats="Total At Bats"
	totalplates="Total Plate Appearances"
	totalhits="Total Hits"
	totaldoubles="Total Doubles"
	totaltriples="Total Triples"
	totalhome="Total Home Runs"
	totalrbi="Total RBI"
	totalstolen="Total Stolen Bases"
	totalcaught="Total Caught Stealing"
	totalwalks="Total Walks"
	totalstrikes="Total Strikeouts"
	@chart.set_cell(i, 0, "<span title='Year'>#{b.team.year.to_s}</span>")
    @chart.set_cell(i, 1, "<span title='Age'>#{b.player.age(b.team.year).to_s}</span>")
    @chart.set_cell(i, 2, "<span title='Team'><a href='/teams/#{b.team.id}'>#{b.team.name}</a></span>")
    @chart.set_cell(i, 3, b.games, "<span title=#{games}>#{b.games.to_s}</span>")
    @chart.set_cell(i, 4, b.plate_appearances, "<span title=#{plates}>#{b.plate_appearances.to_s}</span>")
	  @chart.set_cell(i, 5, b.at_bats, "<span title=#{bats}>#{b.at_bats.to_s}</span>")
	  @chart.set_cell(i, 6, b.runs, "<span title=#{runs}>#{b.runs.to_s}</span>")
	  @chart.set_cell(i, 7, b.hits, "<span title='Hits'>#{b.hits.to_s}</span>")
    @chart.set_cell(i, 8, b.doubles, "<span title=#{doubles}>#{b.doubles.to_s}</span>")
    @chart.set_cell(i, 9, b.triples, "<span title=#{triples}>#{b.triples.to_s}</span>")
    @chart.set_cell(i, 10, b.home_runs, "<span title=#{home}>#{b.home_runs.to_s}</span>")
    @chart.set_cell(i, 11, b.rbi, "<span title=#{rbi}>#{b.rbi.to_s}</span>")
    @chart.set_cell(i, 12, b.stolen_bases, "<span title=#{stolen}>#{b.stolen_bases.to_s}</span>")
    @chart.set_cell(i, 13, b.caught_stealing, "<span title=#{caught}>#{b.caught_stealing.to_s}</span>")
    @chart.set_cell(i, 14, b.walks, "<span title=#{walks}>#{b.walks.to_s}</span>")
    @chart.set_cell(i, 15, b.strikeouts, "<span title=#{strikes}>#{b.strikeouts.to_s}</span>")
    @chart.set_cell(i, 16, "<span title='Batting Average'>#{b.batting_average.to_s}</span>")
    @chart.set_cell(i, 17, "<span title='Slugging Percentage'>#{b.slugging_percentage.to_s}</span>")
    @chart.set_cell(i, 18, b.total_bases, "<span title=#{bases}>#{b.total_bases.to_s}</span>")
    @chart.set_cell(i, 19, "<span title='On Base Percentage'>#{b.on_base_percentage.to_s}</span>")
    @chart.set_cell(i, 20, "<span title='On Base+Slugging'>#{b.on_base_plus_slugging.to_s}</span>")
    @chart.set_cell(i, 21, "<span title='Isolated Power'>#{b.isolated_power.to_s}</span>")
	}
    # i+=1
    # @chart.set_cell(i, 0, "Totals")
    # @chart.set_cell(i, 3, BattingStat.get_stat_total(params[:id], :games), "<span title='Total Games'>#{BattingStat.get_stat_total(params[:id], :games)}</span>")
    # @chart.set_cell(i, 4, @player.career_plate_appearances, "<span title='Total Plate Appearances'>#{@player.career_plate_appearances}</span>")
	  # @chart.set_cell(i, 5, @player.career_at_bats, "<span title='Total At Bats'>#{@player.career_at_bats}</span>")
	  # @chart.set_cell(i, 6, "<span title='Total Runs'>#{BattingStat.get_stat_total(params[:id], :runs)}</span>")
	  # @chart.set_cell(i, 7, "<span title='Total Hits'>#{@player.career_hits}</span>")
    # @chart.set_cell(i, 8, "<span title='Total Doubles'>#{BattingStat.get_stat_total(params[:id], :doubles)}</span>")
    # @chart.set_cell(i, 9, "<span title='Total Triples'>#{BattingStat.get_stat_total(params[:id], :triples)}</span>")
    # @chart.set_cell(i, 10, "<span title='Total Home Runs'>#{@player.career_home_runs}</span>")
    # @chart.set_cell(i, 11, "<span title='Total RBI'>#{BattingStat.get_stat_total(params[:id], :rbi)}</span>")
    # @chart.set_cell(i, 12, "<span title='Total Stolen Bases'>#{@player.career_stolen_bases}</span>")
    # @chart.set_cell(i, 13, "<span title='Total Caught Stealing'>#{@player.career_caught_stealing}</span>")
    # @chart.set_cell(i, 14, "<span title='Total Walks'>#{@player.career_walks}</span>")
    # @chart.set_cell(i, 15, "<span title='Total Strikeouts'>#{@player.career_strikeouts}</span>")
	# @chart.set_cell(i, 16, "<span title='Batting Average'>#{@player.career_batting_average}</span>")
	# @chart.set_cell(i, 17, "<span title='Slugging Percentage'>#{@player.career_slugging_percentage}</span>")
	# @chart.set_cell(i, 18,  "<span title='Total Bases'>#{@player.career_total_bases}</span>")
	# @chart.set_cell(i, 19,  "<span title='On Base Percentage'>#{@player.career_on_base_percentage}</span>")
	# @chart.set_cell(i, 20,  "<span title='On Base Plus Slugging'>#{@player.career_on_base_plus_slugging}</span>")
	# @chart.set_cell(i, 21,  "<span title='Isolated Power'>#{@player.career_isolated_power}</span>")
	options = { :width => '100%', :allowHtml =>true, :cssClassNames => {:headerRow => 'google_table'}}
	options.each_pair do | key, value |
		@chart.send "#{key}=", value
	end
   @batting_stats_post=BattingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('string' , 'Year')
		@chart2.add_column('string' , 'Age')
		@chart2.add_column('string' , 'Team')
    @chart2.add_column('string' , 'Round')
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
    @chart2.set_cell(i, 0, "<span title='Year'>#{b.team.year.to_s}</span>")
    @chart2.set_cell(i, 1, "<span title='Age'>#{b.player.age(b.team.year).to_s}</span>")
    @chart2.set_cell(i, 2, "<span title='Team'><a href='/teams/#{b.team.id}'>#{b.team.name}</a></span>")
    @chart2.set_cell(i, 3, "<span title='Round'>#{b.round.to_s[0,4]}</span>")
    @chart2.set_cell(i, 4, "<span title='Games'>#{b.games}</span>")
    @chart2.set_cell(i, 5, "<span title='Plate Appearances'>#{b.plate_appearances.to_s}</span>")
	  @chart2.set_cell(i, 6, "<span title='At Bats'>#{b.at_bats.to_s}</span>")
	  @chart2.set_cell(i, 7, "<span title='Runs'>#{b.runs.to_s}</span>")
	  @chart2.set_cell(i, 8, "<span title='Hits'>#{b.hits.to_s}</span>")
    @chart2.set_cell(i, 9, "<span title='Doubles'>#{b.doubles.to_s}</span>")
    @chart2.set_cell(i, 10, "<span title='Triples'>#{b.triples.to_s}</span>")
    @chart2.set_cell(i, 11, "<span title='Home Runs'>#{b.home_runs.to_s}</span>")
    @chart2.set_cell(i, 12, "<span title='RBI'>#{b.rbi.to_s}</span>")
    @chart2.set_cell(i, 13, "<span title='Stolen Bases'>#{b.stolen_bases.to_s}</span>")
    @chart2.set_cell(i, 14, "<span title='Caught Stealing'>#{b.caught_stealing.to_s}</span>")
    @chart2.set_cell(i, 15, "<span title='Walks'>#{b.walks.to_s}</span>")
    @chart2.set_cell(i, 16, "<span title='Strikeouts'>#{b.strikeouts.to_s}</span>")
    @chart2.set_cell(i, 17, "<span title='Batting Average'>#{b.batting_average.to_s}</span>")
    @chart2.set_cell(i, 18, "<span title='Slugging Percentage'>#{b.slugging_percentage.to_s}</span>")
    @chart2.set_cell(i, 19, "<span title='Total Bases'>#{b.total_bases.to_s}</span>")
    @chart2.set_cell(i, 20, "<span title='On Base Percentage'>#{b.on_base_percentage.to_s}</span>")
    @chart2.set_cell(i, 21, "<span title='On Base+Slugging'>#{b.on_base_plus_slugging.to_s}</span>")
    @chart2.set_cell(i, 22, "<span title='Isolated Power'>#{b.isolated_power.to_s}</span>")
		}
   i+=1
    @chart2.set_cell(i, 0, "Totals")
    @chart2.set_cell(i, 4, "<span title='Total Games'>#{BattingPostStat.get_stat_total(params[:id], :games)}</span>")
    @chart2.set_cell(i, 5, "<span title='Total Plate Appearances'>#{@player.career_plate_appearances_post}</span>")
	  @chart2.set_cell(i, 6, "<span title='Total At Bats'>#{@player.career_at_bats_post}</span>")
	  @chart2.set_cell(i, 7, "<span title='Total Runs'>#{BattingPostStat.get_stat_total(params[:id], :runs)}</span>")
	  @chart2.set_cell(i, 8, "<span title='Total Hits'>#{@player.career_hits_post}</span>")
    @chart2.set_cell(i, 9, "<span title='Total Doubles'>#{BattingPostStat.get_stat_total(params[:id], :doubles)}</span>")
    @chart2.set_cell(i, 10, "<span title='Total Triples'>#{BattingPostStat.get_stat_total(params[:id], :triples)}</span>")
    @chart2.set_cell(i, 11, "<span title='Total Home Runs'>#{@player.career_home_runs_post}</span>")
    @chart2.set_cell(i, 12, "<span title='Total RBI'>#{BattingPostStat.get_stat_total(params[:id], :rbi)}</span>")
    @chart2.set_cell(i, 13, "<span title='Total Stolen Bases'>#{@player.career_stolen_bases_post}</span>")
    @chart2.set_cell(i, 14, "<span title='Total Caught Stealing'>#{@player.career_caught_stealing_post}</span>")
    @chart2.set_cell(i, 15, "<span title='Total Walks'>#{@player.career_walks_post}</span>")
    @chart2.set_cell(i, 16, "<span title='Total Strikeouts'>#{@player.career_strikeouts_post}</span>")
	@chart2.set_cell(i, 17, "<span title='Batting Average'>#{@player.career_post_batting_average}</span>")
	@chart2.set_cell(i, 18, "<span title='Slugging Percentage'>#{@player.career_post_slugging_percentage}</span>")
	@chart2.set_cell(i, 19,  "<span title='Total Bases'>#{@player.career_total_bases_post}</span>")
	@chart2.set_cell(i, 20,  "<span title='On Base Percentage'>#{@player.career_post_on_base_percentage}</span>")
	@chart2.set_cell(i, 21,  "<span title='On Base Plus Slugging'>#{@player.career_post_on_base_plus_slugging}</span>")
	# @chart.set_cell(i, 22,  "<span title='Isolated Power'>#{@player.career_post_isolated_power}</span>")
  options = { :width => '100%', :allowHtml =>true }
  options.each_pair do | key, value |
    @chart2.send "#{key}=", value
  end
@pitching_stats=PitchingStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart3 = GoogleVisualr::Table.new
    @chart3.add_column('string' , 'Year')
		@chart3.add_column('string' , 'Age')
		@chart3.add_column('string' , 'Team')
		@chart3.add_column('string' , 'W')
		@chart3.add_column('string' , 'L')
		@chart3.add_column('string' , 'WL%')
    @chart3.add_column('string' , 'ERA')
		@chart3.add_column('string' , 'G')
		@chart3.add_column('string' , 'GS')
    @chart3.add_column('string' , 'GF')
    @chart3.add_column('string' , 'CG')
    @chart3.add_column('string' , 'SHO')
    @chart3.add_column('string' , 'SV')
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
    @chart3.add_rows(@pitching_stats.size+1)
    @pitching_stats.each { |b|
			i = @pitching_stats.index(b)
			@chart3.set_cell(i, 0, "<span title='Year'>#{b.team.year.to_s}</span>")
      @chart3.set_cell(i, 1, "<span title='Age'>#{b.player.age(b.team.year).to_s}</span>")
      @chart3.set_cell(i, 2, "<span title='Team'>#{"<a href='/teams/#{b.team.id}'>#{b.team.name}</a>"}</span>")
			@chart3.set_cell(i, 3, "<span title='Wins'>#{b.wins.to_s}</span>")
      @chart3.set_cell(i, 4, "<span title='Losses'>#{b.losses.to_s}</span>")
      @chart3.set_cell(i, 5, "<span title='Win Loss Percentage'>#{b.win_loss_percentage.to_s}</span>" )
      @chart3.set_cell(i, 6, "<span title='ERA'>#{b.era.to_s}</span>" )
      @chart3.set_cell(i, 7, "<span title='Games'>#{b.games.to_s}</span>" )
      @chart3.set_cell(i, 8, "<span title='Games Started'>#{b.games_started.to_s}</span>" )
      @chart3.set_cell(i, 9, "<span title='Games Finished'>#{b.games_finished.to_s}</span>" )
      @chart3.set_cell(i, 10, "<span title='Complete Games'>#{b.complete_games.to_s}</span>" )
      @chart3.set_cell(i, 11, "<span title='Shutouts'>#{b.shutouts.to_s}</span>")
      @chart3.set_cell(i, 12, "<span title='Saves'>#{b.saves.to_s}</span>" )
      @chart3.set_cell(i, 13, "<span title='Innings Pitched'>#{b.innings_pitched.to_s}</span>" )
      @chart3.set_cell(i, 14, "<span title='Hits'>#{b.hits.to_s}</span>" )
      @chart3.set_cell(i, 15, "<span title='Runs'>#{b.runs.to_s}</span>" )
      @chart3.set_cell(i, 16, "<span title='Earned Runs'>#{b.earned_runs.to_s}</span>")
      @chart3.set_cell(i, 17, "<span title='Home Runs'>#{b.home_runs.to_s}</span>")
      @chart3.set_cell(i, 18, "<span title='Walks'>#{b.walks.to_s}</span>")
      @chart3.set_cell(i, 19, "<span title='Intentional Walks'>#{b.intentional_walks.to_s}</span>" )
      @chart3.set_cell(i, 20, "<span title='Strikeouts'>#{b.strikeouts.to_s}</span>")
      @chart3.set_cell(i, 21, "<span title='Hit by Pitch'>#{b.hit_by_pitch.to_s}</span>" )
      @chart3.set_cell(i, 22, "<span title='Balks'>#{b.balks.to_s}</span>" )
      @chart3.set_cell(i, 23, "<span title='Wild Pitches'>#{b.wild_pitches.to_s}</span>")
      @chart3.set_cell(i, 24, "<span title='Batters Faced'>#{b.batters_faced.to_s}</span>" )
      @chart3.set_cell(i, 25, "<span title='Walks and Hits per Innings Pitched'>#{b.walks_and_hits_innings_pitched.to_s}</span>" )
      @chart3.set_cell(i, 26, "<span title='Hits per 9 Innings'>#{b.hits_per_9_innings.to_s}</span>" )
      @chart3.set_cell(i, 27, "<span title='Home Runs per 9 Innings'>#{b.home_runs_per_9_innings.to_s}</span>" )
      @chart3.set_cell(i, 28, "<span title='Walks per 9 Innings'>#{b.walks_per_9_innings.to_s}</span>" )
      @chart3.set_cell(i, 29, "<span title='Strikeouts per 9 Innings'>#{b.strikeouts_per_9_innings.to_s}</span>" )
      @chart3.set_cell(i, 30, "<span title='Strikeouts per Walk'>#{b.strikeouts_per_walk.to_s}</span>" )
		}
    i+=1
    @chart3.set_cell(i, 0, "Totals")
    @chart3.set_cell(i, 3, "<span title='Total Wins'>#{@player.career_wins}</span>")
    @chart3.set_cell(i, 4, "<span title='Total Losses'>#{@player.career_losses}</span>")
    @chart3.set_cell(i, 5, "<span title='Win Loss Percentage'>#{@player.career_win_loss_percentage}</span>")
    @chart3.set_cell(i, 6, "<span title='ERA'>#{@player.career_era}</span>")
    @chart3.set_cell(i, 7, "<span title='Total Games'>#{PitchingStat.get_stat_total(params[:id], :games)}</span>")
    @chart3.set_cell(i, 8, "<span title='Total Games Started'>#{PitchingStat.get_stat_total(params[:id], :games_started)}</span>")
    @chart3.set_cell(i, 9, "<span title='Total Games Finished'>#{PitchingStat.get_stat_total(params[:id], :games_finished)}</span>")
    @chart3.set_cell(i, 10, "<span title='Total Complete Games'>#{PitchingStat.get_stat_total(params[:id], :complete_games)}</span>")
    @chart3.set_cell(i, 11, "<span title='Total Shutouts'>#{PitchingStat.get_stat_total(params[:id], :shutouts)}</span>")
    @chart3.set_cell(i, 12, "<span title='Total Saves'>#{PitchingStat.get_stat_total(params[:id], :saves)}</span>")
    @chart3.set_cell(i, 13, "<span title='Total Innings Pitched'>#{@player.career_innings_pitched}</span>")
    @chart3.set_cell(i, 14, "<span title='Total Hits'>#{@player.career_hits_allowed}</span>")
    @chart3.set_cell(i, 15, "<span title='Total Runs'>#{@player.career_runs_allowed}</span>")
    @chart3.set_cell(i, 16, "<span title='Total Earned Runs'>#{@player.career_earned_runs}</span>")
    @chart3.set_cell(i, 17, "<span title='Total Home Runs'>#{@player.career_home_runs_allowed}</span>")
    @chart3.set_cell(i, 18, "<span title='Total Walks'>#{@player.career_walks_allowed}</span>")
    @chart3.set_cell(i, 19, "<span title='Total Intentional Walks'>#{PitchingStat.get_stat_total(params[:id], :intentional_walks)}</span>")
    @chart3.set_cell(i, 20, "<span title='Total Strikeouts'>#{@player.career_strikeouts_allowed}</span>")
    @chart3.set_cell(i, 21, "<span title='Total Hit by Pitch'>#{@player.career_hit_by_pitches_allowed}</span>")
    @chart3.set_cell(i, 22, "<span title='Total Balks'>#{PitchingStat.get_stat_total(params[:id], :balks)}</span>")
    @chart3.set_cell(i, 23, "<span title='Total Wild Pitches'>#{PitchingStat.get_stat_total(params[:id], :wild_pitches)}</span>")
    @chart3.set_cell(i, 24, "<span title='Total Batters Faced'>#{@player.career_batters_faced}</span>")
	@chart3.set_cell(i, 25, "<span title='Walks and Hits per Innings Pitched'>#{@player.career_walks_and_hits_innings_pitched}</span>" )
    @chart3.set_cell(i, 26, "<span title='Hits per 9 Innings'>#{@player.career_hits_per_9_innings}</span>" )
    @chart3.set_cell(i, 27, "<span title='Home Runs per 9 Innings'>#{@player.career_home_runs_per_9_innings}</span>" )
    @chart3.set_cell(i, 28, "<span title='Walks per 9 Innings'>#{@player.career_walks_per_9_innings}</span>" )
    @chart3.set_cell(i, 29, "<span title='Strikeouts per 9 Innings'>#{@player.career_strikeouts_per_9_innings}</span>" )
    @chart3.set_cell(i, 30, "<span title='Strikeouts per Walk'>#{@player.career_strikeouts_per_walk}</span>" )
  options = { :width => '100%', :allowHtml =>true }
  options.each_pair do | key, value |
    @chart3.send "#{key}=", value
  end
  @pitching_stats_post=PitchingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart4 = GoogleVisualr::Table.new
    @chart4.add_column('string' , 'Year')
		@chart4.add_column('string' , 'Age')
		@chart4.add_column('string' , 'Team')
    @chart4.add_column('string' , 'Round')
		@chart4.add_column('string' , 'W')
		@chart4.add_column('string' , 'L')
		@chart4.add_column('string' , 'WL%')
    @chart4.add_column('string' , 'ERA')
		@chart4.add_column('string' , 'G')
		@chart4.add_column('string' , 'GS')
    @chart4.add_column('string' , 'GF')
    @chart4.add_column('string' , 'CG')
    @chart4.add_column('string' , 'SHO')
    @chart4.add_column('string' , 'SV')
    @chart4.add_column('string' , 'IP')
    @chart4.add_column('string' , 'H')
    @chart4.add_column('string' , 'R')
    @chart4.add_column('string' , 'ER')
    @chart4.add_column('string' , 'HR')
    @chart4.add_column('string', 'BB')
    @chart4.add_column('string' , 'IBB')
    @chart4.add_column('string' , 'K')
    @chart4.add_column('string' , 'HBP')
    @chart4.add_column('string' , 'BK')
    @chart4.add_column('string' , 'WP')
    @chart4.add_column('string' , 'BF')
    @chart4.add_column('string' , 'WHIP')
    @chart4.add_column('string' , 'H/9')
    @chart4.add_column('string' , 'HR/9')
    @chart4.add_column('string' , 'BB/9')
    @chart4.add_column('string' , 'K/9')
    @chart4.add_column('string' , 'K/BB')
    @chart4.add_rows(@pitching_stats_post.size+1)
    @pitching_stats_post.each { |b|
			i = @pitching_stats_post.index(b)
			@chart4.set_cell(i, 0, "<span title='Year'>#{b.team.year.to_s}</span>")
      @chart4.set_cell(i, 1, "<span title='Age'>#{b.player.age(b.team.year).to_s}</span>")
      @chart4.set_cell(i, 2, "<span title='Team'>#{"<a href='/teams/#{b.team.id}'>#{b.team.name}</a>"}</span>")
      @chart4.set_cell(i, 3, "<span title='Round'>#{b.round.to_s[0,4]}</span>")
			@chart4.set_cell(i, 4, "<span title='Wins'>#{b.wins.to_s}</span>")
      @chart4.set_cell(i, 5, "<span title='Losses'>#{b.losses.to_s}</span>")
      @chart4.set_cell(i, 6, "<span title='Win Loss Percentage'>#{b.win_loss_percentage.to_s}</span>" )
      @chart4.set_cell(i, 7, "<span title='ERA'>#{b.era.to_s}</span>" )
      @chart4.set_cell(i, 8, "<span title='Games'>#{b.games.to_s}</span>" )
      @chart4.set_cell(i, 9, "<span title='Games Started'>#{b.games_started.to_s}</span>" )
      @chart4.set_cell(i, 10, "<span title='Games Finished'>#{b.games_finished.to_s}</span>" )
      @chart4.set_cell(i, 11, "<span title='Complete Games'>#{b.complete_games.to_s}</span>" )
      @chart4.set_cell(i, 12, "<span title='Shutouts'>#{b.shutouts.to_s}</span>")
      @chart4.set_cell(i, 13, "<span title='Saves'>#{b.saves.to_s}</span>" )
      @chart4.set_cell(i, 14, "<span title='Innings Pitched'>#{b.innings_pitched.to_s}</span>" )
      @chart4.set_cell(i, 15, "<span title='Hits'>#{b.hits.to_s}</span>" )
      @chart4.set_cell(i, 16, "<span title='Runs'>#{b.runs.to_s}</span>" )
      @chart4.set_cell(i, 17, "<span title='Earned Runs'>#{b.earned_runs.to_s}</span>")
      @chart4.set_cell(i, 18, "<span title='Home Runs'>#{b.home_runs.to_s}</span>")
      @chart4.set_cell(i, 19, "<span title='Walks'>#{b.walks.to_s}</span>")
      @chart4.set_cell(i, 20, "<span title='Intentional Walks'>#{b.intentional_walks.to_s}</span>" )
      @chart4.set_cell(i, 21, "<span title='Strikeouts'>#{b.strikeouts.to_s}</span>")
      @chart4.set_cell(i, 22, "<span title='Hit by Pitch'>#{b.hit_by_pitch.to_s}</span>" )
      @chart4.set_cell(i, 23, "<span title='Balks'>#{b.balks.to_s}</span>" )
      @chart4.set_cell(i, 24, "<span title='Wild Pitches'>#{b.wild_pitches.to_s}</span>")
      @chart4.set_cell(i, 25, "<span title='Batters Faced'>#{b.batters_faced.to_s}</span>" )
      @chart4.set_cell(i, 26, "<span title='Walks and Hits per Innings Pitced'>#{b.walks_and_hits_innings_pitched.to_s}</span>" )
      @chart4.set_cell(i, 27, "<span title='Hits per 9 Innings'>#{b.hits_per_9_innings.to_s}</span>" )
      @chart4.set_cell(i, 28, "<span title='Home Runs per 9 Innings'>#{b.home_runs_per_9_innings.to_s}</span>" )
      @chart4.set_cell(i, 29, "<span title='Walks per 9 Innings'>#{b.walks_per_9_innings.to_s}</span>" )
      @chart4.set_cell(i, 30, "<span title='Strikeouts per 9 Innings'>#{b.strikeouts_per_9_innings.to_s}</span>" )
      @chart4.set_cell(i, 31, "<span title='Strikeouts per Walk'>#{b.strikeouts_per_walk.to_s}</span>" )
		}
     i+=1
    @chart4.set_cell(i, 0, "Totals")
    @chart4.set_cell(i, 4, "<span title='Total Wins'>#{@player.career_wins_post}</span>")
    @chart4.set_cell(i, 5, "<span title='Total Losses'>#{@player.career_losses_post}</span>")
    @chart4.set_cell(i, 6, "<span title='Win Loss Percentage'>#{@player.career_post_win_loss_percentage}</span>")
    @chart4.set_cell(i, 7, "<span title='ERA'>#{@player.career_post_era}</span>")
    @chart4.set_cell(i, 8, "<span title='Total Games'>#{PitchingStat.get_stat_total(params[:id], :games)}</span>")
    @chart4.set_cell(i, 9, "<span title='Total Games Started'>#{PitchingStat.get_stat_total(params[:id], :games_started)}</span>")
    @chart4.set_cell(i, 10, "<span title='Total Games Finished'>#{PitchingStat.get_stat_total(params[:id], :games_finished)}</span>")
    @chart4.set_cell(i, 11, "<span title='Total Complete Games'>#{PitchingStat.get_stat_total(params[:id], :complete_games)}</span>")
    @chart4.set_cell(i, 12, "<span title='Total Shutouts'>#{PitchingStat.get_stat_total(params[:id], :shutouts)}</span>")
    @chart4.set_cell(i, 13, "<span title='Total Saves'>#{PitchingStat.get_stat_total(params[:id], :saves)}</span>")
    @chart4.set_cell(i, 14, "<span title='Total Innings Pitched'>#{@player.career_post_innings_pitched}</span>")
    @chart4.set_cell(i, 15, "<span title='Total Hits'>#{@player.career_hits_allowed_post}</span>")
    @chart4.set_cell(i, 16, "<span title='Total Runs'>#{@player.career_runs_allowed_post}</span>")
    @chart4.set_cell(i, 17, "<span title='Total Earned Runs'>#{@player.career_earned_runs_post}</span>")
    @chart4.set_cell(i, 18, "<span title='Total Home Runs'>#{@player.career_home_runs_allowed_post}</span>")
    @chart4.set_cell(i, 19, "<span title='Total Walks'>#{@player.career_walks_allowed_post}</span>")
    @chart4.set_cell(i, 20, "<span title='Total Intentional Walks'>#{PitchingStat.get_stat_total(params[:id], :intentional_walks)}</span>")
    @chart4.set_cell(i, 21, "<span title='Total Strikeouts'>#{@player.career_strikeouts_allowed_post}</span>")
    @chart4.set_cell(i, 22, "<span title='Total Hit by Pitch'>#{@player.career_hit_by_pitches_allowed_post}</span>")
    @chart4.set_cell(i, 23, "<span title='Total Balks'>#{PitchingStat.get_stat_total(params[:id], :balks)}</span>")
    @chart4.set_cell(i, 24, "<span title='Total Wild Pitches'>#{PitchingStat.get_stat_total(params[:id], :wild_pitches)}</span>")
    @chart4.set_cell(i, 25, "<span title='Total Batters Faced'>#{@player.career_batters_faced_post}</span>")
	@chart4.set_cell(i, 26, "<span title='Walks and Hits per Innings Pitched'>#{@player.career_post_walks_and_hits_innings_pitched}</span>" )
    @chart4.set_cell(i, 27, "<span title='Hits per 9 Innings'>#{@player.career_post_hits_per_9_innings}</span>" )
    @chart4.set_cell(i, 28, "<span title='Home Runs per 9 Innings'>#{@player.career_post_home_runs_per_9_innings}</span>" )
    @chart4.set_cell(i, 29, "<span title='Walks per 9 Innings'>#{@player.career_post_walks_per_9_innings}</span>" )
    @chart4.set_cell(i, 30, "<span title='Strikeouts per 9 Innings'>#{@player.career_post_strikeouts_per_9_innings}</span>" )
    @chart4.set_cell(i, 31, "<span title='Strikeouts per Walk'>#{@player.career_post_strikeouts_per_walk}</span>" )
  options = { :width => '100%', :allowHtml=>true }
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

  def by_letter
    redirect_to players_letter_path(params[:letter])
  end

  def letter
    letter = params[:letter].downcase + '%'
    @players = Player.find(:all, :conditions => ["lower(last_name) like ?", letter]).paginate :page => params[:page], :per_page => 20
  end

  def by_position
    redirect_to players_position_path(params[:position])
  end

  def position
    @players = FieldingStat.find(:all, :conditions => ['position like ?', params[:position]]).map{|p| p.player}.paginate :page => params[:page], :per_page => 20
  end

  def player_search
    @query = params[:query]
	# first_name, last_name, year, dash = @query.split(" ")
	# last_name.chomp!(",")
	# name = first_name + " " + last_name
    @players = @query.blank?? Array.new : Player.player_search(@query)
    if @query.blank?
      if params[:letter].blank?
        @players = FieldingStat.find(:all, :conditions => ['position like ?', params[:position]]).map{|p| p.player}
      else
        @players = Player.find(:all, :conditions => ["lower(last_name) like ?", params[:letter].downcase + '%'])
        @players.delete_if{|p| !p.fielding_stats.map{|s| s.position}.include?(params[:position])} unless params[:position].blank?
      end
    else
      @players.delete_if{|p| !p.fielding_stats.map{|s| s.position}.include?(params[:position])} unless params[:position].blank?
      @players.delete_if{|p| p.last_name[0].downcase != params[:letter].downcase} unless params[:letter].blank?
    end
    @total_hits = @players.size
    if @total_hits == 1
      if @players.first != nil
        redirect_to @players.first
      end
    end
    @players = @players.paginate :page => params[:page], :per_page => 20
    @arr = Array.new
    @arr << "Name: " + @query unless @query.blank?
    @arr << "Position: " + params[:position] unless params[:position].blank?
    @arr << "Last Name Begins With: " + params[:letter] unless params[:letter].blank?
  end

end
