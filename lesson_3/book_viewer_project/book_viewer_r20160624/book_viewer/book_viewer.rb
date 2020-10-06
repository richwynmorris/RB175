require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    results << {name: name, number: number} if contents.include?(query)
  end

  results
end

not_found do
  redirect '/'
end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock"
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/:number" do
  number = params[:number]
  @title = "Chapter #{number}"


  redirect "/" unless (1..@contents.size).cover? number
  
  @content = File.read("data/chp#{number}.txt")
  @chapter_name = @contents[number.to_i - 1]

  erb :chapter
end

get "/show/:name" do
  params[:name]
end

get "/search" do
  @results = chapters_matching(params[:query])

  erb :search
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end




