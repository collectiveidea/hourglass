# Hourglass

## Local setup

### Ruby

Hourglass uses Ruby 2.1.0

```
$ rvm install 2.1.0
```

### Install the Application

```
$ git clone git@github.com:collectiveidea/hourglass.git
$ cd hourglass
$ cp config/application.example.yml config/application.yml
$ cp config/database.example.yml config/database.yml
$ bundle install
$ rake db:setup
```

Update `config/application.yml` with your Harvest credentials

Run the test suite to verify proper setup:

```
$ rake
```

### Running the Application Locally

```
$ rails s
```


