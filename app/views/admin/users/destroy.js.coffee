if $("div#flash_notice_wrapper") 
  $("div#flash_notice_wrapper").fadeToggle "slow", "linear", ->
    $(this).remove()

$('#<%= @user.puid %>').fadeToggle "slow", "linear", ->
  $(this).remove()
