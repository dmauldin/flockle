class CommunitweetsController < ApplicationController
  def index
    screen_name = params[:screen_name]
    @user = User.find_by_login(screen_name) || User.create(:login => screen_name)
    
    options = {}
    unless @user.tweets.empty?
      options[:since_id] = @user.tweets.last.id
    end
    
    # make a list of screen names from the friends of the specified account
    # and then add their own as well
    @friends = Twelevant::Retrieve.friends(:screen_name => screen_name).map{|f| f['screen_name']} << screen_name
    
    # tweets to friends
    new_results = Twelevant::Retrieve.tweets_to(@friends, options)
    
    # tweets from friends
    new_results << Twelevant::Retrieve.tweets_from(@friends, options)
    
    new_results = new_results.flatten.compact.sort{|a,b| a['id']<=>b['id']}.reverse
    
    # TODO: optimize this
    # we're trying to get all of the tweets with a unique id value
    # assuming they're sorted by id, you can just pass on hashes with the
    # same id as the previous hash
    results = []
    new_results.each_index do |i|
      if i > 0
        unless new_results[i]['id'] == new_results[i-1]['id']
          results << new_results[i]
        end
      else
        results << new_results[i]
      end
    end
    
    # now that we have a unique list, we will insert them into the db
    results.each do |result|
      unless Tweet.find_by_id(result['id'])
        tweet = Tweet.new
        tweet.id = result['id']
        tweet.update_attributes(result)
        @user.tweets << tweet
      end
    end
    
    @results = @user.tweets(:limit => 300).sort{|a,b| a.id <=> b.id}.reverse
  end
end
