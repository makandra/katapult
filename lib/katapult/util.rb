# Utility methods.

# The Katapult::Util module is used inside the `katapult` script. It should not
# require any gems in order to prevent version conflicts.

module Katapult
  module Util
    extend self

    def git_commit(message)
      message.gsub! /'/, "" # remove single quotes
      system "git add --all; git commit -m '#{ message }' --author='katapult <katapult@makandra.com>'"
    end

  end
end
