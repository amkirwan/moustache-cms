if $('li#tag_attr_<%= @tag_attr.name %>').length
  tag = $('li#tag_attr_<%= @tag_attr.name %>')
  tag.fadeToggle 'slow', 'linear', ->
    $(this).next().remove()
    $(this).remove()
