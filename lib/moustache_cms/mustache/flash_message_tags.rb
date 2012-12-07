module MoustacheCms
  module Mustache
    module FlashMessageTags
      # shows the flash notice
      def flash_notice
        engine = gen_haml('flash_notice.haml')
        engine.render(action_view_context, {flash: @controller.flash})
      end

    end
  end
end
