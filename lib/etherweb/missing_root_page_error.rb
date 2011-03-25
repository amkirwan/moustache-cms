module Etherweb
  class MissingRootPageError < StandardError
    def initialize(message = 'Database missing root page'); super end
  end
end