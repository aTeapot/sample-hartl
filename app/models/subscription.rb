class Subscription < ActiveRecord::Base
  belongs_to :follower, class_name: User
  belongs_to :author,   class_name: User
  
  validates :follower_id, presence: true
  validates :author_id,   presence: true
end
