module Twelevant
  def self.add_name_to_query(query, name)
    [query, name].join(" OR ")
  end

  def self.search_queries_from_names(names, name_prefix)
    query = []
    queries = []

    names.each do |name|
      name = name_prefix + name
      if query.empty?
        query = name
      else
        newquery = add_name_to_query(query, name)
        if newquery.size <= 120
          query = newquery
        else
          queries << query
          query = name
        end
      end
    end
    queries << query
  end
  
  class Retrieve
    def self.logger
      RAILS_DEFAULT_LOGGER
    end
    
    include HTTParty
    # normally you'd specify your format here, but in production, it will
    # persist, so you'll need to call it again before each get anyway
    
    def self.friends(query)
      format :xml
      url = "http://twitter.com/statuses/friends.xml"
      get(url, :query => query)['users']
    end

    def self.multiple_search(queries, options = {})
      results = []
      queries.each do |query|
        if options[:since_id]
          query = query + "&since_id=#{options[:since_id].to_s}"
        end
        results << search(query)
      end
      results = results.map{|r|r['results']}.flatten
      results.empty? ? nil : results
    end
    
    def self.tweets_to(users, options = {})
      queries = Twelevant.search_queries_from_names(users, "@")
      multiple_search(queries, options)
    end
    
    def self.tweets_from(users, options = {})
      queries = Twelevant.search_queries_from_names(users, "from:")
      multiple_search(queries, options)
    end
    
    def self.search(query)
      format :json
      url = "http://search.twitter.com/search.json"
      logger.debug "QUERY:#{query}"
      get url, :query => {:q => query}
    end
    
    # get all relevant tweets for user
    # TODO : remove names parameter - it's currently only here so we don't
    #        have to get the list of names twice via http
    def self.relevant_tweets(user, names)
      options = {}
      unless user.tweets.empty?
        options[:since_id] = user.tweets.last.id
      end

      new_results = []
      # tweets to friends
      new_results << Twelevant::Retrieve.tweets_to(names, options)

      # tweets from friends
      new_results << Twelevant::Retrieve.tweets_from(names, options)

      unless new_results.empty?
        new_results = new_results.flatten.compact.sort{|a,b| a['id']<=>b['id']}.reverse
      
        # TODO: optimize this
        # we're trying to get all of the tweets with a unique id value
        # assuming they're sorted by id, you can just pass on hashes with the
        # same id as the previous hash
        # really needs to be results.uniq_by {|r| r['id']}
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

        tweet_ids = Tweet.all.map(&:id)
        # now that we have a unique list, we will insert them into the db
        results.each do |result|
          unless tweet_ids.include?(result['id'])
            tweet = Tweet.new
            tweet.id = result.delete 'id'
            tweet.update_attributes(result)
            user.tweets << tweet
            tweet_ids << tweet.id
          end
        end
      end
    end
  end
end
