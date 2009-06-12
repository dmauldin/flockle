# == Schema Information
# Schema version: 20090610225053
#
# Table name: tweets
#
#  id                :integer         not null, primary key
#  text              :string(255)
#  from_user         :string(255)
#  to_user_id        :integer
#  iso_language_code :string(255)
#  from_user_id      :integer
#  source            :string(255)
#  profile_image_url :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  to_user           :string(255)
#

class Tweet < ActiveRecord::Base
  has_many :relevant_tweets, :dependent => :destroy
end
