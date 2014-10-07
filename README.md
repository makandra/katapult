# Wheelie

Wheelie is a kickstart framework for Rails applications. It makes starting
Rails applications a bliss.

Wheelie will always support current Versions of Ruby and Rails, at the moment
it's Rails 4.1 and Ruby 2.1.

## Installation

As Wheelie is designed to *start* Rails applications, it works best with a
clean new Rails app. To create one, run

    rails new choose_your_name

Add `gem 'wheelie'` to the Gemfile, `bundle` and then run

    rails generate wheelie:install

This will create `lib/wheelie/application_model.rb` where you will draft your
application.


## Usage

After installation, you'll find a file `lib/wheelie/application_model.rb` where
you will define the fundamentals of your application. Inside this file, you'll
use Wheelie's simple DSL (domain specific language) to express yourself.

Wheelie brings several basic elements: Model, Attribute, WUI (which stands for
*Web User Interface*) and Action. Each Wheelie element has the same syntax,
taking a name, options and a block:

    element 'name', options: 'go here' do |element|
      element.method
    end


### Model
Takes a name and a block:

    model 'Customer' do |customer|
      # ...
    end


#### Attribute
Defined on Model. Takes a name and options:

    model.attr :email
    model.attr :age, type: :integer
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
    wui.action :create
    wui.action :update
    wui.action :destroy
    wui.action :custom_action, method: :post, scope: :member
    wui.action :other_action, method: :get, scope: :collection


## Contributing

<!-- 1. Fork it ( http://github.com/<my-github-username>/wheelie/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request -->

Wheelie caches a pristine Rails application inside its `tmp/` directory to speed up testing. Keep this in mind, as it may lead to issues when switching Ruby versions or installing a new version of the Rails gem.

Since Wheelie has full-stack integration tests, it requires a MySQL account. Create a dedicated account by running this command in a MySQL console (as-is):

    GRANT ALL ON *.* TO 'wheelie'@'localhost' IDENTIFIED BY 'secret';

The user `wheelie` is hereby granted any action (SELECT, UPDATE, etc. except for granting privileges) on any database and table (`*.*`).


## Credits

Development: Dominik Schöler from [makandra](makandra.com)
Katapult image: [Nemo](http://pixabay.com/de/katapult-30061)
