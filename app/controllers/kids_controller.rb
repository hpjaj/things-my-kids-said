class KidsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    if current_user.admin?
      @kids = Kid.all
    else
      @kids = current_user.kids.order(:first_name)
    end

    authorize! :create, @kids.first
  end

  def new
    authorize! :create, Kid

    @kid = Kid.new
  end

  def create
    if kid_creation_transaction
      redirect_to kids_path
    else
      flash[:error] = "There was a problem creating your kid's profile.  Please try again."
      render :new
    end
  end

  def edit
    @kid = Kid.find(params[:id])

    authorize! :update, @kid
  end

  def update
    @kid = Kid.find(params[:id])

    authorize! :update, @kid

    downcased_params = kid_params
    downcased_params['first_name'] = kid_params['first_name'].downcase
    downcased_params['last_name']  = kid_params['last_name'].downcase

    if @kid.update(downcased_params)
      redirect_to kids_path
    else
      flash[:error] = "There was a problem updating your kid.  Please try again."
      render :edit
    end
  end

  def destroy
    @kid = Kid.find(params[:id])

    authorize! :destroy, @kid

    if @kid.destroy
      flash[:notice] = 'Your kid was successfully removed.'
      redirect_to kids_path
    else
      flash[:error] = 'There was a problem removing your kid. Please try again.'
      render :index
    end
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name, :last_name, :birthdate, :gender, :photo, :created_by)
  end

  def kid_creation_transaction
    ActiveRecord::Base.transaction do
      begin
        authorize! :create, Kid

        @kid = Kid.new(kid_params)
        @kid.first_name = @kid.first_name.downcase
        @kid.last_name  = @kid.last_name.downcase
        @kid.save
        current_user.kids << @kid
      rescue Exception => e
        logger.error "User #{current_user.id} experienced #{e.message} when trying to create a new kid"
        false
      end
    end
  end

end
