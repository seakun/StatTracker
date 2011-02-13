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
	end
end
