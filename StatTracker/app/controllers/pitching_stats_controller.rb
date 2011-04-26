class PitchingStatsController < ApplicationController
  def index
    @pitching_stats = PitchingStat.all
  end

  def show
    @pitching_stat = PitchingStat.find(params[:id])
  end
  
	def single_season
		@pitching_stats = PitchingStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		if params[:stat] == 'era'
			@table.add_column('string' , params[:stat].upcase)
		else @table.add_column('string' , params[:stat].titleize)
		end
		@table.add_rows(50)
		@pitching_stats.each { |b|
			i = @pitching_stats.index(b)
			@table.set_cell(i, 0, "<a href='/players/#{b.player.id}'>#{b.player.name}</a>")
			if !b.player.throws.nil?
				@table.set_cell(i, 1, b.player.throws)
			else @table.set_cell(i, 1, 'N/A')
			end
			@table.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
			@table.set_cell(i, 3, "#{b.year}")
			@table.set_cell(i, 4, "#{b.send(params[:stat])}")
		}
		
		options = { :width => 600, :showRowNumber => true, :allowHtml=>true  }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end	
	end
	
	def career
		@pitching_stats = PitchingStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		if params[:stat] == 'era'
			@table.add_column('string' , params[:stat].upcase)
		else @table.add_column('string' , params[:stat].titleize)
		end
		@table.add_rows(50)
		i = 0
			if PitchingStat.accessible_attributes.include?(params[:stat])
				@pitching_stats.each { |k, v|
					@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
					if !k.throws.nil?
						@table.set_cell(i, 1, k.throws)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{v}")
					i += 1
				}
			else 
				@pitching_stats.each { |b|
					@table.set_cell(i, 0, "<a href='/players/#{b.id}'>#{b.name}</a>")
					if !b.throws.nil?
						@table.set_cell(i, 1, b.throws)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{b.send("career_" + params[:stat])}")
					i += 1
				}
			end
		options = { :width => 600, :showRowNumber => true, :allowHtml=>true  }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def active
		@pitching_stats = PitchingStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		if params[:stat] == 'era'
			@table.add_column('string' , params[:stat].upcase)
		else @table.add_column('string' , params[:stat].titleize)
		end
		@table.add_rows(50)
		i = 0
			if PitchingStat.accessible_attributes.include?(params[:stat])
				@pitching_stats.each { |k, v|
					@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
					if !k.throws.nil?
						@table.set_cell(i, 1, k.throws)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{v}")
					i += 1
				}
			else 
				@pitching_stats.each { |b|
					@table.set_cell(i, 0, "<a href='/players/#{b.id}'>#{b.name}</a>")
					if !b.throws.nil?
						@table.set_cell(i, 1, b.throws)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{b.send("career_" + params[:stat])}")
					i += 1
				}
			end	
		options = { :width => 600, :showRowNumber => true, :allowHtml=>true  }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def season_compare
		@pitchers = PitchingStat.season_compare(params[:comp])
		if @pitchers.empty?	
			flash[:notice] = "One or more of the players you have chosen do not have pitching statistics available. Please select different players."
			redirect_to :back
		else
			@table = GoogleVisualr::Table.new
			@table.add_column('string' , 'Name')
			@table.add_column('string' , 'Bats')
			@table.add_column('string' , 'Year')
			@table.add_column('string' , 'Age')
			@table.add_column('string' , 'Team')
			@table.add_column('string' , 'League')
			@table.add_column('string' , 'W')
			@table.add_column('string' , 'L')
			@table.add_column('string' , 'WL%')
			@table.add_column('string' , 'ERA')
			@table.add_column('string' , 'G')
			@table.add_column('string' , 'GS')
			@table.add_column('string' , 'CG')
			@table.add_column('string' , 'SHO')
			@table.add_column('string' , 'SV')
			@table.add_column('string' , 'IP')
			@table.add_column('string' , 'H')
			@table.add_column('string' , 'R')
			@table.add_column('string' , 'ER')
			@table.add_column('string' , 'HR')
			@table.add_column('string', 'BB')
			@table.add_column('string' , 'IBB')
			@table.add_column('string' , 'K')
			@table.add_column('string' , 'HBP')
			@table.add_column('string' , 'BK')
			@table.add_column('string' , 'WP')
			@table.add_column('string' , 'BF')
			@table.add_column('string' , 'WHIP')
			@table.add_column('string' , 'H/9')
			@table.add_column('string' , 'HR/9')
			@table.add_column('string' , 'BB/9')
			@table.add_column('string' , 'K/9')
			@table.add_column('string' , 'K/BB')
			@table.add_rows(@pitchers.size)
			i = 0
			@pitchers.each {|b|
				@table.set_cell(i, 0, "<a href='/players/#{b[0].player_id}'>#{b[0].player.name}</a>")
				if !b[0].player.bats.nil?
					@table.set_cell(i, 1, b[0].player.bats.to_s)
				else @table.set_cell(i, 1, 'N/A')
				end
				@table.set_cell(i, 2, b[0].team.year.to_s)
				@table.set_cell(i, 3, b[0].player.age(b[0].team.year).to_s)
				@table.set_cell(i, 4, "<a href='/teams/#{b[0].team.id}'>#{b[0].team.name}</a>")
				@table.set_cell(i, 5, b[0].team.division.league.abbrev.to_s)
				@table.set_cell(i, 6, b[0].wins.to_s)
				@table.set_cell(i, 7, b[0].losses.to_s)
				@table.set_cell(i, 8, b[0].win_loss_percentage.to_s)
				@table.set_cell(i, 9, b[0].era.to_s)
				@table.set_cell(i, 10, b[0].games.to_s)
				@table.set_cell(i, 11, b[0].games_started.to_s)
				@table.set_cell(i, 12, b[0].complete_games.to_s)
				@table.set_cell(i, 13, b[0].shutouts.to_s)
				@table.set_cell(i, 14, b[0].saves.to_s)
				@table.set_cell(i, 15, b[0].innings_pitched.to_s)
				@table.set_cell(i, 16, b[0].hits.to_s)
				@table.set_cell(i, 17, b[0].runs.to_s)
				@table.set_cell(i, 18, b[0].earned_runs.to_s)
				@table.set_cell(i, 19, b[0].home_runs.to_s)
				@table.set_cell(i, 20, b[0].walks.to_s)
				@table.set_cell(i, 21, b[0].intentional_walks.to_s)
				@table.set_cell(i, 22, b[0].strikeouts.to_s)
				@table.set_cell(i, 23, b[0].hit_by_pitch.to_s)
				@table.set_cell(i, 24, b[0].balks.to_s)
				@table.set_cell(i, 25, b[0].wild_pitches.to_s)
				@table.set_cell(i, 26, b[0].batters_faced.to_s)
				@table.set_cell(i, 27, b[0].walks_and_hits_innings_pitched.to_s)
				@table.set_cell(i, 28, b[0].hits_per_9_innings.to_s)
				@table.set_cell(i, 29, b[0].home_runs_per_9_innings.to_s)
				@table.set_cell(i, 30, b[0].walks_per_9_innings.to_s)
				@table.set_cell(i, 31, b[0].strikeouts_per_9_innings.to_s)
				@table.set_cell(i, 32, b[0].strikeouts_per_walk.to_s)
				i += 1
			}
			
			options = { :width => '100%', :allowHtml=>true }
			options.each_pair do | key, value |
				@table.send "#{key}=", value
			end
		end
	end
	
	def career_compare
		@pitchers = PitchingStat.career_compare(params[:comp])
		if @pitchers.empty?	
			flash[:notice] = "One or more of the players you have chosen do not have pitching statistics available. Please select different players."
			redirect_to :back
		else
			@player = []
			@players = []
			@pitchers.each_value {|value|
				if @player.include?(value)
				else @player.push(value)
				end
			}
			@max = []
			@player.each {|p|
				@players.push(Player.find(p.to_i))
				@max.push(PitchingStat.find(:all, :select => [:team_id], :conditions => ['player_id =?', p]).size)
			}
			@chart = GoogleVisualr::LineChart.new
			@chart.add_column('string', 'Year')
			@players.each { |play|
				@chart.add_column('number', play.name)
			}	
			@chart.add_rows(@max.max)
			y = 1
			@players.each { |play|
			x = 0
			year = 1
			stats = PitchingStat.get_all_stats(play.id, :wins)
				stats.each {|s|
					@chart.set_value(x, 0, year.to_s)
					@chart.set_value(x, y, s.wins)
					x += 1
					year += 1
				}
				y += 1
			}
			options = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Wins Each Year", :titleX => "Year in Player's Career", :titleY => "Number of Wins"}
			options.each_pair do | key, value |
				@chart.send "#{key}=", value
			end
			
			@chart2 = GoogleVisualr::LineChart.new
			@chart2.add_column('string', 'Year')
			@players.each { |play|
				@chart2.add_column('number', play.name)
			}	
			@chart2.add_rows(@max.max)
			y = 1
			@players.each { |play|
			x = 0
			year = 1
			stats = PitchingStat.get_all_stats(play.id, :wins)
			total = 0
				stats.each {|s|
					total += s.wins
					@chart2.set_value(x, 0, year.to_s)
					@chart2.set_value(x, y, total)
					x += 1
					year += 1
				}
				y += 1
			}
			options2 = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Cumulative Wins", :titleX => "Year in Player's Career", :titleY => "Number of Wins"}
			options2.each_pair do | key, value |
				@chart2.send "#{key}=", value
			end

			@table = GoogleVisualr::Table.new
			@table.add_column('string' , 'Name')
			@table.add_column('string' , 'Bats')
			@table.add_column('string' , 'Wins')
			@table.add_column('string' , 'Losses')
			@table.add_column('string' , 'Earned Runs')
			@table.add_column('string' , 'Strikeouts')
			@table.add_column('string' , 'Saves')
			
			@table.add_rows(@players.size)
			i = 0
				@players.each { |p|
					@table.set_cell(i, 0, "<a href='/players/#{p.id}'>#{p.name}</a>")
					@table.set_cell(i, 1, p.bats)
					@table.set_cell(i, 2, PitchingStat.get_stat_total(p, :wins))
					@table.set_cell(i, 3, PitchingStat.get_stat_total(p, :losses))
					@table.set_cell(i, 4, PitchingStat.get_stat_total(p, :earned_runs))
					@table.set_cell(i, 5, PitchingStat.get_stat_total(p, :strikeouts))
					@table.set_cell(i, 6, PitchingStat.get_stat_total(p, :saves))
					i += 1
				}

			options = { :width => '100%', :allowHtml=>true }
			options.each_pair do | key, value |
				@table.send "#{key}=", value
			end
		end
	end
	
	def multi_compare
		@pitchers, @max, @years = PitchingStat.multi_compare(params[:comp])
		if @pitchers.empty?	
			flash[:notice] = "One or more of the players you have chosen do not have pitching statistics available. Please select different players."
			redirect_to :back
		else
			@player = []
			@players = []
			@pitchers.each_value {|value|
				if @player.include?(value)
					else @player.push(value)
				end
			}
			@player.each {|p|
				@players.push(Player.find(p.to_i))
			}
			@strings = []
			l = 0
			@players.each { |p|
				@strings.push(p.name + " from " + @years[l])
				l += 1
			}
			@chart = GoogleVisualr::LineChart.new
			@chart.add_column('string', 'Year')
			i = 0
			@players.each { |play|
				@chart.add_column('number', play.name + ', ' + @years[i])
				i += 1
			}	
			@chart.add_rows(@max)
			y = 1
			@players.each { |play|
			x = 0
			year = 1
			@stats = PitchingStat.get_multi_stats(play.id, @pitchers, :wins)
				@stats.each {|s|
					@chart.set_value(x, 0, year.to_s)
					@chart.set_value(x, y, s)
					x += 1
					year += 1
				}
				y += 1
			}
			options = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Wins Each Year", :titleX => "Year in Player's Span", :titleY => "Number of Wins"}
			options.each_pair do | key, value |
				@chart.send "#{key}=", value
			end
			
			@chart2 = GoogleVisualr::LineChart.new
			@chart2.add_column('string', 'Year')
			i = 0
			@players.each { |play|
				@chart2.add_column('number', play.name + ', ' + @years[i])
				i += 1
			}	
			@chart2.add_rows(@max)
			y = 1
			@players.each { |play|
			x = 0
			year = 1
			stats = PitchingStat.get_multi_stats(play.id, @pitchers, :wins)
			total = 0
				stats.each {|s|
					total += s
					@chart2.set_value(x, 0, year.to_s)
					@chart2.set_value(x, y, total)
					x += 1
					year += 1
				}
				y += 1
			}
			options2 = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Cumulative Wins", :titleX => "Year in Player's Span", :titleY => "Number of Wins"}
			options2.each_pair do | key, value |
				@chart2.send "#{key}=", value
			end
			
			@table = GoogleVisualr::Table.new
			@table.add_column('string' , 'Name')
			@table.add_column('string' , 'Bats')
			@table.add_column('string' , 'Wins')
			@table.add_column('string' , 'Losses')
			@table.add_column('string' , 'Earned Runs')
			@table.add_column('string' , 'Strikeouts')
			@table.add_column('string' , 'Saves')
			
			@table.add_rows(@players.size)
			i = 0
				@players.each { |p|
					@table.set_cell(i, 0, "<a href='/players/#{p.id}'>#{p.name}</a>")
					@table.set_cell(i, 1, p.bats)
					@table.set_cell(i, 2, PitchingStat.get_multi_stat_total(p.id, @pitchers, :wins))
					@table.set_cell(i, 3, PitchingStat.get_multi_stat_total(p.id, @pitchers, :losses))
					@table.set_cell(i, 4, PitchingStat.get_multi_stat_total(p.id, @pitchers, :earned_runs))
					@table.set_cell(i, 5, PitchingStat.get_multi_stat_total(p.id, @pitchers, :strikeouts))
					@table.set_cell(i, 6, PitchingStat.get_multi_stat_total(p.id, @pitchers, :saves))
					i += 1
				}

			options = { :width => '100%', :allowHtml=>true }
			options.each_pair do | key, value |
				@table.send "#{key}=", value
			end
		end
	end
	
	def change_career_chart
		stat = params[:chart_type].downcase.gsub(" ", "_")
		@player = params[:players]
		@players = []
		@max = []
		@player.each {|p|
			@players.push(Player.find(p.to_i))
			@max.push(BattingStat.find(:all, :select => [:team_id], :conditions => ['player_id =?', p]).size)
		}
		@chart = GoogleVisualr::LineChart.new
		@chart.add_column('string', 'Year')
		@players.each { |play|
			@chart.add_column('number', play.name)
		}	
		@chart.add_rows(@max.max)
		y = 1
		@players.each { |play|
		x = 0
		year = 1
		stats = PitchingStat.get_all_stats(play.id, stat.to_sym)
			stats.each {|s|
				@chart.set_value(x, 0, year.to_s)
				@chart.set_value(x, y, s.send(stat))
				x += 1
				year += 1
			}
			y += 1
		}
		options = { :width => '45%', :height => 300, :legend => 'bottom', :title => stat.titleize + " Each Year", :titleX => "Year in Player's Career", :titleY => "Number of " + stat.titleize}
		options.each_pair do | key, value |
			@chart.send "#{key}=", value
		end
		
		@chart2 = GoogleVisualr::LineChart.new
		@chart2.add_column('string', 'Year')
		@players.each { |play|
			@chart2.add_column('number', play.name)
		}	
		@chart2.add_rows(@max.max)
		y = 1
		@players.each { |play|
		x = 0
		year = 1
		stats = PitchingStat.get_all_stats(play.id, stat.to_sym)
		total = 0
			stats.each {|s|
				total += s.send(stat)
				@chart2.set_value(x, 0, year.to_s)
				@chart2.set_value(x, y, total)
				x += 1
				year += 1
			}
			y += 1
		}
		options2 = { :width => '45%', :height => 300, :legend => 'bottom', :title => "Cumulative " + stat.titleize, :titleX => "Year in Player's Career", :titleY => "Number of " + stat.titleize}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end
		
		render :partial => "chart"
    end
	
	def change_multi_chart
		stat = params[:chart_type].downcase.gsub(" ", "_")
		@player = params[:players]
		@pitchers= params[:pitchers]
		@max = params[:max]
		@years = params[:years]
		@players = []
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		@chart = GoogleVisualr::LineChart.new
		@chart.add_column('string', 'Year')
		i = 0
		@players.each { |play|
			@chart.add_column('number', play.name + ', ' + @years[i])
			i += 1
		}	
		@chart.add_rows(@max)
		y = 1
		@players.each { |play|
		x = 0
		year = 1
		stats = PitchingStat.get_change_multi_stats(play.id, @pitchers, stat.to_sym)
			stats.each {|s|
				@chart.set_value(x, 0, year.to_s)
				@chart.set_value(x, y, s)
				x += 1
				year += 1
			}
			y += 1
		}
		options = { :width => '45%', :height => 300, :legend => 'bottom', :title => stat.titleize + " Each Year", :titleX => "Year in Player's Span", :titleY => "Number of " + stat.titleize}
		options.each_pair do | key, value |
			@chart.send "#{key}=", value
		end
		
		@chart2 = GoogleVisualr::LineChart.new
		@chart2.add_column('string', 'Year')
		@players.each { |play|
			@chart2.add_column('number', play.name)
		}	
		@chart2.add_rows(@max)
		y = 1
		@players.each { |play|
		x = 0
		year = 1
		total = 0
		stats = PitchingStat.get_change_multi_stats(play.id, @pitchers, stat.to_sym)
			stats.each {|s|
				total += s
				@chart2.set_value(x, 0, year.to_s)
				@chart2.set_value(x, y, total)
				x += 1
				year += 1
			}
			y += 1
		}
		options2 = { :width => '45%', :height => 300, :legend => 'bottom', :title => "Cumulative " + stat.titleize, :titleX => "Year in Player's Span", :titleY => "Number of " + stat.titleize}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end
		
		render :partial => "chart"
    end
	
	def change_career_table
		stats = params[:stat]
		@player = params[:players]
		@players = []
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		stats.each {|s|
			@table.add_column('string' , s.titleize)
		}
		@table.add_rows(@players.size)
		i = 0
		
			@players.each { |p|
				@table.set_cell(i, 0, "<a href='/players/#{p.id}'>#{p.name}</a>")
				@table.set_cell(i, 1, p.bats)
				j = 2
				stats.each { |s|
					@table.set_cell(i, j, PitchingStat.get_stat_total(p, s.to_sym))
					j += 1
				}
				i += 1
			}

		options = { :width => '100%', :allowHtml => true}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
		
		render :partial => "table"
	end
	
	def change_multi_table
		stats = params[:stat]
		@player = params[:players]
		@pitchers= params[:pitchers]
		@players = []
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		stats.each {|s|
			if s == 'rbi'
				@table.add_column('string' , s.upcase)
			else @table.add_column('string' , s.titleize)
			end
		}
		@table.add_rows(@players.size)
		i = 0
		
			@players.each { |p|
				@table.set_cell(i, 0, "<a href='/players/#{p.id}'>#{p.name}</a>")
				@table.set_cell(i, 1, p.bats)
				j = 2
				stats.each { |s|
					@table.set_cell(i, j, PitchingStat.get_change_multi_stat_total(p.id, @pitchers, s.to_sym))
					j += 1
				}
				i += 1
			}

		options = { :width => '100%', :allowHtml => true}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
		
		render :partial => "table"
	end

  def season_finder

  end

  def find_seasons
    number = params[:fields][:count].to_i
    @stats = []
    operations = []
    (1..number).each do |i|
      stat = params["#{i}"][:stat]
      next if stat.blank?
      operator = params["#{i}"][:operator]
      number = params["#{i}"][:number]
	  if number.to_i < 0
		flash[:notice] = 'At least one of your values was invalid. Please try again.'
		redirect_to :back
	  end
      string = stat.downcase.gsub(" ", "_") + " " + operator + " " + number
      @stats.push(stat)
      operations.push(string)

    end
    if @stats.size == 0
      flash[:notice] = 'You must select at least one stat.'
      redirect_to :back
      @batting_stats = Array.new
    elsif params[:postseason].nil?
      @batting_stats = BattingStat.where(operations.join(" AND "))
    else
      @batting_stats = BattingPostStat.where(operations.join(" AND "))
    end
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('string' , 'Name')
    @chart2.add_column('string' , 'Throws')
		@chart2.add_column('string' , 'Team')
		@chart2.add_column('string' , 'Year')
    @stats.each do |i|
     @chart2.add_column('number' , i.titleize)
    end
    @chart2.add_rows(@batting_stats.size)
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
			@chart2.set_cell(i, 0, "<a href='/players/#{b.player.id}'>#{b.player.name}</a>")
      @chart2.set_cell(i, 1, b.player.throws.to_s)
			@chart2.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
      @chart2.set_cell(i, 3, b.team.year.to_s)
      k=4
    @stats.each do |j|
     number= b.send(j.downcase.gsub(" ", "_"))
     @chart2.set_value(i, k, number)
     k+=1
    end
    }
    options = { :width => 600, :allowHtml=>true  }
    options.each_pair do | key, value |
    @chart2.send "#{key}=", value
    @operations = operations
  end

  end
	
end
