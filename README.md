# Golden Mall

Golden Mall is an online shopping application.

## Features

- User can browse products by categories
- User can add product to cart or buy instantly (login required)
- User can select items to checkout
- User can choose payment method (COD or PayPal)
- User can open their own shop
- User can add a product or many products with a csv file. (shop required)
- Shops and orders created will also be created on GHN server
- User can rate products which is in completed orders

## Tech

Dillinger uses a number of open source projects to work properly:

- [Ruby] (v3.1.1) - A dynamic, open source programming language.
- [Ruby on Rails] (v6.1.6) - A full-stack framework, ships with all the tools needed.
- [PostgreSQL] (v1.1) - A powerful, open source object-relational database system.
- [Bootstrap] (v5.1) - The most popular CSS Framework for developing responsive and mobile-first websites.
- [jQuery] (v3.6.0) - jQuery is a fast, small, and feature-rich JavaScript library. 
- [Sidekiq] (v6.4.2) - Simple, efficient background processing for Ruby.


## Installation

- Install the correct ruby version: `rbenv local 3.1.1`
- Install Node.js (> v8.16.0) and Yarn
- Install Rails: `gem install rails -v 6.1.6`
- Install bundler: `gem install bundler`
- Install gems: `bundle install`
- Config database at `config/database.yml`
- Add `.env` file
- Setup database: `rails db:setup`
- Start web server: `rails server`
- Start webpack server: `bin/webpack-dev-server`
- Start sidekiq: `bundle exec sidekiq`


## License

This is an intern project at [Golden Owl Consulting](https://goldenowl.asia/).

[Ruby]: <https://www.ruby-lang.org/en/>
[Ruby on Rails]: <https://rubyonrails.org/>
[PostgreSQL]: <https://www.postgresql.org/>
[Bootstrap]: <https://getbootstrap.com/docs/5.1/getting-started/introduction/>
[jQuery]: <http://jquery.com>
[Sidekiq]: <https://github.com/mperham/sidekiq/>
    
