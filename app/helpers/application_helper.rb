# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def linkify(text)
    text.gsub! /(https?:\/\/\S+)/, '<a href="\1">\1</a>'
    text.gsub /(^|\s)@(\w+)/, '\1@<a href="http://twitter.com/\2">\2</a>'
  end
  
  def reply_link(tweet)
    "http://twitter.com/home?status=@#{tweet.from_user}%20&in_reply_to_status_id=#{tweet.tweet_id}&in_reply_to=#{tweet.from_user}"
  end
end
