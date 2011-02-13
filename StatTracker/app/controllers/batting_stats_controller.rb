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
  end
  
   def career
		@batting_stats = BattingStat.career_sort
	end
  
    def active
		@batting_stats = BattingStat.active_sort
	end
	
end
