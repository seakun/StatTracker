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
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@pitching_stats.each { |b|
			i = @pitching_stats.index(b)
			puts b.send(params[:stat])
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
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@pitching_stats.each { |k, v|
				@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
				if !k.throws.nil?
					@table.set_cell(i, 1, k.throws)
				else @table.set_cell(i, 1, 'N/A')
				end
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

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
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@pitching_stats.each { |k, v|
				@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
				if !k.throws.nil?
					@table.set_cell(i, 1, k.throws)
				else @table.set_cell(i, 1, 'N/A')
				end
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true, :allowHtml=>true  }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def season_compare
		@pitchers = PitchingStat.season_compare(params[:comp])
	end
	
	def career_compare
		@pitchers = PitchingStat.career_compare(params[:comp])
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
		options2 = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Progressive Win Totals", :titleX => "Year in Player's Career", :titleY => "Number of Wins"}
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
	
	def multi_compare
		@pitchers, @max = PitchingStat.multi_compare(params[:comp])
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
		@players.each { |play|
			@chart2.add_column('number', play.name)
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
		options2 = { :width => '100%', :height => 300, :legend => 'bottom', :title => "Progressive Win Totals", :titleX => "Year in Player's Span", :titleY => "Number of Wins"}
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
		options2 = { :width => '45%', :height => 300, :legend => 'bottom', :title => "Progressive " + stat.titleize + " Totals", :titleX => "Year in Player's Career", :titleY => "Number of " + stat.titleize}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end
		
		render :partial => "chart"
    end
	
	def change_multi_chart
		stat = params[:chart_type].downcase.gsub(" ", "_")
		@player = params[:players]
		@pitchers= params[:pitchers]
		@players = []
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
		@chart2.add_rows(@max.max)
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
      string = stat.downcase.gsub(" ", "_") + " " + operator + " " + number
      @stats.push(stat)
      operations.push(string)

    end
    if params[:postseason].nil?
      @batting_stats = PitchingStat.where(operations.join(" AND "))
    else
      @batting_stats = PitchingPostStat.where(operations.join(" AND "))
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
