class CommunitweetsController < ApplicationController
  def index
    @friends = Twelevant::Retrieve.friends(:screen_name => params[:screen_name]).map{|f| f['screen_name']} << params[:screen_name]
    # tweets to friends
    results = Twelevant::Retrieve.tweets_to_users(@friends)
    # tweets from friends
    results << Twelevant::Retrieve.tweets_from_users(@friends)
    results = results.flatten.compact.sort{|a,b| a['id']<=>b['id']}.reverse
    # TODO: optimize this
    # we're trying to get all of the tweets with a unique id value
    # assuming they're sorted by id, you can just pass on hashes with the
    # same id as the previous hash
    @results = []
    results.each_index do |i|
      if i > 0
        unless results[i]['id'] == results[i-1]['id']
          @results << results[i]
        end
      end
    end
  end
end
