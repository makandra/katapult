module Katapult::GeneratorGoodies

  def yarn(*args)
    command =  'bin/yarn --silent --non-interactive ' + args.join(' ')
    run command
  end

  private

  def app_name(kind = nil)
    machine_name = File.basename(Dir.pwd)
    human_name = machine_name.tr('_', ' ').gsub(/\w+/, &:capitalize)

    case kind.to_s
      when ''       then machine_name
      when 'human'  then human_name
      else raise ArgumentError, "Unknown formatting: #{kind.inspect}"
    end
  end

  # Override Thor method
  def run(command, config={})
    config[:capture] ||= false # false = return boolean instead of cmd output

    Bundler.with_clean_env do
      super(command, config) or exit(1)
    end
  end

end
