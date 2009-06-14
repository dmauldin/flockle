class AddLastUpdatedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :scanned_at, :datetime
  end

  def self.down
    remove_column :users, :scanned_at
  end
end
