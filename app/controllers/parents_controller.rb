class ParentsController < ApplicationController
  def index
    @parent_kid_pairs = []

    current_user.kids.each do |kid|
      kid.parents.each do |parent|
        @parent_kid_pairs << [parent, kid]
      end
    end

    @parent_kid_pairs.sort_by! { |pair| pair[0].first_name }
  end

  def new
  end

  def create
    kid    = Kid.find_by(id: params[:parents][:kid_id])
    parent = User.find_by(id: params[:parents][:parent_id])

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

    if kid.parents.delete(parent)
      flash[:notice] = 'The parent permission was successfully deleted.'
      redirect_to parents_path
    else
      flash[:error] = 'There was a problem deleting the parent permission. Please try again.'
      redirect_to parents_path
    end
  end

  private

  def flash_messages(kid, parent)
    if !kid.present? || !parent.present?
      flash[:error] = 'Kid and parent are required. Please try again.'
    else
      flash[:error] = 'This parent already has permissions for this kid. Please try again.'
    end
  end
end
