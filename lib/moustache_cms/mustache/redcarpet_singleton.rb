class RedcarpetSingleton
  include Singleton

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,:autolink => true, :no_intra_emphasis => true, :lax_html_block => true, :space_after_headers => true) 
  end

end
