class CreateRelevantTweets < ActiveRecord::Migration
  def self.up
    create_table :relevant_tweets do |t|
      t.integer :user_id
      t.integer :tweet_id
      t.timestamps
    end
  end

  def self.down
    drop_table :relevant_tweets
  end
end
