class FilteredKid < ActiveRecord::Base
  belongs_to :user
  belongs_to :kid

  validates :kid_id, uniqueness: { scope: :user_id, message: 'This kid is already hidden' }

  def self.sorted_kids_of(user)
    self
      .joins(:kid)
      .where(user_id: user.id)
      .order('kids.last_name ASC')
  end

  def self.exists?(kid, user)
    self.where(user: user, kid: kid).present?
  end
end
