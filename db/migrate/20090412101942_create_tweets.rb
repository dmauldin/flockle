class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text
      t.string :from_user
      t.integer :to_user_id
      t.string :iso_language_code
      t.integer :from_user_id
      t.string :source
      t.string :profile_image_url
      
      t.timestamps
    end
    add_index :tweets, :from_user_id
  end

  def self.down
    remove_index :tweets, :from_user_id
    drop_table :tweets
  end
end
