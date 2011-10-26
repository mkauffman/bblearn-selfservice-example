class AuthorizationsController < ApplicationController

  
  def index
    @ca_managements     = CAManagement.all
    @institution_roles  = InstitutionRole.all.reverse
  end

  def show
    @authorization = Authorization.find(params[:id])
  end


  def new
    @authorization = Authorization.new
  end

  def edit
    @authorization = Authorization.find(params[:id])
  end


  def create
    @authorization = Authorization.new(params[:authorization])
    
    if @authorization.save
      redirect_to(@authorization, :notice => 'Authorization was successfully created.')
    end      
  end

  def update
    @authorization = Authorization.find(params[:id])
    
    if @authorization.update_attributes(params[:authorization])
        redirect_to(@authorization, :notice => 'Authorization was successfully updated.')
    end
  end

  def destroy
    @authorization = Authorization.find(params[:id])
    @authorization.destroy
    redirect_to(authorizations_url)     
  end
end
