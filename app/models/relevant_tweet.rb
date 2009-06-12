# == Schema Information
# Schema version: 20090610225053
#
# Table name: relevant_tweets
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  tweet_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class RelevantTweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
end
