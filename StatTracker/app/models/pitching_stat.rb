class PitchingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :wins, :losses, :games, :games_started, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits, :earned_runs, :home_runs, :walks, :strikeouts, :intentional_walks, :wild_pitches, :hit_by_pitch, :balks, :batters_faced, :games_finished, :runs, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		sorted = PitchingStat.all.sort{|a,b| b.send(stat) <=> a.send(stat)}
		return sorted.take(50)
	end

  def year
    team.year
  end

  def win_loss_percentage()
    wins / (wins + losses)
  end

  def innings_pitched
    innings_pitched_outs / 3
  end

  def era
    (earned_runs * 9) / inings_pitched
  end

  def opponents_batting_average
    #(hits) / (batters_faced - walks - )
  end

  def walks_and_hits_innings_pitched
    (walks + hits) / innings_pitched
  end

  def hits_innings
    (hits * 9) / innings_pitched
  end

  def home_runs_innings
    (home_runs * 9) / innings_pitched
  end
  
  def walks_innings
    (walks * 9) / innings_pitched
  end

  def strikeouts_innings
    (strikeouts * 9) / innings_pitched
  end

  def strikeouts_walks
    (strikeouts / walks)
  end

  def adjusted_era
    league_era = Pitchingstat.where(year => self.year).average(era)
    100 * (league_era / era)
  end

  def base_runs

  end

end
