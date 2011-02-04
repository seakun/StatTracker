class DivisionsController < ApplicationController
  def index
    @divisions = Division.all
  end

  def show
    @division = Division.find(params[:id])
  end

  def new
    @division = Division.new
  end

  def create
    @division = Division.new(params[:division])
    if @division.save
      flash[:notice] = "Successfully created division."
      redirect_to @division
    else
      render :action => 'new'
    end
  end

  def edit
    @division = Division.find(params[:id])
  end

  def update
    @division = Division.find(params[:id])
    if @division.update_attributes(params[:division])
      flash[:notice] = "Successfully updated division."
      redirect_to division_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @division = Division.find(params[:id])
    @division.destroy
    flash[:notice] = "Successfully destroyed division."
    redirect_to divisions_url
  end
end
