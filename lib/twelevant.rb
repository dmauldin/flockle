module Enumerable
  def uniq_by
    h = {}; inject([]) {|a,x| h[yield(x)] ||= a << x}
  end
end

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
        query = [name]
      else
        newquery = add_name_to_query(query, name)
        if newquery.size <= 140
          query = newquery
        else
          queries << query
          query = [name]
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
        results << Twitter::Search.new(query).fetch()
      end
      return results.map{|r|r.results}.flatten
    end
    
    def self.tweets_from_users(users, options = {})
      results = []
      users.each do |user|
        results << Twitter::Search.new.from(user).fetch()
      end
      return results.map{|r|r.results}.flatten
    end
    
    def self.tweets_relevant_to_user(user)
      
    end
  end
end
