require_relative 'actor_profile'

class Actors
	attr_reader :name, :id, :profile

  def initialize(params)
    @id = params["id"]
    @name = params["name"]
    @profile = []
  end

  def self.all
    actors = db_connection { |conn| conn.exec("SELECT id, name FROM actors ORDER BY name") }
    actors.map { |actor| Actors.new(actor) }
  end

  def retrieve_profile
    profile_temp = db_connection { |conn| conn.exec("SELECT movies.id, cast_members.character, movies.title
    FROM cast_members
    LEFT JOIN actors
    ON (actors.id = cast_members.actor_id )
    LEFT JOIN movies
    ON ( cast_members.movie_id = movies.id )
    WHERE actors.name = ($1)", [name]) }
    @profile = profile_temp.map { |movie| ActorProfile.new(movie) }
  end
end
