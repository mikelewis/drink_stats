require 'sinatra'
require_relative 'helpers/init'

helpers Sinatra::Partials
before do
  set :db_connection, DrinkStats::Database.new
  @current_username = "madmike"
end

get '/' do
  @overall_stats = connection.get_results_for_overall
  @user_stats = connection.get_results_for_user(@current_username)
  haml :home
end

get '/item/:item' do
  @item_stats = {
    :top_users => connection.top_users_per_drink(params[:item])
  }
  haml :item
end

get '/machine/:machine' do
  "MACHINE"
  haml :machine
end

get '/:username' do
  @user_stats = connection.get_results_for_user(params[:username])
  haml :user
end

not_found do
  "NOT FOUND DUDE"
end

helpers do
  include DrinkStats::Helpers
  def connection
    settings.db_connection
  end
end
