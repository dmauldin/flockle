class CommunitweetsController < ApplicationController
  def index
    friends = Twelevant::Retrieve.friends(:screen_name => params[:screen_name])
    # tweets to friends
    @results = Twelevant::Retrieve.tweets_to_users(friends.map{|f|f['screen_name']} << params[:screen_name])
    # tweets from friends
    @results << Twelevant::Retrieve.tweets_from_users(friends.map{|f|f['screen_name']} << params[:screen_name])
    @results = @results.flatten.sort{|a,b| Time.parse(a['created_at'])<=>Time.parse(b['created_at'])}.reverse
  end
end
