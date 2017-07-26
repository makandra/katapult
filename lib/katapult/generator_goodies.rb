module Katapult::GeneratorGoodies

  private

  def app_name
    File.basename(Dir.pwd)
  end

  # Override Thor method
  def run(command, config={})
    config[:capture] ||= false # false = return boolean instead of cmd output

    Bundler.with_clean_env do
      super(command, config) or exit(1)
    end
  end

end
