class Visibility
  FRIENDS = 'friends_and_family'
  PARENTS_ONLY = 'parents_only'
  ME_ONLY = 'me_only'
  PUBLIC = 'public'

  def self.all_levels
    [FRIENDS, ME_ONLY, PARENTS_ONLY, PUBLIC]
  end

  def self.friends_and_family_can_see
    [FRIENDS, ME_ONLY]
  end

  def self.all_levels_without_me
    [FRIENDS, PARENTS_ONLY, PUBLIC]
  end

  def self.friends_and_public
    [FRIENDS, PUBLIC]
  end
end
