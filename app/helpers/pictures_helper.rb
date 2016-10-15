module PicturesHelper
  def can_destroy_any?(pictures)
    pictures.any? { |picture| can?(:destroy, picture) }
  end

  def delete_picture_confirmation(picture)
    post_count = Post.using_picture(picture.id)
    is_are     = post_count == 1 ? 'is' : 'are'

    "There #{is_are} #{pluralize(post_count, 'quote')} using this picture.  Delete this picture?"
  end
end
