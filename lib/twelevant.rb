module Twelevant
  def self.add_name_to_query(query, name)
    [query, name].join(" OR ")
  end

  def self.search_queries_from_names(names)
    query = []
    queries = []

    names.each do |name|
      name = "@" + name
      if query.empty?
        query = name
      else
        newquery = add_name_to_query(query, name)
        if newquery.size <= 140
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
    include HTTParty
    format :xml
    
    def self.friends(query)
      url = "http://twitter.com/statuses/friends.xml"
      get(url, :query => query)['users']
    end

    def self.tweets_to_users(users, options = {})
      queries = Twelevant.search_queries_from_names(users)
      results = []
      queries.each do |query|
        RAILS_DEFAULT_LOGGER.debug "XXX about to do a search in tweets_to_users"
        results << search(query)
      end
      return results.map{|r|r['results']}.flatten
    end
    
    def self.tweets_from_users(users, options = {})
      results = []
      users.each do |user|
        results << search("from#%3A#{user}")
      end
      return results.map{|r|r['results']}.flatten
    end
    
    def self.tweets_relevant_to_user(user)
      
    end
    
    def self.search(query)
      format :json
      url = "http://search.twitter.com/search.json"
      RAILS_DEFAULT_LOGGER.debug "XXX #{query} #{query.class}"
      get url, :query => {:q => query}
    end
  end
end
