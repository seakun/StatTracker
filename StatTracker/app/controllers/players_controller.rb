class PlayersController < ApplicationController
  def index
    #@players = Player.all
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
    @chart.add_rows(@batting_stats.size+1)
    i=0
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
    @chart.set_cell(i, 0, b.team.year.to_s)
    @chart.set_cell(i, 1, b.player.age(b.team.year).to_s)
    @chart.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
    @chart.set_cell(i, 3, "<span title='Games'>#{b.games}</span>")
    @chart.set_cell(i, 4, b.plate_appearances.to_s)
	  @chart.set_cell(i, 5, b.at_bats.to_s)
	  @chart.set_cell(i, 6, b.runs.to_s)
	  @chart.set_cell(i, 7, b.hits.to_s)
    @chart.set_cell(i, 8, b.doubles.to_s)
    @chart.set_cell(i, 9, b.triples.to_s)
    @chart.set_cell(i, 10, b.home_runs.to_s)
    @chart.set_cell(i, 11, b.rbi.to_s)
    @chart.set_cell(i, 12, b.stolen_bases.to_s)
    @chart.set_cell(i, 13, b.caught_stealing.to_s)
    @chart.set_cell(i, 14, b.walks.to_s)
    @chart.set_cell(i, 15, b.strikeouts.to_s)
    @chart.set_cell(i, 16, b.batting_average.to_s)
    @chart.set_cell(i, 17, b.slugging_percentage.to_s)
    @chart.set_cell(i, 18, b.total_bases.to_s)
    @chart.set_cell(i, 19, b.on_base_percentage.to_s)
    @chart.set_cell(i, 20, b.on_base_plus_slugging.to_s)
	}
    i+=1
    @chart.set_cell(i, 0, "Totals")
    @chart.set_cell(i, 3, BattingStat.get_stat_total(params[:id], :games))
    @chart.set_cell(i, 4, BattingStat.get_stat_total(params[:id], :plate_appearances))
	  @chart.set_cell(i, 5, BattingStat.get_stat_total(params[:id], :at_bats))
	  @chart.set_cell(i, 6, BattingStat.get_stat_total(params[:id], :runs))
	  @chart.set_cell(i, 7, BattingStat.get_stat_total(params[:id], :hits))
    @chart.set_cell(i, 8, BattingStat.get_stat_total(params[:id], :doubles))
    @chart.set_cell(i, 9, BattingStat.get_stat_total(params[:id], :triples))
    @chart.set_cell(i, 10, BattingStat.get_stat_total(params[:id], :home_runs))
    @chart.set_cell(i, 11, BattingStat.get_stat_total(params[:id], :rbi))
    @chart.set_cell(i, 12, BattingStat.get_stat_total(params[:id], :stolen_bases))
    @chart.set_cell(i, 13, BattingStat.get_stat_total(params[:id], :caught_stealing))
    @chart.set_cell(i, 14, BattingStat.get_stat_total(params[:id], :walks))
    @chart.set_cell(i, 15, BattingStat.get_stat_total(params[:id], :strikeouts))
	@chart.set_cell(i, 16, (sprintf("%.3f", (BattingStat.get_stat_total(params[:id], :hits).to_f / BattingStat.get_stat_total(params[:id], :at_bats).to_f))).to_s)
	@chart.set_cell(i, 17, (sprintf("%.3f", (BattingStat.get_stat_total(params[:id], :total_bases).to_f / BattingStat.get_stat_total(params[:id], :at_bats).to_f))).to_s)
	@chart.set_cell(i, 18,  BattingStat.get_stat_total(params[:id], :total_bases))
	options = { :allowHtml =>true }
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
    @chart2.set_cell(i, 4, BattingPostStat.get_stat_total(params[:id], :games))
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
  options = { :width => '100%', :allowHtml =>true }
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
      @chart3.set_cell(i, 27, b.hits_per_9_innings.to_s )
      @chart3.set_cell(i, 28, b.home_runs_per_9_innings.to_s )
      @chart3.set_cell(i, 29, b.walks_per_9_innings.to_s )
      @chart3.set_cell(i, 30, b.strikeouts_per_9_innings.to_s )
      @chart3.set_cell(i, 31, b.strikeouts_per_walk.to_s )
		}
    i+=1
    @chart3.set_cell(i, 0, "Totals")
    @chart3.set_cell(i, 4, PitchingStat.get_stat_total(params[:id], :wins))
    @chart3.set_cell(i, 5, PitchingStat.get_stat_total(params[:id], :losses))
