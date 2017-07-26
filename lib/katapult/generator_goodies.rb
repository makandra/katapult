module Katapult::GeneratorGoodies

  private

  def app_name
    File.basename(Dir.pwd)
  end

  # Override Thor method to exit on error
  def run(command, config={})
    config[:capture] = false # return true|false instead of output

    Bundler.with_clean_env do
      super(command, config) or exit(1)
    end
  end

end
