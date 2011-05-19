module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the home page/
      '/' 
    when /^the admin page$/
      '/admin'
    when /the edit admin user page for "([^\"]*)"/
      edit_admin_user_path($1)
    when /the admin user page for "([^\"]*)"/
      admin_user_path($1)
    when /the edit admin layout page for "([^\"]*)"/
      edit_admin_layout_path($1)
    when /the edit admin page page for "([^\"]*)"/
      edit_admin_page_path($1)      
    when /the edit admin media file page for "([^\"]*)"/
      edit_admin_media_file_path($1)
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
