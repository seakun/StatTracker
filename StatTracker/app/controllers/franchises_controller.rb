class FranchisesController < ApplicationController
  def index
    @franchises = Franchise.all
  end

  def show
    @franchise = Franchise.find(params[:id])
    @google_image = GoogleImage.all(@franchise.name+" logo", 0).first
    @teams= Team.find(:all, :conditions => ['franchise_id = ?', params[:id]])
    @chart = GoogleVisualr::Table.new
		@chart.add_column('string' , 'Team')
    @chart.add_column('number' , 'Year')
		@chart.add_column('string' , 'League')
		@chart.add_column('number' , 'Wins')
		@chart.add_column('number' , 'Losses')
    @chart.add_column('number' , 'Rank')
    @chart.add_rows(@teams.size)
    @teams.each { |b|
			i = @teams.index(b)
			@chart.set_cell(i, 0, b.name)
			@chart.set_cell(i, 1, b.year)
      @chart.set_cell(i, 2, b.division.league.name)
      @chart.set_cell(i, 3, b.wins)
      @chart.set_cell(i, 4, b.losses)
      @chart.set_cell(i, 5, b.rank)
    }
    options = { :width => 600 }
    options.each_pair do | key, value |
    @chart.send "#{key}=", value
  end
  end

  def new
    @franchise = Franchise.new
  end

  def create
    @franchise = Franchise.new(params[:franchise])
    if @franchise.save
      flash[:notice] = "Successfully created franchise."
      redirect_to @franchise
    else
      render :action => 'new'
    end
  end

  def edit
    @franchise = Franchise.find(params[:id])
  end

  def update
    @franchise = Franchise.find(params[:id])
    if @franchise.update_attributes(params[:franchise])
      flash[:notice] = "Successfully updated franchise."
      redirect_to franchise_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @franchise = Franchise.find(params[:id])
    @franchise.destroy
    flash[:notice] = "Successfully destroyed franchise."
    redirect_to franchises_url
  end
end
