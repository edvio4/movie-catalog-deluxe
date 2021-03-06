require "sinatra"
require "pg"
require_relative "./app/models/actors"
require_relative "./app/models/movies"
require 'pry'

set :views, File.join(File.dirname(__FILE__), "app/views")

configure :development do
  set :db_config, { dbname: "movies" }
end

configure :test do
  set :db_config, { dbname: "movies_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get '/actors' do
  @actors = Actors.all
  erb :'index/actors'
end

get '/actors/:id' do
  @actor = retrieve_actor(params[:id])
  @actor.retrieve_profile
  erb :'actor_roles'
end

get '/actors' do
  @actors = Actors.all
  erb :'index/actors'
end

get '/movies' do
  @movies = Movies.all
  erb :'index/movies'
end

get '/movies/:id' do
  @movie = retrieve_movie(params[:id])
  @movie.retrieve_cast_members
  erb :'movie_info'
end

def retrieve_actor(id)
  actor_temp = db_connection { |conn| conn.exec("SELECT id, name FROM actors WHERE actors.id = ($1)", [id]) }
  Actors.new(actor_temp[0])
end

def retrieve_movie(id)
  movie_temp = db_connection { |conn| conn.exec("SELECT movies.id, movies.title, movies.year, movies.rating, genres.name AS genre, studios.name AS studio
  FROM movies
  LEFT JOIN genres
  ON (movies.genre_id = genres.id )
  LEFT JOIN studios
  ON ( movies.studio_id = studios.id )
  WHERE movies.id = ($1)", [id]) }
  Movies.new(movie_temp[0])
end
