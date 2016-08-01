class ParentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @parent_kid_pairs = []

    current_user.kids.each do |kid|
      kid.parents.each do |parent|
        @parent_kid_pairs << [parent, kid]
      end
    end

    @parent_kid_pairs.sort_by! { |pair| pair[0].first_name }

    @parents = current_user.fellow_parent_s << current_user
  end

  def new
  end

  def create
    kid    = Kid.find_by(id: params[:parents][:kid_id])
    parent = User.find_by(id: params[:parents][:parent_id])

    authorize! :create, kid if kid

    if kid && parent && !kid.parents.include?(parent)
      kid.parents << parent
      redirect_to parents_path
    else
      flash_messages(kid, parent)
      render :new
    end
  end

  def destroy
    parent_kid_ids = params[:id].split('/')
    parent         = User.find_by(id: parent_kid_ids.first.to_i)
    kid            = Kid.find_by(id: parent_kid_ids.last.to_i)

    authorize! :destroy, kid

    if kid.parents.delete(parent)
      flash[:notice] = "This person's parent access was successfully deleted."
      redirect_to parents_path
    else
      flash[:error] = "There was a problem deleting this person's parent access. Please try again."
      redirect_to parents_path
    end
  end

  def edit_parent_name
    @parent = current_user

    authorize! :update, @parent
  end

  def update_parent_name
    @parent = current_user

    authorize! :update, @parent

    @parent.parent_name = params[:user][:parent_name]

    unless @parent.save
      flash[:error] = "There was a problem saving your parent name. Please try again."
    end

    redirect_to parents_path
  end

  private

  def flash_messages(kid, parent)
    if !kid.present? || !parent.present?
      flash[:error] = 'Kid and parent are required. Please try again.'
    else
      flash[:error] = 'This parent already has access for this kid. Please try again.'
    end
  end
end
