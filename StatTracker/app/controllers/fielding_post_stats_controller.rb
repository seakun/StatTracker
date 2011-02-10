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
end
