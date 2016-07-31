class Picture < ActiveRecord::Base
  belongs_to :user
  belongs_to :kid
  has_many :posts

  has_attached_file :photo,
    styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png"

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates :photo_file_name, presence: true
  validates :photo_content_type, presence: true
  validates :photo_file_size, presence: true
  validates :photo_updated_at, presence: true

  scope :profile_pictures, -> { where(profile_picture: true) }

  def self.add_picture(user, params_with_model, kid_id)
    # example of params_with_model == `params[:kid]`
    value = params_with_model.has_key?('first_name')

    create!(
      photo: params_with_model[:picture][:photo],
      kid_id: kid_id,
      user_id: user.id,
      profile_picture: value
    )
  end
end
