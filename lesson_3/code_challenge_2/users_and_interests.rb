require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @users_info = YAML.load_file('users.yaml')
  @names = get_users_names(@users_info)
end

helpers do
  def count_interests(info)
    number_of_interests = 0
    info.each do |name, details|
      number_of_interests += info[name][:interests].count
    end
    "There are #{@names.count} with a total of #{number_of_interests} interests"
  end 
end

def get_user_names(users_info)
  names = []
  users_info.each do |info|
    names << info[0].to_s
  end
  names
end

def get_user_details(user)
  email = ''
  interests = ''
  user_name = ''
  @users_info.each do |name, details|
    if user.to_sym == name
      user_name = name.to_s
      email = @users_info[name][:email]
      interests = @users_info[name][:interests]
    end
  end
  [user_name, email, interests]
end

get '/' do
  @users_info = YAML.load_file('users.yaml')
  
  erb :home_page
end

get '/users/:user' do
  @user = params[:user]
  @user_name, @email_address, @interests = get_user_details(@user)

  redirect '/' unless @names.include?(@user)

  erb :user
end

