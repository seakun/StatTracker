class PitchingStatsController < ApplicationController
  def index
    @pitching_stats = PitchingStat.all
  end

  def show
    @pitching_stat = PitchingStat.find(params[:id])
  end

  def new
    @pitching_stat = PitchingStat.new
  end

  def create
    @pitching_stat = PitchingStat.new(params[:pitching_stat])
    if @pitching_stat.save
      flash[:notice] = "Successfully created pitching stat."
      redirect_to @pitching_stat
    else
      render :action => 'new'
    end
  end

  def edit
    @pitching_stat = PitchingStat.find(params[:id])
  end

  def update
    @pitching_stat = PitchingStat.find(params[:id])
    if @pitching_stat.update_attributes(params[:pitching_stat])
      flash[:notice] = "Successfully updated pitching stat."
      redirect_to pitching_stat_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @pitching_stat = PitchingStat.find(params[:id])
    @pitching_stat.destroy
    flash[:notice] = "Successfully destroyed pitching stat."
    redirect_to pitching_stats_url
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
			@table.set_cell(i, 0, b.player.name)
			# @table.set_cell(i, 1, b.player.throws)
			@table.set_cell(i, 2, b.team.name)
			@table.set_cell(i, 3, "#{b.year}")
			@table.set_cell(i, 4, b.send(params[:stat]))
		}
		
		options = { :width => 600, :showRowNumber => true }
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
				@table.set_cell(i, 0, k.name)
				# @table.set_cell(i, 1, k.throws)
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true }
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
				@table.set_cell(i, 0, k.name)
				# @table.set_cell(i, 1, k.throws)
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true }
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
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		@chart = GoogleVisualr::LineChart.new
		@chart.add_column('string', 'Year')
		@players.each { |play|
			@chart.add_column('number', play.name)
		}	
		@chart.add_rows(25)
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
		options = { :width => 600, :height => 300, :legend => 'bottom'}
		options.each_pair do | key, value |
			@chart.send "#{key}=", value
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
				@table.set_cell(i, 0, p.name)
				@table.set_cell(i, 1, p.bats)
				@table.set_cell(i, 2, PitchingStat.get_stat_total(p, :wins))
				@table.set_cell(i, 3, PitchingStat.get_stat_total(p, :losses))
				@table.set_cell(i, 4, PitchingStat.get_stat_total(p, :earned_runs))
				@table.set_cell(i, 5, PitchingStat.get_stat_total(p, :strikeouts))
				@table.set_cell(i, 6, PitchingStat.get_stat_total(p, :saves))
				i += 1
			}

		options = { :width => '80%'}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def change_chart
		stat = params[:chart_type].downcase.gsub(" ", "_")
		@player = params[:players]
		@players = []
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		@chart = GoogleVisualr::LineChart.new
		@chart.add_column('string', 'Year')
		@players.each { |play|
			@chart.add_column('number', play.name)
		}	
		@chart.add_rows(25)
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
		options = { :width => 600, :height => 300, :legend => 'bottom'}
		options.each_pair do | key, value |
			@chart.send "#{key}=", value
		end
		
		respond_to do |format|
			format.js { render :layout=>false }
		end
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
			@table.add_column('string' , s.titleize)
		}
		@table.add_rows(@players.size)
		i = 0
		
			@players.each { |p|
				@table.set_cell(i, 0, p.name)
				@table.set_cell(i, 1, p.bats)
				j = 2
				stats.each { |s|
					@table.set_cell(i, j, PitchingStat.get_stat_total(p, s.to_sym))
					j += 1
				}
				i += 1
			}

		options = { :width => '80%'}
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
		
		respond_to do |format|
			format.js { render :layout=>false }
		end
	end
	
end
