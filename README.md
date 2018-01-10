# Katapult

<img src="katapult.png" width="200px" align="right" />


`Katapult` is a kickstart generator for Rails applications. It creates new Rails
applications with [lots of pre-configuration](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
and offers [makandra-flavored](https://leanpub.com/growing-rails) code
generation from an application model. These two features significally speed up
the initial phase of a Rails project by doing in minutes what otherwise would
cost you weeks.
After modeling your application, which typically takes about an hour, you can
instantly start implementing the meat of your application.

`Katapult` only supports a single Ruby and Rails version, currently it's Rails
5.1.4 and Ruby 2.5.0.


## Prerequisites

Katapult uses *PostgreSQL* as database, so you'll need to install that upfront.
Also, it drops the asset pipeline in favor of *Webpacker*, so you'll need Node
and Yarn (see <https://makandracards.com/makandra/47477>).

Also, it requires the *Bundler* and *Rake* Ruby gems, which are probably already
installed on your system.


## Installation

Install the `katapult` gem with

    gem install katapult

If you intend to extend an existing application, add it to the development group
in your Gemfile.


## Usage

`katapult` does two distinct things for you:

1. It creates a new Rails application, set up with many standard gems, snippets,
   useful configuration, databases, testing libraries etc.
2. It generates code from an application model, i.e. it creates models and
   views, controllers, styles etc. 

You may use both or only one of them. Read on for details.


## 1) Creating a new Rails application

Run the following command:

    katapult new $APPLICATION_NAME

This will create a new Rails application and prepare it in more than 20 steps.
Read the [BasicsGenerator](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
for details: Its methods are executed one-by-one, while the method names are a
description of what they do.

### Alternative: Using Katapult in an existing Rails application
`katapult` expects a fresh application (which it would usually generate itself).
If you have an existing Rails application, you *may* use `katapult`, but be
warned: it is not designed to respect existing files, although it will usually
ask before overwriting something.

After adding it to the Gemfile, run the basics generator manually:

    bin/rails generate katapult:basics


## 2) Generating code from an application model

After running `katapult new`, you will find a default application model in
 `lib/katapult/application_model.rb`. It contains a full example of `katapult`'s
features that you should replace with _your_ application model.

When you are done, transform the model using:

    katapult fire [path/to/application_model]

The path is optional and only needs to be specified when you've renamed the
application model file. Note that you may well use separate model files for
separate runs.

See an overview of the DSL below. The respective sections hold examples of what
options are available to each element. For details, dive into
`lib/generators/katapult` where all generators are stored. The method names
of a generator tell what it does.

### Generic DSL syntax example
The DSL consists of _elements_, e.g. `Model` or `WebUI`. Each `katapult` element
has the following syntax, taking a name, options, and a block:

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


### WebUI
Takes a name, options and a block:

    web_ui 'Customer', model: 'User' do |web_ui|
      web_ui.crud # Create all the standard rails actions

      # web_ui.action :custom etc, see Action element
    end

    # Short syntax with inferred model name 'User'
    web_ui 'User', &:crud


#### Action
Defined on WebUI. Takes a name and options:

    # Select single Rails actions
    web_ui.action :index
    web_ui.action :show
    web_ui.action :create # also creates :new
    web_ui.action :update # also creates :edit
    web_ui.action :destroy
    
    # Add custom actions
    web_ui.action :custom_action, method: :post, scope: :member
    web_ui.action :other_action, method: :get, scope: :collection
    
### Crud
This is a shortcut for creating a model together with a WebUI with CRUD actions.

    crud 'Customer' do |customer|
      customer.attr :name
    end


### Navigation
No arguments, will generate a main menu with links to the index pages of all
WebUIs.

    navigation


### Authenticate
Takes the name of the user model (currently only `User` is supported) and an
email address. Generates authentication with [Clearance](https://github.com/thoughtbot/clearance).

    authenticate 'User', system_email: 'system@example.com'

The email address will be the sender for Clearance mails like password reset
requests.


## Development

### Getting started + continuing development
`Katapult` is tested with [RSpec](http://rspec.info/) and
[Cucumber](https://cucumber.io/) + [Aruba](https://github.com/cucumber/aruba)
([API-Doc](http://www.rubydoc.info/github/cucumber/aruba/master/)).

For its full-stack integration tests, `katapult` requires a PostgreSQL account.
Create a dedicated account on your local PostgreSQL server:

    $> sudo -u postgres psql
    postgres=# CREATE ROLE katapult WITH createdb LOGIN;

Whenever you start working on `katapult`, you should run `script/update`, which
will guide you through a quick update process.

### Suggested workflow
When adding a feature to `katapult`, it will usually take you some time to
figure out how exactly the generated code should look like. You'll be switching
between `katapult`'s tests, its generators and the generated code.

Here's a the suggested process:

1) Run a scenario (create one if needed)
2) Tag that scenario with @no-clobber. This will leave the generated test app
   untouched in subsequent test runs.
3) Make a commit inside the generated test application, so you'll have a clean
   working directory: `script/kta git add --all && script/kta git commit -m 'x'`
4) Modify the test app as needed. Boot a development server with
   `script/kta rails s` if you like.
5) Re-run the @no-clobber scenario (modify it as needed) until test and test app
   meet the expectations.
6) Now look at the git diff in the test app and model everything with katapult's
   generators.
7) Remove the @no-clobber tag and run the scenario normally to see if it's still
   green. Remember to stop the development server first.

### Debugging
Add the `@announce-output` tag to `katapult` features in order to have any output
logged to your terminal. Note that each step will print all output to date, so
you will see things multiple times.

To precisely debug errors occurring _inside_ the generated application, use
`script/kta`. You could also just cd to the test app directory, but since it is
destroyed between test runs, you'd need to `cd ../../aruba/katapult_test_app`
after each test.

When fixing issues in the generated app, make a commit in the app first. When
you've fixed it, the diff will show you what you need to port back to katapult.

### Typical issues
Be sure to check this list when you encounter strange issues during development.

- Spring was running in a directory that does not exist any more. This will
  screw subsequent spring invocations. Run `ps aux | grep spring` and `kill`
  suspect processes.
- An outdated Rails application in `tmp/cached_*`
- Timeout error because of a script waiting for user input

### Fast tests
Generating basics and transforming the application model take quite some time
(about 20s), because it boots the Rails application, resolves Yarn dependencies
and migrates databases. To speed that up, `katapult` tests cache prepared Rails
applications in tmp/.

When debugging test suite speed, `bundle exec cucumber --format usage` is your
friend.


## Credits

Development: Dominik Schöler from [makandra](makandra.com)<br />
Katapult image: [Nemo](http://pixabay.com/de/katapult-30061)
