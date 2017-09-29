# Katapult

<img src="katapult.png" width="200px" align="right" />


`Katapult` is a kickstart generator for Rails applications. It creates new Rails
applications with [lots of pre-configuration](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
and offers ([makandra-flavored](https://leanpub.com/growing-rails)) code
generation from an application model.
These two features significally speed up the initial phase of a Rails project by
doing in minutes what took you weeks. After modeling your application, which
typically takes about an hour, you can instantly start implementing the meat of
your application.

`Katapult` will only support current versions of Ruby and Rails, currently
Rails 4.2 and Ruby 2.3.


## Installation

Install the `katapult` gem with

    gem install katapult

If you intend to extend an existing application, add it to the development group
in your Gemfile.


## Usage

`Katapult` does two separate things:

1. It creates a new Rails application, set up with many standard gems, snippets,
   useful configuration, databases, testing libraries etc. See the [BasicsGenerator](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb) for details.
2. It generates code from an application model, i.e. creates files for models,
   views, controllers, routes, stylesheets; see the

You may use both or only one of them.


## 1) Creating a new Rails application

Run the following command:

    katapult new $APPLICATION_NAME

This will:
 
- create a new Rails application
- install common Gems
- set up a `database.yml` file (for PostgreSQL)
- create basic styles
- install RSpec and Cucumber to the application
- install Capistrano
- create `lib/katapult/application_model.rb` (needed for step 2)

See the [BasicsGenerator](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
for details: Its methods are executed one-by-one and their names are a
description of what it does.

### Alternative: Using Katapult in existing Rails applications
`katapult` expects a clean application (that it would usually generate itself).
If you have an existing Rails application, you *may* use `katapult`, but be
warned: it is not designed to respect existing files, although it will usually
ask before overwriting anything.

After adding it to the Gemfile (see above), run any of the following generators:

    rails generate katapult:basics # Prepare the app with useful defaults
    rails generate katapult:install # Create application model file
    rails generate katapult:transform lib/katapult/application_model.rb


## 2) Generating code from an application model

> If you only want to use the code generation feature of `katapult`, but did not
> run `katapult new ...`, you need to add `katapult` to your Gemfile now and
> install it with `rails generate katapult:install`. See above.

After installation, you will find a file `lib/katapult/application_model.rb`
where you will define the properties of your application. You're free to create
more than one application model, however, you'll need to specify their location
when running the transform.

Inside the application model, use `katapult`'s simple DSL (domain specific
language) to express yourself. When you are done developing the model, transform
it into code with:

    katapult fire [path/to/application_model]

See an overview of the DSL below. The respective sections hold examples of what
options are available to each element. For details, dive into
`lib/generators/katapult` where all generators are stored. The method names
inside a generator tell what it does.

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

    # Inferred type :password. Password fields are rendered as password_field in
    # forms, but never rendered in show views.
    model.attr :password
    
    # Specify assignable values. Available options: allow_blank, default
    model.attr :age, type: :integer, assignable_values: 18..99, allow_blank: true
    
    # Will be rendered as number_field in forms, and with a € sign in show views
    model.attr :income, type: :money
    
    # All attribute types take an optional default
    model.attr :homepage, type: :url, default: 'http://www.makandra.de'
    
    # Boolean fields are modeled as flags. Default required!
    model.attr :locked, type: :flag, default: false

    # JSON fields are supported
    model.attr :prefer, type: :json # PostgreSQL "jsonb"
    model.attr :avoid, type: :plain_json # PostgreSQL "json"


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


### Authenticate
Takes the name of the user model (currently only `User` (case-insensitive) is
supported) and an email address. Generates authentication with [Clearance](https://github.com/thoughtbot/clearance).

    authenticate 'User', system_email: 'system@example.com'

The email address will be the sender for Clearance mails like password reset
requests.


## Development

### Basic information
`Katapult` is tested with [RSpec](http://rspec.info/) and
[Cucumber](https://cucumber.io/) + [Aruba](https://github.com/cucumber/aruba)
([API-Doc](http://www.rubydoc.info/github/cucumber/aruba/master/)).

It caches a pristine Rails application inside its `tmp/` directory to
speed up test runs. Keep this in mind, as it may lead to caching issues when
switching Ruby versions or installing a new version of the Rails gem.

Since `katapult` has full-stack integration tests, it requires a PostgreSQL
account. Create a dedicated account on your local PostgreSQL server:

    $> sudo -iu postgres
    postgres $> psql
    postgres=# CREATE ROLE katapult WITH createdb LOGIN;

### Continuing development
When you continue development on `katapult`, you first need to update a couple
of things. `script/update` will guide you through the process.

### Debugging
Add the `@announce-output` tag to `katapult` features in order to have any output
logged to your terminal.

To precisely debug errors occurring _inside_ the generated application, use
`script/kta`. You could also just cd to the test app directory, but since it is
destroyed between test runs, you'd need to `cd ../../aruba/katapult_test_app`
after each test.

When fixing issues in the generated app, make a commit in the app first. When
you've fixed it, the diff will show you what you need to port back to katapult.

### Typical errors
- Timeout error because of a script waiting for user input
- Executing (bash) commands in the test application without resetting the
  katapult gem's Bundler settings. Wrap into `Bundler.with_clean_env { }`.
- Spring running inside the test application encumbers parallel_tests
- An outdated Rails application in `tmp/cached_test_app`


## Credits

Development: Dominik Schöler from [makandra](makandra.com)<br />
Katapult image: [Nemo](http://pixabay.com/de/katapult-30061)
