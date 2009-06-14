class ChangeTweetsTweetIdToBigint < ActiveRecord::Migration
  def self.up
    # yes, I know it's bad to use raw sql
    # yes, I know this only works in mysql, but that's what we're using
    # tweet_id requires a bigint, what else can I say...
    # after 2009-06-13, your data is already corrupt if you're not using this
    # so...  let's get rid of it :x
    queries = [
      "alter table tweets change tweet_id tweet_id bigint",
      "delete from tweets",
      "delete from relevant_tweets"
    ]
  	queries.each {|query| ActiveRecord::Base.connection.execute(query)}
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
