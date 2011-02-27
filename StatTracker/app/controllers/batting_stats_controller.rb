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
		@table.add_column('number' , 'Year')
		@table.add_column('number' , params[:stat].titleize)
		@table.add_rows(50)
		@batting_stats.each { |b|
			i = @batting_stats.index(b)
			@table.set_cell(i, 0, b.player.name)
			@table.set_cell(i, 1, b.player.bats)
			@table.set_cell(i, 2, b.team.name)
			@table.set_cell(i, 3, b.year)
			@table.set_cell(i, 4, b.send(params[:stat]))
		}
		
		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
  
	def career
		@batting_stats = BattingStat.career_sort(params[:stat])
	end
  
    def active
		@batting_stats = BattingStat.active_sort(params[:stat])
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
		@player.each {|p|
			@players.push(Player.find(p.to_i))
		}
		puts @players
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
  end

end
