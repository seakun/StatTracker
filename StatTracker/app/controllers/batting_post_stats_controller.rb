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
	@batting_post_stats = BattingPostStat.single_season_sort
  end
  
end
