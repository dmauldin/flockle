ActionController::Routing::Routes.draw do |map|
  map.connect '/:screen_name', :controller => 'communitweets', :action => 'index'
  map.root :controller => 'home', :action => 'index'
end
