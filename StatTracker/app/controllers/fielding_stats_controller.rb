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
  end
  
end
