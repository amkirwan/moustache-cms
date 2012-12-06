class Comment
  include Mongoid::Document
  # include Rakismet::Model

  embedded_in :article
  embeds_many :comments, class_name: 'Comment'

  field :author
  field :author_url
  field :author_email
  field :comment_type, default: 'comment'
  field :content
  field :permalink
  field :user_ip
  field :user_agent
  field :referrer

  attr_accessible :author, :author_email, :author_url, :content

  # --- validations -------
  validates :author, presence: true
  validates :author_email, presence: true
  validates :content, presence: true

  def request=(request)
    self.permalink = request.url
    self.user_ip = request.remote_ip
    self.user_agent = request.user_agent
    self.referrer = request.referer
  end

end
