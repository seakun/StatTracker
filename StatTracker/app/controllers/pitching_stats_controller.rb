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
	
end
