class FieldingStatsController < ApplicationController
  def index
    @fielding_stats = FieldingStat.all
  end

  def show
    @fielding_stat = FieldingStat.find(params[:id])
  end

  def new
    @fielding_stat = FieldingStat.new
  end

  def create
    @fielding_stat = FieldingStat.new(params[:fielding_stat])
    if @fielding_stat.save
      flash[:notice] = "Successfully created fielding stat."
      redirect_to @fielding_stat
    else
      render :action => 'new'
    end
  end

  def edit
    @fielding_stat = FieldingStat.find(params[:id])
  end

  def update
    @fielding_stat = FieldingStat.find(params[:id])
    if @fielding_stat.update_attributes(params[:fielding_stat])
      flash[:notice] = "Successfully updated fielding stat."
      redirect_to fielding_stat_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @fielding_stat = FieldingStat.find(params[:id])
    @fielding_stat.destroy
    flash[:notice] = "Successfully destroyed fielding stat."
    redirect_to fielding_stats_url
  end
  
	def single_season
		@fielding_stats = FieldingStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@fielding_stats.each { |b|
			i = @fielding_stats.index(b)
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
		@fielding_stats = FieldingStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@fielding_stats.each { |k, v|
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
		@fielding_stats = FieldingStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@fielding_stats.each { |k, v|
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
  
end
