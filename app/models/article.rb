class Article < Leaf
  include Mongoid::Document 
  include Mongoid::Timestamps

  attr_accessible :permalink 

  # -- Fields -----------
  field :permalink
  field :authors

  # -- Callbacks ----------
  before_create :permalink_set

  # -- Fields -----------------------------
  field :permalink

  def permalink_set
    time = DateTime.now
    year = time.year.to_s
    month = time.month.to_s
    day = time.day.to_s
    self.permalink = "#{self._parent.name}/#{year}/#{month}/#{day}/#{self.slug}"
  end

  private 
    # full_path is "/foobar/baz/qux" in http://example.com/asset_collection/10/02/2011/asset_slug
    def full_path_set
      self.full_path = "#{self.parmalink}" 
    end

    def slug_set
      if self.site_id.nil?
        self.slug = ""
      elsif self.slug.blank?
        self.slug = self.title.downcase
      else
        self.slug.downcase!
        self.slug.strip!
      end
      self.slug.gsub!(/[\s_]/, '-')
    end
end
