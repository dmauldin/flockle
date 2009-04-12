# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def linkify(text)
    text.gsub! /(https?:\/\/\S+)/, '<a href="\1">\1</a>'
    text.gsub /(^|\s)@(\w+)/, '\1@<a href="http://twitter.com/\2">\2</a>'
  end
end
