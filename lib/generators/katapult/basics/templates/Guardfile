# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features)

## Uncomment to clear the screen before every task
# clearing :on

## Guard internally checks for changes in the Guardfile and exits.
## If you want Guard to automatically start up again, run guard in a
## shell loop, e.g.:
##
##  $ while bundle exec guard; do echo "Restarting Guard..."; done
##
## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'livereload' do
  watch %r{app/views/.+\.(erb|haml)$}
  watch 'app/models/navigation.rb' # Navy
  watch 'app/models/power.rb' # Consul
  watch %r{app/helpers/.+\.rb}
  watch %r{public/.+\.(css|js|html)}
  watch %r{config/locales/.+\.yml}
  watch %r{spec/javascripts/} # Jasmine

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|sass|js|coffee|html|png|jpg))).*}) do |m|
    filename = m[3]
    # When a .sass (or .css.sass) file was changed, tell the client to load the .css version.
    # Similarly, for .coffee / .js.coffee files we ask the client to reload the .js file.
    filename.gsub! /(\.css)?\.sass$/, '.css'
    filename.gsub! /(\.js)?\.coffee$/, '.js'
    "/assets/#{filename}"
  end
end
