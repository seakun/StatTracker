class BattingPostStatsController < ApplicationController
  def index
    @batting_post_stats = BattingPostStat.all
  end

  def show
    @batting_post_stat = BattingPostStat.find(params[:id])
  end

  def new
    @batting_post_stat = BattingPostStat.new
  end

  def create
    @batting_post_stat = BattingPostStat.new(params[:batting_post_stat])
    if @batting_post_stat.save
      flash[:notice] = "Successfully created batting post stat."
      redirect_to @batting_post_stat
    else
      render :action => 'new'
    end
  end

  def edit
    @batting_post_stat = BattingPostStat.find(params[:id])
  end

  def update
    @batting_post_stat = BattingPostStat.find(params[:id])
    if @batting_post_stat.update_attributes(params[:batting_post_stat])
      flash[:notice] = "Successfully updated batting post stat."
      redirect_to batting_post_stat_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @batting_post_stat = BattingPostStat.find(params[:id])
    @batting_post_stat.destroy
    flash[:notice] = "Successfully destroyed batting post stat."
    redirect_to batting_post_stats_url
  end
  
	def single_season
		@batting_post_stats = BattingPostStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@batting_post_stats.each { |b|
			i = @batting_post_stats.index(b)
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
		@batting_post_stats = BattingPostStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@batting_post_stats.each { |k, v|
				@table.set_cell(i, 0, k.name)
				@table.set_cell(i, 1, k.bats)
				@table.set_cell(i, 2, "#{v}")
				i = i + 1
			}

		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def active
		@batting_post_stats = BattingPostStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@batting_post_stats.each { |k, v|
				@table.set_cell(i, 0, k.name)
				@table.set_cell(i, 1, k.bats)
				@table.set_cell(i, 2, "#{v}")
				i = i + 1
			}

		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
end
