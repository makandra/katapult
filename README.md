# Katapult

<img src="katapult.png" width="200px" align="right" />


`Katapult` is a kickstart generator for Rails applications. It creates a basic
application and generates ([makandra-flavored](https://leanpub.com/growing-rails))
code from an application model, significantly speeding up the initial phase of a
Rails project.

`Katapult` will always support current versions of Ruby and Rails, currently
Rails 4.2 and Ruby 2.3.


## Installation

Install the `katapult` gem with

    gem install katapult


## Usage

`Katapult` does two separate things:

1. Create a new Rails application, set up with many standard gems, snippets,
   useful configuration, databases etc.
2. Generate code from an application model, i.e. create files for models, views,
   controllers, routes, stylesheets

You may use both or only one of them.


## 1) Creating a new Rails application

Run the following command:

    katapult new $APPLICATION_NAME

In detail, this will:
 
- create a new Rails application (without turbolinks)
- install common Gems, some of them commented out
- add a .gitignore and a .ruby-version file
- set up a `database.yml` file (for MySQL)
- create basic styles
- install some handy initializers
- install RSpec and Cucumber to the application
- create `lib/katapult/application_model.rb` (needed in Step 2)

See `lib/generators/katapult/basics/basics_generator.rb`.

### Using Katapult in existing Rails applications
`katapult` expects a clean application (that it would usually generate itself).
If you have an existing Rails application, you *may* use `katapult`, but be
warned: it is not designed to respect existing files, although it will usually
ask before overwriting files.

To add `katapult` to an existing Rails application, add
`gem 'katapult', group: :development` to the Gemfile. Then run any of the
following generators:

    rails generate katapult:basics # Prepare the app with useful defaults
    rails generate katapult:install # Create application model file
    rails generate katapult:transform lib/katapult/application_model.rb


## 2) Generating code from an application model

> If you only want to use the code generation feature of `katapult`, but did not
> run `katapult new ...`, you need to add `katapult` to your Gemfile now and
> install it with `rails generate katapult:install`. See above.

After installation, you will find a file `lib/katapult/application_model.rb`
where you will define the properties of your application.

Inside this file, use `katapult`'s simple DSL (domain specific language) to
express yourself. When you are done developing the application model, transform
it into code with:

    katapult fire

See an overview of the DSL below. The respective sections hold examples of what
options are available to each element.

### Generic DSL syntax example
The DSL consists of _elements_, e.g. `Model` or `WUI` (Web User Interface). Each
`katapult` element has the same syntax, taking a name, options, and a block:

    element_type 'name', options: 'example' do |element|
      element.some_method
    end


### Model
Takes a name and a block:

    model 'Customer' do |customer|
      # customer.attr :name etc, see Attribute element
    end


#### Attribute
Defined on Model. Takes a name and options:

    # Default type :string
    model.attr :name
    
    # Inferred type :email (when attr name matches /email/)
    model.attr :email
    
    # Specify assignable values. Available options: allow_blank, default
    model.attr :age, type: :integer, assignable_values: 18..99, allow_blank: true
    
    # Will be rendered as number_field in forms, and with a € sign in show views
    model.attr :income, type: :money
    
    # All attribute types take an optional default
    model.attr :homepage, type: :url, default: 'http://www.makandra.de'
    
    # Boolean fields are modeled as flags. Default required!
    model.attr :locked, type: :flag, default: false


### WUI (Web User Interface)
Takes a name, options and a block:

    wui 'Customer', model: 'User' do |wui|
      # wui.crud, see Action element
    end

    # Inferred model name: 'Customer'
    wui 'Customer' do |wui|
      # wui.crud, see Action element
    end


#### Action
Defined on WUI. Takes a name and options:

    # Create all the standard rails actions
    wui.crud

    # Select single Rails actions
    wui.action :index
    wui.action :show
    wui.action :create # also creates :new
    wui.action :update # also creates :edit
    wui.action :destroy
    
    # Add custom actions
    wui.action :custom_action, method: :post, scope: :member
    wui.action :other_action, method: :get, scope: :collection
    

### Navigation
Takes a name, will generate a navigation with links to the index pages of all
WUIs.

    navigation :main


## Development

### Basic information
`Katapult` is tested with [RSpec](http://rspec.info/) and
[Cucumber](https://cucumber.io/) + [Aruba](https://github.com/cucumber/aruba)
([API-Doc](http://www.rubydoc.info/github/cucumber/aruba/master/)).

It caches a pristine Rails application inside its `tmp/` directory to
speed up test runs. Keep this in mind, as it may lead to caching issues when
switching Ruby versions or installing a new version of the Rails gem.

Since `katapult` has full-stack integration tests, it requires a MySQL account.
Create a dedicated account on your local MySQL server by running this command in
a MySQL console (as-is):

    GRANT ALL ON *.* TO 'katapult'@'localhost' IDENTIFIED BY 'secret';

The user `katapult` is hereby granted any action (SELECT, UPDATE, etc. except
for granting privileges) on any database and table (`*.*`).

### Continuing development
When you continue development on `katapult`, remove its `tmp/` directory first.
It contains cached data that might lead to confusion.

### Debugging
Add the `@announce-output` tag to `katapult` features in order to have any output
logged to your terminal.

To precisely debug errors occurring _inside_ the generated application, you may
cd to `tmp/aruba/katapult_test_app`. Run the failing command manually.

Note that after running a katapult feature, you need to call
`cd ../../aruba/katapult_test_app` inside the generated app terminal. This is
required because the `tmp/aruba` directory is being wiped before each scenario.

### Typical errors
- Timeout error because of a script waiting for user input
- Executing (bash) commands in the test application without resetting the
  katapult gem's Bundler settings. Wrap into `Bundler.with_clean_env { }`.
- Spring running inside the test application encumbers parallel_tests
- An outdated Rails application in `tmp/cached_test_app`


## Credits

Development: Dominik Schöler from [makandra](makandra.com)<br />
Katapult image: [Nemo](http://pixabay.com/de/katapult-30061)
