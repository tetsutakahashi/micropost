class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  has_many :favorts
  has_many :favomicroposts, through: :favorts, source: :micropost
  
  def favorite(fv_micropost)
    unless self == fv_micropost.user
      self.favorts.find_or_create_by(micropost_id: fv_micropost.id)
    end
  end

  def unfavorite(fv_micropost)
    favort = self.favorts.find_by(micropost_id: fv_micropost.id)
    favort.destroy if favort
  end

  def favomicropost?(fv_micropost)
    self.favomicroposts.include?(fv_micropost)
  end
  
end
