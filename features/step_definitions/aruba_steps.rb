When 'I type the current Ruby version' do
  step %(I type "#{Katapult::RUBY_VERSION}")
end

When 'I stop the command above' do
  aruba.command_monitor.stop_process last_command_started
end
