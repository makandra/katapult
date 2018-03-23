# Katapult 0.4.1
Generating a Rails 5.1.4 app on Ruby 2.5.0.

<img src="katapult.png" width="200px" align="right" />


Katapult is a kickstart generator for Rails applications. It creates new Rails
applications with [lots of pre-configuration](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
and offers [makandra-flavored](https://leanpub.com/growing-rails) code
generation from an application model. These two features significally speed up
the initial phase of a Rails project by doing in minutes what otherwise would
cost you weeks.
After modeling your application, which takes about an hour, you can instantly
start implementing the meat of your application.


## Prerequisites

Katapult uses *PostgreSQL* as database, so you'll need to install that upfront.
Also, it drops the Rails asset pipeline in favor of *Webpacker*, so you'll need
*Node* and *Yarn* (see <https://makandracards.com/makandra/47477>).

The required *Ruby* version is 2.5.0. You'll need the *Bundler* and *Rake* gems,
which are probably already installed on your system.


## Installation

Install the `katapult` gem with

    gem install katapult

If you intend to extend an existing application, add it to the development group
in your Gemfile.


## Usage

Katapult does two distinct things for you:

1. It creates a new Rails application, prepared with gems, snippets,
   configuration, databases, testing libraries etc.
2. It generates code from an application model, i.e. it generates models and
   views, controllers, styles etc. 

You may use both or only one of them. Read on for details.


## 1) Creating a new Rails application

To get started, run the following command:

    katapult new $APPLICATION_NAME

This will create a new Rails application and prepare it in more than 20 steps.
Read the [BasicsGenerator](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
for details: Its methods are executed one-by-one, while the method names are a
description of what they do.

#### Alternative: Using Katapult in an existing Rails application
Katapult generates a fresh application. If you have an existing Rails
application, you *may* use Katapult to configure it.
Be warned: it is not designed to respect existing files, although it will usually
ask before overwriting something.

After adding it to the Gemfile, invoke the basics generator manually:

    bin/rails generate katapult:basics


## 2) Generating code from an application model

After running `katapult new`, you will find a default application model in
 `lib/katapult/application_model.rb`. It contains a full example of Katapult's
features that you can use as an inspiration for creating _your_ application model.

When your application model is ready, transform it using:

    katapult fire [path/to/application_model]

The path is optional and defaults to the generated application model. If you
later want to extend your application, you may create a second application model
and invoke `katapult fire` with its path.

Below you find an overview of the application model DSL. The respective sections
hold examples of what options are available to each element. For details, dive
into `lib/generators/katapult` where all generators are stored. The method names
of a generator tell what it does.

### Generic DSL syntax example
The DSL consists of _elements_, e.g. `Model` or `WebUI`. Each Katapult element
has the following syntax, taking a name, options, and a block:

    element_type 'name', options: 'example' do |element|
      element.some_method
    end

### Crud
Shortcut for creating a model together with a WebUI with CRUD actions. The block
is passed the model instance.

    crud 'Customer' do |customer|
      # customer.attr :name
    end


### Model
Takes a name and a block. Generates a Rails model, a migration, and a spec.

    model 'Customer' do |customer|
      # customer.attr :name etc, see Attribute element
      # customer.belongs_to :group, see Association element
    end


#### Attribute
Defined on Model; takes a name and options. Adds a database field in the model
migration, form fields in a WebUI, and configuration code in the model as
needed.

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


#### Association
Defined on Model; takes the name of another model (just as you called it in the
application model). Adds a foreign key attribute to the model and `belongs_to`/`has_many`
calls to the respective models.

    model 'Customer' do |customer|
      customer.belongs_to 'Group'
    end

    model 'Group'


### WebUI
Takes a name, options and a block. Generates controller, routes, views, and a
passing Cucumber feature.

    web_ui 'Customer', model: 'User' do |web_ui|
      web_ui.crud # Create all the standard rails actions
      # web_ui.action :custom etc, see Action element
    end

    # Short syntax with inferred model name 'User'
    web_ui 'User', &:crud


#### Action
Defined on WebUI; takes a name and options. Adds an action to the controller,
and a route as needed.

    # Select single Rails actions
    web_ui.action :index
    web_ui.action :show
    web_ui.action :create # also creates :new
    web_ui.action :update # also creates :edit
    web_ui.action :destroy
    
    # Add custom actions
    web_ui.action :custom_action, method: :post, scope: :member
    web_ui.action :other_action, method: :get, scope: :collection
    

### Navigation
Generates a main menu with links to the index pages of all WebUIs.

    navigation


### Authenticate
Takes the name of the user model (currently only `User` is supported) and an
email address. Generates authentication with [Clearance](https://github.com/thoughtbot/clearance).

    authenticate 'User', system_email: 'system@example.com'

The given email address will be configured as the sender for all mails sent by
Rails, including Clearance mails like password reset requests.


## Development

### Getting started
`Katapult` is tested with [RSpec](http://rspec.info/) and
[Cucumber](https://cucumber.io/) + [Aruba](https://github.com/cucumber/aruba)
([API-Doc](http://www.rubydoc.info/github/cucumber/aruba/master/)).

For its full-stack integration tests, Katapult requires a PostgreSQL account.
Create a dedicated account on your local PostgreSQL server:

    $> sudo -u postgres psql
    postgres=# CREATE ROLE katapult WITH createdb LOGIN;


### Continuing Development
Whenever you start working on Katapult, you should run `script/update`, which
will guide you through a quick update process.

### Architecture
Katapult's code is roughly split into three parts: the `katapult` binary in bin/,
the model in lib/katapult/ and the generators in lib/generators. Also, there
is a script/ directory that holds some scripts to simplify development. It is not
included in the `katapult` gem.

The generators of Katapult extend the `rails/generators` you probably know
from generating migration files or scaffolds. However, Katapult lifts them on a
new level by invoking them programmatically with a model object instead
of plain text arguments. This way, the Katapult generators can explore the whole
application model and are not restricted to a few string's they've been given.

There are three Rails generators that are intended for invocation from bash.
They can be considered the next-lower level API of Katapult:

- `katapult:basics` generator: Enhances a pristine Rails app with all of the basic
  configuration Katapult brings.
- `katapult:app_model` generator: Installs a boilerplate application model that serves as
  a starting point for modeling your own application.
- `katapult:transform` generator: Parses the application model into an internal
  representation, which will be turned into code by all the other generators.

Note that the `katapult` binary is the only Rails-independent part of Katapult;
everything else runs in the context of the Rails application.

### Suggested workflow
When adding a feature to Katapult, it will usually take you some time to
figure out how exactly the generated code should look like. You'll be switching
between Katapult's tests, its generators and the generated code.

Here's a process for building larger code generation features:

1) **Start with a test:** Create a Cucumber scenario that creates and transforms
   an application model. Also, write a first draft of the code that generates
   what you expect.
2) Run your scenario.
3) Make a commit inside the generated test application, so you'll have a clean
   working directory: `./t git add --all && ./t git commit -m 'x'`
4) **Tune the generated code to meet your expectations.** Boot a development
   server with `./t rails s` if you like.
5) **Finish your test:** Once you've figured how the generated code should look
   like, it's time to write steps that test it. For this purpose, tag your
   scenario with @no-clobber and comment out the model transformation step. This
   will leave the generated test app untouched in subsequent test runs, so you
   will be able to run your scenario repeatedly, without losing what you've
   built, until you have covered every change. Use `git diff` in the test app to
   see your changes.
6) **Write code:** When you've completed your scenario, write the code that
   generates what is needed to satisfy the test.
7) Remove the @no-clobber tag and comment in the transformation step. Stop the
   development server if you've started one.
8) Run your scenario normally and iterate over your code generation code until
   your scenario is green.

### Guidelines
Please respect the following guidelines during development:

- The application model should be order-agnostic. There is a #prepare_render
  method in `ApplicationModel` for things that need to happen between parsing
  and rendering the application model.
- The application model should be idempotent, meaning it should be possible to
  generate it over and over again without breaking code.

### Debugging
Add the `@announce-output` tag to Katapult features in order to have any output
logged to your terminal. Note that each step will print all output to date, so
you will see things multiple times.

To precisely debug errors occurring _inside_ the generated application, use
`./t`. It is a helper script that will execute whatever command you pass
it, but in the directory of the generated application. While you could cd to the
test app and run your command there, you'd need to `cd ../../aruba/katapult_test_app`
after each test run, because the tmp/aruba directory gets wiped before each test.

When fixing issues in the generated app, make a commit in the app first. When
you've fixed it, the diff will show you what you need to port back to katapult.

#### Typical issues
Be sure to check this list when you encounter strange issues during development.

- Spring was running in a directory that does not exist any more. This will
  screw subsequent spring invocations. Run `ps aux | grep spring` and `kill`
  suspect processes.
- An outdated Rails application in `tmp/cached_*`
- Timeout error because of a script waiting for user input

#### Fast tests
Generating basics and transforming the application model take quite some time
(about 20s), because it boots the Rails application, resolves Yarn dependencies
and migrates databases. To speed that up, Katapult tests cache prepared Rails
applications in tmp/.

When debugging test suite speed, `bundle exec cucumber --format usage` is your
friend.


## Credits

Development: Dominik Schöler from [makandra](makandra.com)<br />
Katapult image: [Nemo](http://pixabay.com/de/katapult-30061)
