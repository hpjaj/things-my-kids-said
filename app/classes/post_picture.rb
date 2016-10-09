class PostPicture

  def initialize(params, post, user)
    @params = params
    @post = post
    @user = user
  end

  def set_picture_id
    if id = new_valid_picture_id
      @post.picture_id = id
    elsif picture_already_present?
      return
    else
      quotes_photo     = determine_quotes_picture(@params[:post][:kid_id])
      @post.picture_id = quotes_photo
    end
  end

  def determine_quotes_picture(kid_id)
    kid = Kid.find_by(id: kid_id)

    return unless kid

    last_post_with_photo = kid.posts.most_recent_with_picture

    if last_post_with_photo
      last_post_with_photo.picture_id
    elsif picture = kid.pictures.profile_pictures.last_updated
      picture.id
    else
      nil
    end
  end

  private

  def create_post_picture
    new_picture = Picture.add_picture(@user, @params[:post], @params[:post][:kid_id])

    new_picture.try(:id)
  end

  def picture_already_present?
    @post.picture_id.present?
  end

  def new_valid_picture_id
    if @params[:post][:picture].present? && (id = create_post_picture)
      id
    else
      false
    end
  end

end
