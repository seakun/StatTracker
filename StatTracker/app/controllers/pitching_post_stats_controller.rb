class PitchingPostStatsController < ApplicationController
  def index
    @pitching_post_stats = PitchingPostStat.all
  end

  def show
    @pitching_post_stat = PitchingPostStat.find(params[:id])
  end

  def new
    @pitching_post_stat = PitchingPostStat.new
  end

  def create
    @pitching_post_stat = PitchingPostStat.new(params[:pitching_post_stat])
    if @pitching_post_stat.save
      flash[:notice] = "Successfully created pitching post stat."
      redirect_to @pitching_post_stat
    else
      render :action => 'new'
    end
  end

  def edit
    @pitching_post_stat = PitchingPostStat.find(params[:id])
  end

  def update
    @pitching_post_stat = PitchingPostStat.find(params[:id])
    if @pitching_post_stat.update_attributes(params[:pitching_post_stat])
      flash[:notice] = "Successfully updated pitching post stat."
      redirect_to pitching_post_stat_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @pitching_post_stat = PitchingPostStat.find(params[:id])
    @pitching_post_stat.destroy
    flash[:notice] = "Successfully destroyed pitching post stat."
    redirect_to pitching_post_stats_url
  end
  
    def single_season
		@pitching_post_stats = PitchingPostStat.single_season_sort(params[:stat])
	end
  
    def career
		@pitching_post_stats = PitchingPostStat.career_sort(params[:stat])
	end
	
	def active
		@pitching_post_stats = PitchingPostStat.active_sort(params[:stat])
	end
	
end
