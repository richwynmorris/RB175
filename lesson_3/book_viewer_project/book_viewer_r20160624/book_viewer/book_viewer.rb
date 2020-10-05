require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock"
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @chapter = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @content = File.readlines("data/chp1.txt")

  erb :chapter
end
