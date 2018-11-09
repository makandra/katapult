# Katapult 0.5.0
Generating a Rails 5.1.4 app on Ruby 2.5.0.

<img src="katapult.png" width="200px" align="right" />


Katapult is a kickstart generator for Rails. It prepares a new
application with [lots of pre-configuration](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
and offers [makandra-flavored](https://leanpub.com/growing-rails) code
generation from an application model. This significantly speeds up the initial
phase of Rails development by doing in minutes what would cost you weeks. When
Katapult has finished, you can instantly start implementing the interesting
parts of your application.


## Prerequisites

Katapult uses *PostgreSQL* as database, so you'll need to install that upfront.
Also, it drops the Rails asset pipeline in favor of *Webpacker*, so you'll need
*Node* and *Yarn* (see <https://makandracards.com/makandra/47477>).

The required *Ruby* version is 2.5.0. You'll need the *Bundler* and *Rake* gems,
which are probably already installed on your system.

When you're using the `katapult` binary (you should), you'll also need *Git*.


## Installation

    gem install katapult


## Usage

There are two usage scenarios for Katapult:

1. Starting a fresh Rails application
2. Extending an existing Rails application

Choose your use case and read on below.


## Starting a fresh Rails application

To create a new Rails application with Katapult, run the following command:

    katapult new $APPLICATION_NAME

This will create a new Rails application, prepared and configured: bundled,
database set up, RSpec, Cucumber and Capistrano installed and much more.
Please read the [BasicsGenerator](https://github.com/makandra/katapult/blob/master/lib/generators/katapult/basics/basics_generator.rb)
for details (its methods are executed one-by-one from top to bottom).

When Katapult is done, you will find a default application model in
`lib/katapult/application_model.rb`. It contains a full example of Katapult's
DSL that you can use as an inspiration for creating your own application model.

Next, check the templates in `lib/templates/katapult`. They will be used
to generate the corresponding files, e.g. HAML views. Please modify the templates
to match your requirements. (Actually, you can customize much more templates.
Each template in Katapult's `lib/generators/katapult/<generator>/templates/` can
be overridden with a file at `lib/templates/katapult/<generator>/` in your
application.)

When your application model and the templates are ready, let Katapult generate
your code:

    katapult fire

This will create models, migrations, views, styles, controllers, routes,
Cucumber features, specs, factories and more. It will also commit the results
and migrate the database.

When this is done, your application is ready to use! Start a development
server and try it out.


## Extending an existing Rails application

You can use Katapult for code generation in an existing application as well.

First, add Katapult to the development group in your Gemfile:
```
  gem 'katapult'
```

Next, generate the default application model:

```
bundle exec rails generate katapult:app_model
```

You'll find the application model at `lib/katapult/application_model.rb`. It
contains a full example of Katapult's features: Use it as an inspiration for
modeling your own application. (When you're used to the application model DSL,
you don't need to generate the default model. Just create a Ruby file and start
modeling.)

Next, copy Katapult's template files to your application:

```
katapult templates
```

This will copy some of Katapult's file templates to `lib/templates/katapult`.
Modify them, especially the view templates, to match the current state of your
application. You can customize even more templates, see the "Starting …" section
above.

When model and templates are ready, trigger code generation with:

```
katapult fire path/to/your_model.rb
```


## DSL reference

Below you find an overview of the application model DSL. The respective sections
hold examples of what options are available to each element. For details, dive
into the respective generator at `lib/generators/katapult/*/*_generator.rb`. The
method names of a generator tell what it does.

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
    
    # Inferred type :email (attribute name matches /email/)
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
([API documentation](http://www.rubydoc.info/github/cucumber/aruba/master/)).

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
higher level by passing them a model object instead
of plain text arguments. This way, the Katapult generators can explore the whole
application model and are not restricted to a few strings they've been given.

There are a few "public" Rails generators. They can be considered the next API
level after the `katapult` binary:

- `katapult:basics`: Enhances a pristine Rails app with all of the
  basic configuration.
- `katapult:app_model`: Installs a boilerplate application model that
  serves as a starting point for modeling an application.
- `katapult:templates`: Copies some generator templates to the target
  application.
- `katapult:transform`: Parses the application model into an internal
  representation, which will be turned into code by all the other generators.

Note that the `katapult` binary is the only Rails-independent part of Katapult.
Everything else runs in the context of the Rails application.

### Suggested workflow
When adding a feature to Katapult, it will usually take you some time to
figure out how exactly the generated code should look like. You'll be switching
between Katapult's tests, its generators and the generated code.

Here's a process for building larger code generation features:

1) **Start with a test:** Create a Cucumber scenario that creates and transforms
   an application model. Also, write a first draft of the code that generates
   what you expect.
2) Run your scenario. This will transform your test application model.
3) Make a commit inside the generated test application, so you'll have a clean
   working directory: `script/kta git add --all && script/kta git commit -m 'x'`
4) **Modify the generated code** inside the generated test application until it
   meets your expectations. If you like, boot a development server with
   `script/kta rails s`.
5) **Finish your test:** Once you've figured how the generated code should look
   like, it's time to write steps that test it. For this purpose, tag your
   scenario with @no-clobber and comment out the model transformation step. This
   will leave the generated test app untouched in subsequent test runs, so you
   will be able to run your scenario repeatedly, without losing what you've
   built, until you have covered every change. Use `git diff` in the test app to
   see your changes.
6) **Write code:** When you've completed your scenario, write the code that
   generates what is needed to satisfy the test.
7) Remove the @no-clobber tag and uncomment the transformation step. Stop the
   development server if you've started one.
8) Run your scenario normally and iterate over your code generation code until
   your scenario is green.

### Guidelines
Please respect the following guidelines during development:

- The application model should be order-agnostic. There is a #prepare_render
  method in `ApplicationModel` for things that need to happen between parsing
  and rendering the application model.
- Transformation should be idempotent: it should be possible to generate the
  application model over and over again without crashing or breaking things.

### Debugging
Add the `@announce-output` tag to Katapult scenarios in order to have output
logged to your terminal. Note that each step will print all output to date, so
you will see things multiple times.

To precisely debug errors occurring _inside_ the generated application, use
`script/kta`. It is a helper script that will execute whatever command you pass
it, but in the directory of the generated application. While you could cd to the
test app and run your command there, you'd need to `cd ../../aruba/katapult_test_app`
between test runs, because the tmp/aruba directory gets wiped before each test.

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
