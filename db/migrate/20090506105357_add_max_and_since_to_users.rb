class AddMaxAndSinceToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :flock_since_id, :integer
    add_column :users, :flock_max_id, :integer
  end

  def self.down
    remove_column :users, :flock_since_id
    remove_column :users, :flock_max_id
  end
end
