# Hourglass

Hourglass is a tool for aggregating individual team members' tracked time from
[Harvest](https://www.getharvest.com). The collected data is presented back to
the organization in such a way as to promote better time management.

[![Build Status](https://travis-ci.org/collectiveidea/hourglass.svg?branch=master)](https://travis-ci.org/collectiveidea/hourglass)
[![Code Climate](https://codeclimate.com/github/collectiveidea/hourglass/badges/gpa.svg)](https://codeclimate.com/github/collectiveidea/hourglass)
[![Test Coverage](https://codeclimate.com/github/collectiveidea/hourglass/badges/coverage.svg)](https://codeclimate.com/github/collectiveidea/hourglass)
[![Dependency Status](https://gemnasium.com/collectiveidea/hourglass.svg)](https://gemnasium.com/collectiveidea/hourglass)

## Local Setup

```
$ git clone git@github.com:collectiveidea/hourglass.git
$ cd hourglass
$ rvm 2.4.1@hourglass --create --ruby-version
$ bin/setup
$ rspec
```

## Running the Application Locally

Update `config/application.yml` with valid credentials. The application can be
run locally using Foreman:

```
$ foreman start
```

With Foreman, the application runs at [localhost:5000](http://localhost:5000).
