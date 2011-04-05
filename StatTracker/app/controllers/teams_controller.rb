class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    @google_image = GoogleImage.all(@team.name+" logo wiki", 0).first
    @chart = GoogleVisualr::Table.new
		@chart.add_column('string' , 'Rank')
		@chart.add_column('string' , 'G')
		@chart.add_column('string' , 'Home Games')
		@chart.add_column('string' , 'W')
		@chart.add_column('string' , 'L')
		@chart.add_column('string' , 'Div Win')
    @chart.add_column('string' , 'Wc Win')
    @chart.add_column('string' , 'Lg Win')
    @chart.add_column('string' , 'Ws Win')
    @chart2 = GoogleVisualr::Table.new
    @chart2.add_column('string' , 'R')
    @chart2.add_column('string' , 'PA')
    @chart2.add_column('string' , 'AB')
    @chart2.add_column('string' , 'H')
    @chart2.add_column('string' , '2B')
    @chart2.add_column('string' , '3B')
    @chart2.add_column('string' , 'HR')
    @chart2.add_column('string' , 'TB')
    @chart2.add_column('string' , 'EBH')
    @chart2.add_column('string' , 'PA')
    @chart2.add_column('string' , 'BB')
    @chart2.add_column('string' , 'K')
    @chart2.add_column('string' , 'SB')
    @chart2.add_column('string' , 'SB')
    @chart2.add_column('string' , 'HBP')
    @chart2.add_column('string' , 'SF')
    @chart2.add_column('string' , 'BPF')
    @chart3 = GoogleVisualr::Table.new
    @chart3.add_column('string' , 'RA')
    @chart3.add_column('string' , 'ER')
    @chart3.add_column('string' , 'CG')
    @chart3.add_column('string' , 'SHO')
    @chart3.add_column('string' , 'SV')
    @chart3.add_column('string' , 'IPO')
    @chart3.add_column('string' , 'H')
    @chart3.add_column('string' , 'HR')
    @chart3.add_column('string' , 'BB')
    @chart3.add_column('string' , 'K')
    @chart3.add_column('string' , 'PPF')
    @chart3.add_column('string' , 'E')
    @chart3.add_column('string' , 'DP')
    @chart3.add_column('string' , 'FPCT')

    @chart.add_rows(1);
    @chart2.add_rows(1);
    @chart3.add_rows(1);

    @chart.set_cell(0, 0,	@team.rank.to_s)
    @chart.set_cell(0, 1, @team.games.to_s)
    @chart.set_cell(0, 2, @team.home_games.to_s)
    @chart.set_cell(0, 3, @team.wins.to_s)
    @chart.set_cell(0, 4, @team.losses.to_s)
    @chart.set_cell(0, 5, @team.div_win.to_s)
	  @chart.set_cell(0, 6, @team.wc_win.to_s)
	  @chart.set_cell(0, 7, @team.lg_win.to_s)
	  @chart.set_cell(0, 8, @team.ws_win.to_s)

    @chart2.set_cell(0, 0, @team.runs.to_s)
    @chart2.set_cell(0, 1, @team.plate_appearances.to_s)
    @chart2.set_cell(0, 2, @team.at_bats.to_s)
    @chart2.set_cell(0, 3, @team.hits.to_s)
    @chart2.set_cell(0, 4, @team.doubles.to_s)
    @chart2.set_cell(0, 5, @team.triples.to_s)
	  @chart2.set_cell(0, 6, @team.home_runs.to_s)
	  @chart2.set_cell(0, 7, @team.total_bases.to_s)
	  @chart2.set_cell(0, 8, @team.extra_base_hits.to_s)
    @chart2.set_cell(0, 9, @team.plate_appearances.to_s)
    @chart2.set_cell(0, 10, @team.walks.to_s)
    @chart2.set_cell(0, 11, @team.strikeouts.to_s)
    @chart2.set_cell(0, 12, @team.stolen_bases.to_s)
    @chart2.set_cell(0, 13, @team.caught_stealing.to_s)
	  @chart2.set_cell(0, 14, @team.hit_by_pitch.to_s)
	  @chart2.set_cell(0, 15, @team.sacrifice_flies.to_s)
    @chart2.set_cell(0, 16, @team.batters_park_factor.to_s)

    @chart3.set_cell(0, 0, @team.runs_allowed.to_s)
    @chart3.set_cell(0, 1, @team.earned_runs.to_s)
    @chart3.set_cell(0, 2, @team.complete_games.to_s)
    @chart3.set_cell(0, 3, @team.shutouts.to_s)
    @chart3.set_cell(0, 4, @team.saves.to_s)
    @chart3.set_cell(0, 5, @team.innings_pitched_outs.to_s)
	  @chart3.set_cell(0, 6, @team.hits_allowed.to_s)
	  @chart3.set_cell(0, 7, @team.home_runs_allowed.to_s)
	  @chart3.set_cell(0, 8, @team.walks_allowed.to_s)
    @chart3.set_cell(0, 9, @team.strikeouts_allowed.to_s)
    @chart3.set_cell(0, 10, @team.pitchers_park_factor.to_s)
    @chart3.set_cell(0, 11, @team.errors_made.to_s)
    @chart3.set_cell(0, 12, @team.double_plays.to_s)
    @chart3.set_cell(0, 13, @team.fielding_percentage.to_s)
    options = { :width => 900}
		options.each_pair do | key, value |
			@chart.send "#{key}=", value
      @chart2.send "#{key}=", value
      @chart3.send "#{key}=", value
		end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      flash[:notice] = "Successfully created team."
      redirect_to @team
    else
      render :action => 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:notice] = "Successfully updated team."
      redirect_to team_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    flash[:notice] = "Successfully destroyed team."
    redirect_to teams_url
  end

  
end
