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
    # normally you'd specify your format here, but in production, it will
    # persist, so you'll need to call it again before each get anyway
    
    def self.friends(query)
      format :xml
      url = "http://twitter.com/statuses/friends.xml"
      get(url, :query => query)['users']
    end

    def self.tweets_to(users, options = {})
      queries = Twelevant.search_queries_from_names(users)
      results = []
      queries.each do |query|
        if options[:since_id]
          query = query + options[:since_id].to_s
        end
        results << search(query)
      end
      results = results.map{|r|r['results']}.flatten
      results.empty? ? nil : results
    end
    
    def self.tweets_from(users, options = {})
      results = []
      users.each do |user|
        query = "from:#{user}"
        if options[:since_id]
          query = query + options[:since_id].to_s
        end
        results << search(query)
      end
      results = results.map{|r|r['results']}.flatten
      results.empty? ? nil : results
    end
    
    def self.search(query)
      format :json
      url = "http://search.twitter.com/search.json"
      get url, :query => {:q => query}
    end
  end
end
