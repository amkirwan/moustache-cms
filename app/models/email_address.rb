class EmailAddress
  include Mongoid::Document
  field :email
  field :default, :type => Boolean
  embedded_in :user, :inverse_of => :email_addresses
     
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, :message => "requires valid email message"
end