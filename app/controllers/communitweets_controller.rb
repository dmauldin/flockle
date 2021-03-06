class CommunitweetsController < ApplicationController
  def index
    screen_name = params[:screen_name]
    @names = Twelevant::Retrieve.friends(:screen_name => screen_name)
    if @names.nil?
      render :text => "I'm sorry, I couldn't find a twitter account with the name \"#{screen_name}\"", :status => 500
      return
    end

    @user = User.find_or_create_by_login(screen_name, :include => [{:relevant_tweets => :tweets}])
    
    # make a list of screen names from the friends of the specified account
    # and then add their own as well
    @names = @names.map{|f| f['screen_name']} << screen_name
    
    # get all relevant tweets - also puts them in the database
    # TODO : just display existing tweets here and get new through ajax call
    Twelevant::Retrieve.relevant_tweets(@user, @names)
    
    @results = @user.tweets.all(:limit => 300, :order => 'tweets.created_at desc')
  end
end
