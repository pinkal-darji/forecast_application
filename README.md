# README

This README would normally document whatever steps are necessary to get the
application up and running.

# ForecastApplication

### Version
* ruby 2.7.0
* rails 5.2.8


### Installation

You have to follow below steps for install the application into development :

```sh
$ git clone [git-repo-url] forecast_application
```
Go to project directory
```sh
$ cd forecast_application
```
Then install bundle
```sh
$ bundle install
```
Create database
```sh
$ rails db:create
```
Then run the migration files
```sh
$ rails db:migrate

```
Then run the seed file
```sh
$ rails db:seed

```
Finally start the server
```sh
$ rails s
