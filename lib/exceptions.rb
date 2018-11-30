module Exceptions
  class AuthResultError < StandardError; end
  class SignatureCheckError < StandardError; end
  class JobStartError < StandardError; end
  class JobCancelError < StandardError; end
end