ActionController::Routing::Routes.draw do |map|
  map.connect '/:screen_name', :controller => 'communitweets', :action => 'index'
  # map.root :controller => 'timeline', :action => 'index'
  # map.resources :users, :member => {:followed_search => :get}
end
