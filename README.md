[![Build Status](https://secure.travis-ci.org/amkirwan/moustache-cms.png)](http://travis-ci.org/amkirwan/moustache-cms) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/amkirwan/moustache-cms)

# Moustache CMS

Moustache CMS is a open source content management system designed for creating great sites and blogs. It features an easy to use interface for putting your site together and managing your content. With the power of [Mustache](https://github.com/defunkt/mustache) for templating Moustache CMS can be easily customized to for your sites needs.

Moustache features: 

- A good looking easy to use UI
- A highly flexible templating system of layouts, snippets, page parts and tagging done with [Mustache](https://github.com/defunkt/mustache).
- Support for Markdown, Textile, and HTML for page part templating. 
- Manage multiple websites in one application instance
- Ability to assign different roles to users
- Built using Ruby on Rails 3.2
- MongoDB for Database 

## Getting Started Quickly

- A recent version of MongoDB >= 2.0 installed and running. On Mac OS X you can use [Homebrew](http://mxcl.github.com/homebrew) to install Mongodb
- Then clone the repo 
```
git clone git://github.com/amkirwan/moustache-cms.git.
```
- Then from the project root run bundler
```
cd moustache-cms
bundle install 
```
- Next setup the default database from the seed file. This will create a default admin login account with the login email of 'admin@moustachecms.org' and the password set to 'moustache'
```
bundle exec rake db:seed
```
- You can access MoustacheCms now in two ways. If you are using [POW](https://github.com/37signals/pow) create an symlink to moustache-cms and then go to 'http://moustache-cms/admin' to login. If you can also start the Rails server and access the cms via the localhost, then go to 'http://127.0.0.1:3000/admin to login.
```
bundle exec rails start
````
- Have fun using MoustacheCms!

Checkout the [wiki](http://github.com/amkirwan/moustache-cms/wiki) for more information and go to the [Demo](https://demo.moustachecms.org/admin) page to see Moustache CMS in action. 


## Contribute

Contributions to the project are always welcomed and encouraged. If you have found a bug or want a new feature please submit a patch to the project.

## Support 

Checkout the [wiki](http://github.com/amkirwan/moustache-cms/wiki)

## License 

Moustache CMS is released under the MIT license, Copyright &copy; 2012

- Code git clone git://github.com/amkirwan/moustache-cms.git
- Home http://github.com/amkirwan/moustache-cms
- Bugs http://github.com/amkirwan/moustache-cms/issues
