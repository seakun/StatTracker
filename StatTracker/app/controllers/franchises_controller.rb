class FranchisesController < ApplicationController
  def index
    @franchises = Franchise.all
  end

  def show
    @franchise = Franchise.find(params[:id])
    @teams= Team.find(:all, :conditions => ['franchise_id = ?', params[:id]])
    @chart = GoogleVisualr::Table.new
		@chart.add_column('number' , 'Year')
		@chart.add_column('string' , 'Team')
		@chart.add_column('string' , 'League')
		@chart.add_column('number' , 'Wins')
		@chart.add_column('number' , 'Losses')
    @chart.add_column('number' , 'AB')
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
