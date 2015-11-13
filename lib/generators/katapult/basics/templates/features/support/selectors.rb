module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    # Auto-mapper for BEM classes
    #
    # Usage examples:
    #   the main menu -> '.main-menu'
    #   the item box's header -> '.item-box--header'
    #   the slider's item that is current -> '.slider--item.is-current'
    when /^the (.+?)(?:'s (.+?))?(?: that (.+))?$/
      selector = '.'
      selector << selectorify($1)
      selector << '--' << selectorify($2) if $2
      selector << '.' << selectorify($3) if $3
      selector

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /^the (notice|error|info) flash$/
    #    ".flash.#{$1}"

    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /^"(.+)"$/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
          "Now, go and add a mapping in #{__FILE__}"
    end
  end

  private

  def selectorify(string)
    string.gsub(/ /, '-')
  end

end

World(HtmlSelectorsHelpers)