#    @chart3.set_cell(i, 6, PitchingStat.get_stat_total(params[:id], :win_loss_percentage))
#    @chart3.set_cell(i, 7, PitchingStat.get_stat_total(params[:id], :era))
    @chart3.set_cell(i, 8, PitchingStat.get_stat_total(params[:id], :games))
    @chart3.set_cell(i, 9, PitchingStat.get_stat_total(params[:id], :games_started))
    @chart3.set_cell(i, 10, PitchingStat.get_stat_total(params[:id], :games_finished))
    @chart3.set_cell(i, 11, PitchingStat.get_stat_total(params[:id], :complete_games))
    @chart3.set_cell(i, 12, PitchingStat.get_stat_total(params[:id], :shutouts))
    @chart3.set_cell(i, 13, PitchingStat.get_stat_total(params[:id], :saves))
#    @chart3.set_cell(i, 14, PitchingStat.get_stat_total(params[:id], :innings_pitched))
    @chart3.set_cell(i, 15, PitchingStat.get_stat_total(params[:id], :hits))
    @chart3.set_cell(i, 16, PitchingStat.get_stat_total(params[:id], :runs))
    @chart3.set_cell(i, 17, PitchingStat.get_stat_total(params[:id], :earned_runs))
    @chart3.set_cell(i, 18, PitchingStat.get_stat_total(params[:id], :home_runs))
    @chart3.set_cell(i, 19, PitchingStat.get_stat_total(params[:id], :walks))
    @chart3.set_cell(i, 20, PitchingStat.get_stat_total(params[:id], :intentional_walks))
    @chart3.set_cell(i, 21, PitchingStat.get_stat_total(params[:id], :strikeouts))
    @chart3.set_cell(i, 22, PitchingStat.get_stat_total(params[:id], :hit_by_pitch))
    @chart3.set_cell(i, 23, PitchingStat.get_stat_total(params[:id], :balks))
    @chart3.set_cell(i, 24, PitchingStat.get_stat_total(params[:id], :wild_pitches))
    @chart3.set_cell(i, 25, PitchingStat.get_stat_total(params[:id], :batters_faced))
  options = { :width => '100%', :allowHtml =>true }
  options.each_pair do | key, value |
    @chart3.send "#{key}=", value
  end
  @pitching_stats_post=PitchingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
   @pitching_stats_post=PitchingPostStat.find(:all, :conditions => ['player_id = ?', params[:id]])
    @chart4 = GoogleVisualr::Table.new
    @chart4.add_column('string' , 'Year')
		@chart4.add_column('string' , 'Age')
		@chart4.add_column('string' , 'Team')
		@chart4.add_column('string' , 'League')
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
			@chart4.set_cell(i, 0, b.team.year.to_s)
      @chart4.set_cell(i, 1, b.player.age(b.team.year).to_s)
      @chart4.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
      @chart4.set_cell(i, 3, b.team.division.league.name.to_s)
      @chart4.set_cell(i, 4, b.round)
			@chart4.set_cell(i, 5, b.wins.to_s)
      @chart4.set_cell(i, 6, b.losses.to_s)
      @chart4.set_cell(i, 7, b.win_loss_percentage.to_s )
      @chart4.set_cell(i, 8, b.era.to_s )
      @chart4.set_cell(i, 9, b.games.to_s )
      @chart4.set_cell(i, 10, b.games_started.to_s )
      @chart4.set_cell(i, 11, b.games_finished.to_s )
      @chart4.set_cell(i, 12, b.complete_games.to_s )
      @chart4.set_cell(i, 13, b.shutouts.to_s)
      @chart4.set_cell(i, 14, b.saves.to_s )
      @chart4.set_cell(i, 15, b.innings_pitched.to_s )
      @chart4.set_cell(i, 16, b.hits.to_s )
      @chart4.set_cell(i, 17, b.runs.to_s )
      @chart4.set_cell(i, 18, b.earned_runs.to_s)
      @chart4.set_cell(i, 19, b.home_runs.to_s)
      @chart4.set_cell(i, 20, b.walks.to_s)
      @chart4.set_cell(i, 21, b.intentional_walks.to_s )
      @chart4.set_cell(i, 22, b.strikeouts.to_s)
      @chart4.set_cell(i, 23, b.hit_by_pitch.to_s )
      @chart4.set_cell(i, 24, b.balks.to_s )
      @chart4.set_cell(i, 25, b.wild_pitches.to_s)
      @chart4.set_cell(i, 26, b.batters_faced.to_s )
      @chart4.set_cell(i, 27, b.walks_and_hits_innings_pitched.to_s )
      @chart4.set_cell(i, 28, b.hits_per_9_innings.to_s )
      @chart4.set_cell(i, 29, b.home_runs_per_9_innings.to_s )
      @chart4.set_cell(i, 30, b.walks_per_9_innings.to_s )
      @chart4.set_cell(i, 31, b.strikeouts_per_9_innings.to_s )
      @chart4.set_cell(i, 32, b.strikeouts_per_walk.to_s )
		}
     i+=1
    @chart4.set_cell(i, 0, "Totals")
    @chart4.set_cell(i, 5, PitchingPostStat.get_stat_total(params[:id], :wins))
    @chart4.set_cell(i, 6, PitchingPostStat.get_stat_total(params[:id], :losses))
