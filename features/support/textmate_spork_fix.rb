Before do
  class Cucumber::Formatter::Html
    def h(s)
      s.gsub(/[&"><]/) { |special| HTML_ESCAPE[special] }
    end
  end
end