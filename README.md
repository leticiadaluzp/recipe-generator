## How to use

1. Clone this repo
1. Install PostgreSQL in case you don't have it
1. Install node and yarn. Expected node version ">=16 || 14 >=14.17".
1. Run `yarn install` and `yarn build --watch`. This bundles the JS assets in the administration site using [esbuild](https://github.com/evanw/esbuild).
1. `bundle exec rspec` and make sure all tests pass (non-headless mode) or `HEADLESS=true bundle exec rspec` (headless mode)
1. `rails assets:precompile` to precompile assets
1. Run `bin/dev`.
1. You can now try your REST services!

## Dev scripts

This template provides a handful of scripts to make your dev experience better!

- bin/bundle to run any `bundle` commands.
  - `bin/bundle install`
- bin/rails to run any `rails` commands
  - `bin/rails console`
- bin/web to run any `bash` commands
  - `bin/web ls`
- bin/rspec to run specs
  - `bin/rspec .`
- bin/dev to run both Rails and JS build processes at the same time in a single terminal tab.
  - `bin/dev`

You don't have to use these but they are designed to run the same when running with Docker or not.
To illustrate, `bin/rails console` will run the console in the docker container when running with docker and locally when not.

## Gems

- [ActiveAdmin](https://github.com/activeadmin/activeadmin) for easy administration
- [Arctic Admin](https://github.com/cprodhomme/arctic_admin) for responsive active admin
- [Annotate](https://github.com/ctran/annotate_models) for documenting the schema in the classes
- [Better Errors](https://github.com/charliesome/better_errors) for a better error page
- [Brakeman](https://github.com/presidentbeef/brakeman) for security static analysis
- [Byebug](https://github.com/deivid-rodriguez/byebug) for debugging
- [DelayedJob](https://github.com/collectiveidea/delayed_job) for background processing
- [Devise](https://github.com/plataformatec/devise) for basic authentication
- [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) for API authentication
- [Dotenv](https://github.com/bkeepers/dotenv) for handling environment variables
- [Draper](https://github.com/drapergem/draper) for decorators
- [Factory Bot](https://github.com/thoughtbot/factory_bot) for testing data
- [Faker](https://github.com/stympy/faker) for generating test data
- [Flipper](https://github.com/jnunemaker/flipper) for feature flag support
- [Jbuilder](https://github.com/rails/jbuilder) for JSON views
- [JS Bundling](https://github.com/rails/jsbundling-rails) for bundling JS assets
- [Knapsack](https://github.com/KnapsackPro/knapsack) for splitting tests evenly based on execution time
- [Letter Opener](https://github.com/ryanb/letter_opener) for previewing emails in the browser
- [New Relic](https://github.com/newrelic/newrelic-ruby-agent) for monitoring and debugging
- [Oj](https://github.com/ohler55/oj) for optimized JSON
- [Pagy](https://github.com/ddnexus/pagy) for pagination
- [Parallel Tests](https://github.com/grosser/parallel_tests) for running the tests in multiple cores
- [Prosopite](https://github.com/charkost/prosopite) to detect N+1 queries
- [Pry](https://github.com/pry/pry) for enhancing the Ruby shell
- [Puma](https://github.com/puma/puma) for the web server
- [Rack CORS](https://github.com/cyu/rack-cors) for handling CORS
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices) for Rails linting
- [Reek](https://github.com/troessner/reek) for Ruby linting
- [RSpec](https://github.com/rspec/rspec) for testing
- [RSpec OpenAPI](https://github.com/exoego/rspec-openapi) for generating API documentation
- [Rswag](https://github.com/rswag/rswag) for serving the API documentation
- [Rubocop](https://github.com/bbatsov/rubocop/) for Ruby linting
- [Sendgrid](https://github.com/stephenb/sendgrid) for sending emails
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for other testing matchers
- [Simplecov](https://github.com/colszowka/simplecov) for code coverage
- [Strong Migrations](https://github.com/ankane/strong_migrations) for catching unsafe migrations in development
- [Webmock](https://github.com/bblimke/webmock) for stubbing http requests
- [YAAF](https://github.com/rootstrap/yaaf) for form objects

## Code quality

With `bundle exec rails code:analysis` you can run the code analysis tool, you can omit rules with:

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Reek](https://github.com/troessner/reek#configuration-file) Edit `config.reek`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`

## Credits

Rails Template for Learning Camp is maintained by [Rootstrap](http://www.rootstrap.com)

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