#    @chart4.set_cell(i, 7, PitchingPostStat.get_stat_total(params[:id], :win_loss_percentage))
#    @chart4.set_cell(i, 8, PitchingPostStat.get_stat_total(params[:id], :era))
    @chart4.set_cell(i, 9, PitchingPostStat.get_stat_total(params[:id], :games))
    @chart4.set_cell(i, 10, PitchingPostStat.get_stat_total(params[:id], :games_started))
    @chart4.set_cell(i, 11, PitchingPostStat.get_stat_total(params[:id], :games_finished))
    @chart4.set_cell(i, 12, PitchingPostStat.get_stat_total(params[:id], :complete_games))
    @chart4.set_cell(i, 13, PitchingPostStat.get_stat_total(params[:id], :shutouts))
    @chart4.set_cell(i, 14, PitchingPostStat.get_stat_total(params[:id], :saves))
#    @chart4.set_cell(i, 15, PitchingPostStat.get_stat_total(params[:id], :innings_pitched))
    @chart4.set_cell(i, 16, PitchingPostStat.get_stat_total(params[:id], :hits))
    @chart4.set_cell(i, 17, PitchingPostStat.get_stat_total(params[:id], :runs))
    @chart4.set_cell(i, 18, PitchingPostStat.get_stat_total(params[:id], :earned_runs))
    @chart4.set_cell(i, 19, PitchingPostStat.get_stat_total(params[:id], :home_runs))
    @chart4.set_cell(i, 20, PitchingPostStat.get_stat_total(params[:id], :walks))
    @chart4.set_cell(i, 21, PitchingPostStat.get_stat_total(params[:id], :intentional_walks))
    @chart4.set_cell(i, 22, PitchingPostStat.get_stat_total(params[:id], :strikeouts))
    @chart4.set_cell(i, 23, PitchingPostStat.get_stat_total(params[:id], :hit_by_pitch))
    @chart4.set_cell(i, 24, PitchingPostStat.get_stat_total(params[:id], :balks))
    @chart4.set_cell(i, 25, PitchingPostStat.get_stat_total(params[:id], :wild_pitches))
    @chart4.set_cell(i, 26, PitchingPostStat.get_stat_total(params[:id], :batters_faced))
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
    @players = Player.player_search(@query)
    @total_hits = @players.size
    if @total_hits == 1
      if @players.first != nil
        redirect_to @players.first
      end
    end
  end

end
