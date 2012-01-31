module HandlebarCms
  module Mustache
    module SiteCustomTags
      def first_article_latest_news
        article = @current_site.article_collections.where(:name => 'news').first.articles.desc(:created_at).first
        {
          "title" => %{<a href="#{article.permalink}">#{article.title}</a>}, 
          "content" => %{#{article.subheading} <a class="read-more" href="#{article.permalink}">Read More &raquo;</a>}
        }
      end


      def first_article_spotlight
        article = @current_site.article_collections.where(:name => 'spotlight').first.articles.desc(:created_at).first
        {
          "title" => %{<a href="#{article.permalink}">#{article.title}</a>}, 
          "content" => %{#{article.subheading} <a class="read-more" href="#{article.permalink}">Read More &raquo;</a>}
        }
      end


      def first_article_upcoming_events
        article = @current_site.article_collections.where(:name => 'events').first.articles.desc(:created_at).first
        {
          "title" => %{<a href="#{article.permalink}">#{article.title}</a>}, 
          "subheading" => %{<time datetime="#{article.datetime}">#{article.date_at}</time>},
          "content" => %{#{article.subheading} <a class="read-more" href="#{article.permalink}">Read More &raquo;</a>} 
        }
      end

      def nav_for_faculty
        engine = gen_haml('nav_for_faculty.haml')
        engine.render 
      end

      def faculty_list
        all_faculty = []
        @page.children.each do |letter|
          letter.children.each do |fac|
            all_faculty << fac
          end
        end
        faculty_paged = Kaminari.paginate_array(all_faculty).page(@controller.params[:page])
        faculty = []
        faculty_paged.each do |fac|
          if fac.page_parts.where(:name => 'position').nil? || fac.page_parts.where(:name => 'position').empty?
            faculty << { :profile_page_link => %{<a href="#" title="view profile">#{fac.title}</a>} }
          else
            faculty << { :profile_image => (render fac.page_parts.where(:name => 'fac_image').first.content),
                         :profile_page_link => %{<a href="#{fac.full_path}" title="view profile">#{fac.title}</a>},
                         :profile_position => (RedcarpetSingleton.markdown.render(fac.page_parts.where(:name => 'position').first.content)),
                       }
          end
        end
        faculty
      end

      def body_class
        page_path = @page.full_path
        if page_path =~ /^\/about/ 
          'about'
        elsif page_path =~ /^\/leadership/ 
          'leadership'
        elsif page_path =~ /^\/news/ 
          'news-and-events'
        elsif page_path =~ /^\/research/ 
          'research'
        elsif page_path =~ /^\/patient-care/
          'patient-care'
        elsif page_path =~ /^\/faculty/
          'faculty'
        else
          'homepage'
        end
      end

    end
  end
end



