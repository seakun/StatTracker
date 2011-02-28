class FieldingPostStatsController < ApplicationController
  def index
    @fielding_post_stats = FieldingPostStat.all
  end

  def show
    @fielding_post_stat = FieldingPostStat.find(params[:id])
  end

  def new
    @fielding_post_stat = FieldingPostStat.new
  end

  def create
    @fielding_post_stat = FieldingPostStat.new(params[:fielding_post_stat])
    if @fielding_post_stat.save
      flash[:notice] = "Successfully created fielding post stat."
      redirect_to @fielding_post_stat
    else
      render :action => 'new'
    end
  end

  def edit
    @fielding_post_stat = FieldingPostStat.find(params[:id])
  end

  def update
    @fielding_post_stat = FieldingPostStat.find(params[:id])
    if @fielding_post_stat.update_attributes(params[:fielding_post_stat])
      flash[:notice] = "Successfully updated fielding post stat."
      redirect_to fielding_post_stat_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @fielding_post_stat = FieldingPostStat.find(params[:id])
    @fielding_post_stat.destroy
    flash[:notice] = "Successfully destroyed fielding post stat."
    redirect_to fielding_post_stats_url
  end
  
	def single_season
		@fielding_post_stats = FieldingPostStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@fielding_post_stats.each { |b|
			i = @fielding_post_stats.index(b)
			@table.set_cell(i, 0, b.player.name)
			# @table.set_cell(i, 1, b.player.throws)
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
		@fielding_post_stats = FieldingPostStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@fielding_post_stats.each { |k, v|
				@table.set_cell(i, 0, k.name)
				# @table.set_cell(i, 1, k.throws
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
  
	def active
		@fielding_post_stats = FieldingPostStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@fielding_post_stats.each { |k, v|
				@table.set_cell(i, 0, k.name)
				# @table.set_cell(i, 1, k.throws)
				@table.set_cell(i, 2, "#{v}")
				i+= 1
			}

		options = { :width => 600, :showRowNumber => true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
end
