class ActorRole
  attr_reader :id, :name, :character_name

  def initialize(actor)
    @id = actor["id"]
    @name = actor["actor_name"]
    @character_name = actor["character_name"]
  end
end
