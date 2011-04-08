require 'sinatra'
require_relative 'helpers'

helpers Sinatra::Partials
before do
  set :db_connection, DrinkStatHelper::Database.new
  @current_username = "madmike"
end

get '/' do
    @overall_stats =
    {
      :top_drinks =>connection.get_top_drinks,
      :top_users_this_year => connection.get_top_ten_users,
      :top_users_all_time => connection.get_top_ten_users(:all_time => true),
      :recent_drops => connection.get_recent_drops
    }

    @user_stats =
    {
      :top_drinks =>connection.get_top_drinks(@current_username),
      :recent_drops => connection.get_recent_drops(@current_username)
    }

  haml :home
end

get '/:username' do
  params[:username]
end

not_found do
  "NOT FOUND DUDE"
end

helpers do
  include DrinkStatHelper::Helpers
  def connection
    settings.db_connection
  end
end
