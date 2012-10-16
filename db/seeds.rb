site = Site.find_or_create_by(:name => "Moustache CMS", :subdomain => "moustache-cms") do |s|
  s.default_domain = "dev"
end

site.domain_names << '127.0.0.1'
site.domain_names << 'localhost'

admin = User.find_or_create_by(:firstname => "Admin", :lastname => "Moustache", :email => "admin@moustachecms.org") do |user|
  user.username = "admin"
  user.role = "admin"
  user.site_id = site.id
  user.password = "moustache"
  user.time_zone = MoustacheCms::Application.config.time_zone
end

# Create Layout
layout = Layout.find_or_create_by(:name => "application", :content => "<!DOCTYPE HTML>\n<html>\n  <head>\n  </head>\n  <body>\n    {{{ yield }}}\n  </body>\n</html") do |l|
  l.site_id = site.id
  l.created_by_id = admin.id
  l.updated_by_id = admin.id
end
                                  
                                  
if Page.root.nil?

  Page.find_or_create_by(:title => "Homepage", 
                         :slug => "/", 
                         :breadcrumb => "",
                         :layout_id => layout.id) do |p|
                p.site_id = site.id
                p.editor_ids = [ admin.id ]
                p.created_by_id = admin.id
                p.updated_by_id = admin.id
                p.current_state = CurrentStatedraft
                p.page_parts = [ PagePart.new(:name => "content", :content => "This is the home page!", :filter_name => Filter.find_by_name("html").name) ]
  end           
end
