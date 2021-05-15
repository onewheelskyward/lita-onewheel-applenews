# lita-onewheel-applenews

[![Build Status](https://travis-ci.org/onewheelskyward/lita-onewheel-applenews.png?branch=main)](https://travis-ci.org/onewheelskyward/lita-onewheel-applenews)
[![Coverage Status](https://coveralls.io/repos/onewheelskyward/lita-onewheel-applenews/badge.png)](https://coveralls.io/r/onewheelskyward/lita-onewheel-applenews)

Grabs the real url from apple news posts because I don't like or use apple news.  Hat tip to @samgrover for the idea & initial implementation.

## Installation

Add lita-onewheel-applenews to your Lita instance's Gemfile:

``` ruby
gem "lita-onewheel-applenews"
```

## Configuration

n/a

## Usage

anytime apple.news comes up, it grabs the content and finds the reference url in redirectToUrlAfterTimeout.
