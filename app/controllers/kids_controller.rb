class KidsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @kids = current_user.kids.order(:first_name)

    authorize! :create, @kids.first
  end

  def new
    authorize! :create, Kid

    @kid = Kid.new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new

    if kid_creation_transaction
      redirect_to kids_path
    else
      flash[:error] = "There was a problem creating your kid's profile.  Please try again."
      render :new
    end
  end

  def edit
    @kid = Kid.find(params[:id])
    @picture = @kid.pictures.last || Picture.new

    authorize! :update, @kid
  end

  def update
    @kid = Kid.find(params[:id])
    @picture = @kid.pictures.last || Picture.new

    authorize! :update, @kid

    if kid_updating_transaction
      redirect_to kids_path
    else
      flash[:error] = "There was a problem updating your kid.  Please try again."
      render :edit
    end
  end

  def destroy
    @kid = Kid.find(params[:id])

    authorize! :destroy, @kid

    if kid_destroying_transaction
      flash[:notice] = 'Your kid was successfully removed.'
      redirect_to kids_path
    else
      flash[:error] = 'There was a problem removing your kid. Please try again.'
      render :index
    end
  end

  private

  def kid_params
    params.require(:kid).permit(:first_name, :last_name, :birthdate, :gender, :photo, :created_by, pictures_attributes: [:picture])
  end

  def downcase_params
    downcased_params = kid_params
    downcased_params['first_name'] = kid_params['first_name'].downcase
    downcased_params['last_name']  = kid_params['last_name'].downcase

    downcased_params
  end

  def create_kid_picture
    if params[:kid][:picture]
      Picture.add_picture(current_user, params[:kid], @kid.id)
    else
      true
    end
  end

  def kid_creation_transaction
    ActiveRecord::Base.transaction do
      begin
        authorize! :create, Kid

        @kid = Kid.new(downcase_params)
        @kid.save!
        current_user.kids << @kid

        create_kid_picture
      rescue Exception => e
        logger.error "User #{current_user.id} experienced #{e.message} when trying to create a new kid"
        false
      end
    end
  end

  def kid_updating_transaction
    ActiveRecord::Base.transaction do
      begin
        @kid.update!(downcase_params) && create_kid_picture
      rescue Exception => e
        logger.error "User #{current_user.id} experienced #{e.message} when trying to update kid #{@kid}"
        false
      end
    end
  end

  def kid_destroying_transaction
    ActiveRecord::Base.transaction do
      begin
        @kid.posts.destroy_all
        @kid.pictures.destroy_all
        @kid.destroy
      rescue Exception => e
        logger.error "User #{current_user.id} experienced #{e.message} when trying to destroy kid #{@kid}"
        false
      end
    end
  end

end
