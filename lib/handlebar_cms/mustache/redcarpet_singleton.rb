class RedcarpetSingleton
  include Singleton

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,:autolink => true, :space_after_headers => true) 
  end

end
