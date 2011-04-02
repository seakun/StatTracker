class BattingStatsController < ApplicationController
  def index
    @batting_stats = BattingStat.all
  end

  def show
    @batting_stat = BattingStat.find(params[:id])
  end

  def new
    @batting_stat = BattingStat.new
  end

  def create
    @batting_stat = BattingStat.new(params[:batting_stat])
    if @batting_stat.save
      flash[:notice] = "Successfully created batting stat."
      redirect_to @batting_stat
    else
      render :action => 'new'
    end
  end

  def edit
    @batting_stat = BattingStat.find(params[:id])
  end

  def update
    @batting_stat = BattingStat.find(params[:id])
    if @batting_stat.update_attributes(params[:batting_stat])
      flash[:notice] = "Successfully updated batting stat."
      redirect_to batting_stat_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @batting_stat = BattingStat.find(params[:id])
    @batting_stat.destroy
    flash[:notice] = "Successfully destroyed batting stat."
    redirect_to batting_stats_url
  end
  
	def single_season
		@batting_stats = BattingStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@batting_stats.each { |b|
			i = @batting_stats.index(b)
			@table.set_cell(i, 0, b.player.name)
			@table.set_cell(i, 1, b.player.bats)
			@table.set_cell(i, 2, b.team.name)
			@table.set_cell(i, 3, "#{b.year}")
			@table.set_cell(i, 4, "#{b.send(params[:stat])}")
		}
		
		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end	
	end
  
	def career
		@batting_stats = BattingStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@batting_stats.each { |k, v|
				@table.set_cell(i, 0, k.name)
				@table.set_cell(i, 1, k.bats)
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
  
    def active
		@batting_stats = BattingStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@batting_stats.each { |k, v|
				@table.set_cell(i, 0, k.name)
				@table.set_cell(i, 1, k.bats)
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def season_compare
		@batters = BattingStat.season_compare(params[:comp])
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
		options = { :width => '100%', :height => 300, :legend => 'bottom'}
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
		options2 = { :width => '100%', :height => 300, :legend => 'bottom'}
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
				@table.set_cell(i, 0, p.name)
				@table.set_cell(i, 1, p.bats)
				@table.set_cell(i, 2, BattingStat.get_stat_total(p, :runs))
				@table.set_cell(i, 3, BattingStat.get_stat_total(p, :hits))
				@table.set_cell(i, 4, BattingStat.get_stat_total(p, :home_runs))
				@table.set_cell(i, 5, BattingStat.get_stat_total(p, :rbi))
				@table.set_cell(i, 6, BattingStat.get_stat_total(p, :stolen_bases))
				i += 1
			}

		options = { :width => '100%'}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def change_chart
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
		options = { :width => '45%', :height => 300, :legend => 'bottom'}
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
		options2 = { :width => '45%', :height => 300, :legend => 'bottom'}
		options2.each_pair do | key, value |
			@chart2.send "#{key}=", value
		end
		
		render :partial => "chart"
		
    end
	
	def change_table
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
				@table.set_cell(i, 0, p.name)
				@table.set_cell(i, 1, p.bats)
				j = 2
				stats.each { |s|
					@table.set_cell(i, j, BattingStat.get_stat_total(p, s.to_sym))
					j += 1
				}
				i += 1
			}

		options = { :width => '80%'}
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
      string = stat + " " + operator + " " + number
      @stats.push(stat)
      operations.push(string)
    end
    @batting_stats = BattingStat.where(operations.join(" AND "))
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('string' , 'Name')
		@chart2.add_column('string' , 'Team')
		@chart2.add_column('number' , 'Year')
    @stats.each do |i|
     @chart2.add_column('number' , i.titleize)
    end
    @chart2.add_rows(@batting_stats.size)
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
			@chart2.set_cell(i, 0, b.player.name)
			@chart2.set_cell(i, 1, b.team.name)
      @chart2.set_cell(i, 2, b.team.year)
      k=3
    @stats.each do |j|
     number= b.send(j)
     @chart2.set_value(i, k, number)
     k+=1
    end
    }
    options = { :width => 600 }
    options.each_pair do | key, value |
    @chart2.send "#{key}=", value
  end

  end

end
