if $('div#content')
  $('div#content').prepend('<%= escape_javascript(render :partial => "shared/flash_notice") %>')

$("div#flash_notice_wrapper").delay(1000).fadeToggle "slow", "linear", ->
  $(this).remove()

$('#<%= @user.puid %>').fadeToggle "slow", "linear", ->
  $(this).remove()

window.location.replace('<%= new_admin_user_session_path %>')
