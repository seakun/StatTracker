class FranchisesController < ApplicationController
  def index
    @franchises = Franchise.all
  end

  def show
    @franchise = Franchise.find(params[:id])
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
