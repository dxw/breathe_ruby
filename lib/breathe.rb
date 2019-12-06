require "sawyer"

require "breathe/version"
require "breathe/client"
require "breathe/response"

require "breathe/absences"
require "breathe/sicknesses"

module Breathe
  class Error < StandardError; end
  class AuthenticationError < StandardError; end
  class UnknownError < StandardError; end
  # Your code goes here...
end
