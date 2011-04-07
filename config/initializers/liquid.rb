require "#{Rails.root}/lib/etherweb/liquid/filters/textile_filter"
require "#{Rails.root}/lib/etherweb/liquid/filters/markdown_filter"
require "#{Rails.root}/lib/etherweb/liquid/filters/haml_filter"

::Liquid::Template.register_filter(TextileFilter)
::Liquid::Template.register_filter(MarkdownFilter)
::Liquid::Template.register_filter(HamlFilter)