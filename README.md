# FansWatch
[![Gem Version](https://badge.fury.io/rb/fanswatch.svg)](https://badge.fury.io/rb/fanswatch)
[![Build Status](https://travis-ci.org/wtlin1228/FansWatch.svg?branch=master)](https://travis-ci.org/wtlin1228/FansWatch)

FaceGroup is a gem that specializes in getting data from public Facebook Pages.

## Installation

If you are working on a project, add this to your Gemfile: `gem 'fanswatch'`

For ad hoc installation from command line:

```$ gem install fanswatch```

## Setup Facebook Credentials

Please setup your Facebook developer credentials by creating an app profile on Facebook Developer: https://developers.facebook.com – you should get a "client ID" and "client secret".

## Usage

Require FaceGroup gem in your code: `require 'fanswatch'`

Supply your Facebook credentials to our library in one of two ways:
- Setup environment variables: `ENV[FB_CLIENT_ID]` and `ENV[FB_CLIENT_SECRET]`
- or, provide them directly to FansWatch:

```
FansWatch::FbApi.config = { client_id: ENV['FB_CLIENT_ID'],
                            client_secret: ENV['FB_CLIENT_SECRET'] }
```

See the following example code for more usage details:

```ruby
# Access the page
page = FansWatch::Page.find(
  id: ENV['FB_PAGE_ID']
)

puts page.name

feed = page.feed

puts feed.count

page.feed.postings.each do |posting|
  puts posting.id
  puts posting.created_time
  puts posting.message
  if posting.attachment
    puts posting.attachment.description
    puts posting.attachment.url
  end
end
```
