class BattingStatsController < ApplicationController
  def index
    @batting_stats = BattingStat.all
  end

  def show
    @batting_stat = BattingStat.find(params[:id])
  end

	def single_season
		@batting_stats = BattingStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		if params[:stat] == 'rbi'
			@table.add_column('string' , params[:stat].upcase)
		else @table.add_column('string' , params[:stat].titleize)
		end
		@table.add_rows(50)
		@batting_stats.each { |b|
			i = @batting_stats.index(b)
			@table.set_cell(i, 0, "<a href='/players/#{b.player.id}'>#{b.player.name}</a>")
			if !b.player.bats.nil?
				@table.set_cell(i, 1, b.player.bats)
			else @table.set_cell(i, 1, 'N/A')
			end
			@table.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
			@table.set_cell(i, 3, "#{b.year}")
			@table.set_cell(i, 4, "#{b.send(params[:stat])}")
		}
		
		options = { :width => 600, :showRowNumber => true, :allowHtml => true, :page => 'enable', :pageSize => '25' }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end	
	end
  
	def career
		@batting_stats = BattingStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		if params[:stat] == 'rbi'
			@table.add_column('string' , params[:stat].upcase)
		else @table.add_column('string' , params[:stat].titleize)
		end
		@table.add_rows(50)
		i = 0
			if BattingStat.accessible_attributes.include?(params[:stat])
				@batting_stats.each { |k, v|
					@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
					if !k.bats.nil?
						@table.set_cell(i, 1, k.bats)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{v}")
					i += 1
				}
			else 
				@batting_stats.each { |b|
					@table.set_cell(i, 0, "<a href='/players/#{b.id}'>#{b.name}</a>")
					if !b.bats.nil?
						@table.set_cell(i, 1, b.bats)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{b.send("career_" + params[:stat])}")
					i += 1
				}
			end
		options = { :width => 600, :showRowNumber => true, :allowHtml =>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
  
    def active
		@batting_stats = BattingStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		if params[:stat] == 'rbi'
			@table.add_column('string' , params[:stat].upcase)
		else @table.add_column('string' , params[:stat].titleize)
		end
		@table.add_rows(50)
		i = 0
			if BattingStat.accessible_attributes.include?(params[:stat])
				@batting_stats.each { |k, v|
					@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
					if !k.bats.nil?
						@table.set_cell(i, 1, k.bats)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{v}")
					i += 1
				}
			else 
				@batting_stats.each { |b|
					@table.set_cell(i, 0, "<a href='/players/#{b.id}'>#{b.name}</a>")
					if !b.bats.nil?
						@table.set_cell(i, 1, b.bats)
					else @table.set_cell(i, 1, 'N/A')
					end
					@table.set_cell(i, 2, "#{b.send("career_" + params[:stat])}")
					i += 1
				}
			end	

		options = { :width => 600, :showRowNumber => true, :allowHtml=>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def season_compare
		@batters = BattingStat.season_compare(params[:comp])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , 'Age')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'League')
		@table.add_column('string' , 'G')
		@table.add_column('string' , 'PA')
		@table.add_column('string' , 'AB')
		@table.add_column('string' , 'R')
		@table.add_column('string' , 'H')
		@table.add_column('string' , '2B')
		@table.add_column('string' , '3B')
		@table.add_column('string' , 'HR')
		@table.add_column('string' , 'RBI')
		@table.add_column('string' , 'TB')
		@table.add_column('string' , 'SB')
		@table.add_column('string' , 'CS')
		@table.add_column('string' , 'BB')
		@table.add_column('string' , 'K')
		@table.add_column('string' , 'AVG')
		@table.add_column('string' , 'OBP')
		@table.add_column('string' , 'SLG')
		@table.add_column('string' , 'OPS')
		@table.add_rows(@batters.size)
		i = 0
		@batters.each {|b|
			@table.set_cell(i, 0, "<a href='/players/#{b[0].player_id}'>#{b[0].player.name}</a>")
			if !b[0].player.bats.nil?
				@table.set_cell(i, 1, b[0].player.bats.to_s)
			else @table.set_cell(i, 1, 'N/A')
			end
			@table.set_cell(i, 2, b[0].team.year.to_s)
			@table.set_cell(i, 3, b[0].player.age(b[0].team.year).to_s)
			@table.set_cell(i, 4, "<a href='/teams/#{b[0].team.id}'>#{b[0].team.name}</a>")
			@table.set_cell(i, 5, b[0].team.division.league.abbrev.to_s)
			@table.set_cell(i, 6, b[0].games.to_s)
			@table.set_cell(i, 7, b[0].plate_appearances.to_s)
			@table.set_cell(i, 8, b[0].at_bats.to_s)
			@table.set_cell(i, 9, b[0].runs.to_s)
			@table.set_cell(i, 10, b[0].hits.to_s)
			@table.set_cell(i, 11, b[0].doubles.to_s)
			@table.set_cell(i, 12, b[0].triples.to_s)
			@table.set_cell(i, 13, b[0].home_runs.to_s)
			@table.set_cell(i, 14, b[0].rbi.to_s)
			@table.set_cell(i, 15, b[0].total_bases.to_s)
			@table.set_cell(i, 16, b[0].stolen_bases.to_s)
			@table.set_cell(i, 17, b[0].caught_stealing.to_s)
			@table.set_cell(i, 18, b[0].walks.to_s)
			@table.set_cell(i, 19, b[0].strikeouts.to_s)
			@table.set_cell(i, 20, b[0].batting_average.to_s)
			@table.set_cell(i, 21, b[0].on_base_percentage.to_s)
			@table.set_cell(i, 22, b[0].slugging_percentage.to_s)
			@table.set_cell(i, 23, b[0].on_base_plus_slugging.to_s)
			i += 1
		}
		
		options = { :width => '100%', :allowHtml=>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def career_compare
		@batters = BattingStat.career_compare(params[:comp])
		@player = []
		@players = []
		@batters.each_value {|value|
			if @player.include?(value)
			else @player.push(value)
			end
		}
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
		stats = BattingStat.get_all_stats(play.id, :home_runs)
			stats.each {|s|
				@chart.set_value(x, 0, year.to_s)
				@chart.set_value(x, y, s.home_runs)
				x += 1
				year += 1
			}
			y += 1
		}
		options = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Home Runs Each Year", :titleX => "Year in Player's Career", :titleY => "Number of Home Runs"}
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
		stats = BattingStat.get_all_stats(play.id, :home_runs)
		total = 0
			stats.each {|s|
				total += s.home_runs
				@chart2.set_value(x, 0, year.to_s)
				@chart2.set_value(x, y, total)
				x += 1
				year += 1
			}
			y += 1
		}
		options2 = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Progressive Home Run Totals", :titleX => "Year in Player's Career", :titleY => "Number of Home Runs"}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end

		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Runs')
		@table.add_column('string' , 'Hits')
		@table.add_column('string' , 'Home Runs')
		@table.add_column('string' , 'RBI')
		@table.add_column('string' , 'Stolen Bases')
		
		@table.add_rows(@players.size)
		i = 0
			@players.each { |p|
				@table.set_cell(i, 0, "<a href='/players/#{p.id}'>#{p.name}</a>")
				@table.set_cell(i, 1, p.bats)
				@table.set_cell(i, 2, BattingStat.get_stat_total(p, :runs))
				@table.set_cell(i, 3, BattingStat.get_stat_total(p, :hits))
				@table.set_cell(i, 4, BattingStat.get_stat_total(p, :home_runs))
				@table.set_cell(i, 5, BattingStat.get_stat_total(p, :rbi))
				@table.set_cell(i, 6, BattingStat.get_stat_total(p, :stolen_bases))
				i += 1
			}

		options = { :width => '100%', :allowHtml => true}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def multi_compare
		@batters, @max = BattingStat.multi_compare(params[:comp])
		@player = []
		@players = []
		@batters.each_value {|value|
			if @player.include?(value)
				else @player.push(value)
			end
		}
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		@chart = GoogleVisualr::LineChart.new
		@chart.add_column('string', 'Year')
		@players.each { |play|
			@chart.add_column('number', play.name)
		}	
		@chart.add_rows(@max)
		y = 1
		@players.each { |play|
		x = 0
		year = 1
		@stats = BattingStat.get_multi_stats(play.id, @batters, :home_runs)
			@stats.each {|s|
				@chart.set_value(x, 0, year.to_s)
				@chart.set_value(x, y, s)
				x += 1
				year += 1
			}
			y += 1
		}
		options = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Home Runs Each Year", :titleX => "Year in Player's Span", :titleY => "Number of Home Runs"}
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
		stats = BattingStat.get_multi_stats(play.id, @batters, :home_runs)
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
		options2 = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Progressive Home Run Totals", :titleX => "Year in Player's Span", :titleY => "Number of Home Runs"}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end

		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Runs')
		@table.add_column('string' , 'Hits')
		@table.add_column('string' , 'Home Runs')
		@table.add_column('string' , 'RBI')
		@table.add_column('string' , 'Stolen Bases')
		
		@table.add_rows(@players.size)
		i = 0
			@players.each { |play|
				@table.set_cell(i, 0, "<a href='/players/#{play.id}'>#{play.name}</a>")
				@table.set_cell(i, 1, play.bats)
				@table.set_cell(i, 2, BattingStat.get_multi_stat_total(play.id, @batters, :runs))
				@table.set_cell(i, 3, BattingStat.get_multi_stat_total(play.id, @batters, :hits))
				@table.set_cell(i, 4, BattingStat.get_multi_stat_total(play.id, @batters, :home_runs))
				@table.set_cell(i, 5, BattingStat.get_multi_stat_total(play.id, @batters, :rbi))
				@table.set_cell(i, 6, BattingStat.get_multi_stat_total(play.id, @batters, :stolen_bases))
				i += 1
			}

		options = { :width => '100%', :allowHtml => true}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
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
		stats = BattingStat.get_all_stats(play.id, stat.to_sym)
			stats.each {|s|
				@chart.set_value(x, 0, year.to_s)
				@chart.set_value(x, y, s.send(stat))
				x += 1
				year += 1
			}
			y += 1
		}
		if stat.titleize == 'Rbi'
			str_stat = stat.titleize.upcase
		else str_stat = stat.titleize
		end
		options = { :width => '45%', :height => 300, :legend => 'bottom', :title => str_stat + " Each Year", :titleX => "Year in Player's Career", :titleY => "Number of " + str_stat}
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
		stats = BattingStat.get_all_stats(play.id, stat.to_sym)
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
		options2 = { :width => '45%', :height => 300, :legend => 'bottom', :title => "Progressive " + str_stat + " Totals", :titleX => "Year in Player's Career", :titleY => "Number of " + str_stat}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end
		
		render :partial => "chart"
    end
	
	def change_multi_chart
		stat = params[:chart_type].downcase.gsub(" ", "_")
		@player = params[:players]
		@batters= params[:batters]
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
		stats = BattingStat.get_change_multi_stats(play.id, @batters, stat.to_sym)
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
		@chart2.add_rows(@max.max)
		y = 1
		@players.each { |play|
		x = 0
		year = 1
		total = 0
		stats = BattingStat.get_change_multi_stats(play.id, @batters, stat.to_sym)
			stats.each {|s|
				total += s
				@chart2.set_value(x, 0, year.to_s)
				@chart2.set_value(x, y, total)
				x += 1
				year += 1
			}
			y += 1
		}
		options2 = { :width => '45%', :height => 300, :legend => 'bottom', :title => "Progressive " + stat.titleize + " Totals", :titleX => "Year in Player's Span", :titleY => "Number of " + stat.titleize}
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
					@table.set_cell(i, j, BattingStat.get_stat_total(p, s.to_sym))
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
		@batters= params[:batters]
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
					@table.set_cell(i, j, BattingStat.get_change_multi_stat_total(p.id, @batters, s.to_sym))
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
      string = stat.downcase.gsub(" ", "_") + " " + operator + " " + number
      @stats.push(stat)
      operations.push(string)

    end
    if params[:postseason].nil?
      @batting_stats = BattingStat.where(operations.join(" AND "))
    else
      @batting_stats = BattingPostStat.where(operations.join(" AND "))
    end
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('string' , 'Name')
    @chart2.add_column('string' , 'Bats')
		@chart2.add_column('string' , 'Team')
    @chart2.add_column('string' , 'Year')
    @stats.each do |i|
     @chart2.add_column('number' , i.titleize)
    end
    @chart2.add_rows(@batting_stats.size)
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
			@chart2.set_cell(i, 0, "<a href='/players/#{b.player.id}'>#{b.player.name}</a>")
      @chart2.set_cell(i, 1, b.player.bats.to_s)
			@chart2.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
      @chart2.set_cell(i, 3, b.team.year.to_s)
      k=4
    @stats.each do |j|
     number= b.send(j.downcase.gsub(" ", "_"))
     @chart2.set_value(i, k, number)
     k+=1
    end
    }
    options = { :width => 600, :allowHtml=>true }
    options.each_pair do | key, value |
    @chart2.send "#{key}=", value
    @operations = operations
  end

  end

end
