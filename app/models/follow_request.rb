# == Schema Information
#
# Table name: follow_requests
#
#  id           :integer          not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#

class FollowRequest < ApplicationRecord
  validates(:recipient, {:presence => true })
  validates(:sender, {:presence => true })
  
  def recipient
    return User.where({ :id => self.recipient_id }).at(0)
  end

  def sender
    return User.where({ :id => self.sender_id }).at(0)
  end
end
