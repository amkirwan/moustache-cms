module HamlFilter        
  def hamlize(input)
    Haml::Engine.new(input).render
  end
end