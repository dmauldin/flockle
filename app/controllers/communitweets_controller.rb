class CommunitweetsController < ApplicationController
  def index
    screen_name = params[:screen_name]
    @user = User.find_by_login(screen_name, :include => [:relevant_tweets]) || User.create(:login => screen_name)
    
    # make a list of screen names from the friends of the specified account
    # and then add their own as well
    @names = Twelevant::Retrieve.friends(:screen_name => screen_name).map{|f| f['screen_name']} << screen_name
    
    # get all relevant tweets - also puts them in the database
    # TODO : just display existing tweets here and get new through ajax call
    Twelevant::Retrieve.relevant_tweets(@user, @names)
    
    @results = @user.tweets.all(:limit => 300, :order => 'tweets.id desc')
  end
end
