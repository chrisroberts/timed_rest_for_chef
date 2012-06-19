TimedRestForChef
================

This is a patching library to wrap REST calls in a
timeout to prevent hung chef processes.

Usage
=====

This library can be used in one of two ways:

1. A cookbook recipe can load it via chef_gem
2. The library can be required via the client.rb file

The first method would have something like this in a recipe:

```ruby
chef_gem 'timed_rest_for_chef'
require 'timed_rest_for_chef'
```

The downside of this method is that REST calls will not be wrapped
until chef gets to that recipe. This means all previous calls could
hang the chef process.

Using the second method, the gem will need to be available to chef, 
and a new line added to the client.rb file:

```ruby
# /etc/chef/client.rb
require 'timed_rest_for_chef'
...
```

Ensuring the gem is available to chef and that client.rb file has the
proper require line can be automated via the chef-client cookbook with
slight modifications.

With the modifications referenced below to the chef-client cookbook, this
can be added to install this gem and configure the client.rb file:

```ruby
override_attributes(
  :chef_client => {
    :load_gems => {
      :timed_rest_for_chef => {
        :version => '0.0.4'
      }
    }
  }
)
```

References:
===========

* Ticket: http://tickets.opscode.com/browse/CHEF-2944
* chef-client cookbook: https://github.com/opscode-cookbooks/chef-client/pull/12 
