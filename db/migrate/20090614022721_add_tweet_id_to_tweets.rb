class AddTweetIdToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :tweet_id, :integer
    add_index :tweets, :tweet_id
  end

  def self.down
    remove_index :tweets, :tweet_id
    remove_column :tweets, :tweet_id
  end
end
