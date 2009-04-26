ActionController::Routing::Routes.draw do |map|
  map.screen_name '/:screen_name', :controller => 'communitweets', :action => 'index'
  map.root :controller => 'home', :action => 'index'
end
