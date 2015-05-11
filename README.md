# Katapult

<img src="katapult.png" width="200px" align="right" />


`Katapult` is a kickstart generator for Rails applications. It creates
application basics and generates (makandra-flavored) code from an application
model, significantly speeding up the initial phase of a Rails project.

`Katapult` will always support current versions of Ruby and Rails, currently
Rails 4.2 and Ruby 2.1.


## Installation

As `katapult` is designed to *start* Rails applications, it works best with a
clean new Rails app. To create one, run

    katapult target MY_APPLICATION_NAME

This will add the `katapult` gem to the Gemfile and then integrate `katapult`
by running

    rails generate katapult:install
    rails generate katapult:basics


It will install application basics, such as a `database.yml`, basics styles as
well as RSpec and Cucumber and prepare `lib/katapult/application_model.rb`
where you will draft your application.

### Manual installation
You may also integrate the gem into an existing Rails application. Just add it to the Gemfile and run the generators stated above.


## Usage

After installation, you find a file `lib/katapult/application_model.rb` where
you will define the properties of your application. Inside this file, use
`katapult`'s simple DSL (domain specific language) to express yourself.

The DSL consists of elements, e.g. Model or WUI (which stands for *Web User
Interface*). Each `katapult` element has the same syntax, taking a name,
options, and a block:

    element_type 'name', options: 'example' do |element|
      element.some_method
    end


### Model
Takes a name and a block:

    model 'Customer' do |customer|
      # ...
    end


#### Attribute
Defined on Model. Takes a name and options:

    model.attr :email
    model.attr :age, type: :integer, assignable_values: 18..99, allow_blank: true
    model.attr :income, type: :money
    model.attr :homepage, type: :url, default: 'http://www.makandra.de'
    model.attr :locked, type: :flag, default: false


### WUI (Web User Interface)
Takes a name, options and a block:

    wui 'Customer', model: 'User' do |wui|
      # ...
    end


#### Action
Defined on WUI. Takes a name and options:

    wui.action :index
    wui.action :show
    wui.action :create # also creates :new
    wui.action :update # also creates :edit
    wui.action :destroy
    wui.crud   # creates all the standard rails actions above
    wui.action :custom_action, method: :post, scope: :member
    wui.action :other_action, method: :get, scope: :collection


### Navigation
Takes a name, will generate a navigation with links to the index pages of all
WUIs.

    navigation :main


## Contributing

<!-- 1. Fork it ( http://github.com/<my-github-username>/katapult/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request -->

`Katapult` caches a pristine Rails application inside its `tmp/` directory to
speed up test runs. Keep this in mind, as it may lead to caching issues when
switching Ruby versions or installing a new version of the Rails gem.

Since `katapult` has full-stack integration tests, it requires a MySQL account.
Create a dedicated account on your MySQL server by running this command in a
MySQL console (as-is):

    GRANT ALL ON *.* TO 'katapult'@'localhost' IDENTIFIED BY 'secret';

The user `katapult` is hereby granted any action (SELECT, UPDATE, etc. except
for granting privileges) on any database and table (`*.*`).


## Credits

Development: Dominik Schöler from [makandra](makandra.com)<br />
Katapult image: [Nemo](http://pixabay.com/de/katapult-30061)
