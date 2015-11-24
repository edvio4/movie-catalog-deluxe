class ActorProfile
  attr_reader :id, :title, :character

  def initialize(movie)
    @id = movie["id"]
    @title = movie["title"]
    @character = movie["character"]
  end
end
