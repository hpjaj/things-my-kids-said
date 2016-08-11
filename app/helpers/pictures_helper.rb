module PicturesHelper
  def can_destroy_any?(pictures)
    pictures.any? { |picture| can?(:destroy, picture) }
  end
end
