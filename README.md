# Lounger

**Lounger** is a very simple Ruby gem that, as its name suggests, allows you to make the current thread doing nothing until the process termination.
It is useful when you have an application that runs different threads, bug you have to stop the main thread to prevent the process termination.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lounger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lounger

## Usage

It's very simple to use it. All you have to do is to call `Lounger.idle`, and the current thread will wait there until the process termination.

```ruby
# example.rb
require 'lounger'

Thread.new do
  while true do
    puts "I'm doing something useful"
    sleep 1
  end
end

Lounger.idle # your main thread will wait here
```

**WARNING**: using **Lounger** when there's a single running thread will result in a *deadlock* error!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serioja90/lounger. This project is intended to be a safe, welcoming
space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

