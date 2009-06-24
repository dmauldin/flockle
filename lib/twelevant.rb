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
          query = query + " since:#{options[:since]}"
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
      unless user.scanned_at.nil?
        options[:since] = user.scanned_at.strftime("%Y-%m-%d")
      end
      
      user.update_attribute(:scanned_at, Time.now)
      
      results = []
      
      # tweets to friends
      results << Twelevant::Retrieve.tweets_to(names, options)

      # tweets from friends
      results << Twelevant::Retrieve.tweets_from(names, options)
      
      results = results.flatten.compact

      # TODO serious optimization, tests existence with 2 queries each
      unless results.empty?
        results.each do |result|
          result['tweet_id'] = result.delete('id')
          tweet = Tweet.find_by_tweet_id(result['tweet_id']) || Tweet.create(result)
          user.tweets << tweet unless user.tweets.include?(tweet)
        end
      end
    end
  end
end
