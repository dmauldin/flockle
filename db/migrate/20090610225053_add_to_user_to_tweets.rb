class AddToUserToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :to_user, :string
  end

  def self.down
    remove_column :tweets, :to_user
  end
end
