CLIUtils
====

CLIUtils is a library of functionality designed to alleviate common tasks and headaches when developing command-line (CLI) apps in Ruby.

# Why?

It's fairly simple:

1. I love developing Ruby-based CLI apps.
2. I found myself copy/pasting common code from one to another.
3. I decided to do something about it.

# Installation

Add this line to your application's Gemfile:

```bash
$ gem 'cliutils'
```

And then execute:

```bash
$ bundle
```

Or install it yourself:

```bash
$ gem install cliutils
```

# Usage

```ruby
require 'cliutils'
```

If you want to mix in everything that CLIUtils has to offer:

```Ruby
include CLIUtils
```

Alternatively, as described below, mix in only the libraries that you want.

## PrettyIO

First stop on our journey is better client IO. To activate, simply mix into your project:

```ruby
include CLIUtils::PrettyIO
```

PrettyIO affords you colorized strings:

```ruby
puts 'A sample string'.red
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-red-text.png "Colored Text via PrettyIO")

PrettyIO gives you utility methods for the common ANSI color codes:

```ruby
String.blue
String.cyan
String.green
String.purple
String.red
String.white
String.yellow
```

You also get the `colorize` method, which allows you to define more complex color combinations. For example, to get some nice purple text on a gnarly green background:

```ruby
puts 'A sample string'.colorize('35;42')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-gnarly-text.png "Complex Colored Text via PrettyIO")

Naturally, memorizing the ANSI color scheme is a pain, so PrettyIO gives you a convenient method to look up these color combinations:

```ruby
color_chart
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prettyio-color-chart.png "PrettyIO Color Chart")

## Messenging

Throughout the life of your application, you will most likely want to send several messages to your user (warnings, errors, info, etc.). Messenging makes this a snap. It, too, is a mixin:

```ruby
include CLIUtil::Messenging
```

Once mixed in, you get access to `messenger`, a type of Logger that uses PrettyIO to send nicely-formatted messages to your user. For example, if you'd like to warn your user:

```ruby
messenger.warn('Hey pal, you need to be careful.')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/messenger-warn.png "A Warning from Messenger")

### Messenging Methods

`messenger` gives you access to several basic methods:

* `messenger.error`: used to show a formatted-red error message.
* `messenger.info`: used to show a formatted-blue infomational message.
* `messenger.section`: used to show a formatted-purple sectional message.
* `messenger.success`: used to show a formatted-green success message.
* `messenger.yellow`: used to show a formatted-yellow warning message.

Let's see an example that uses them all:

```Ruby
messenger.section('STARTING ATTACK RUN...')
messenger.info('Beginning strafing run...')
messenger.warn('WARNING: Tie Fighters approaching!')
messenger.error('Porkins died :(')
messenger.success('But Luke still blew up the Death Star!')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/messenger-types-1.png "Basic Messenger Types")

`messenger` also includes two "block" methods that allow you to wrap program execution in messages that are "longer-term".

```Ruby
messenger.info_block('Starting up...', 'Done!', multiline = false) { # do stuff here }
```

`messenger` outputs 'Starting up...', runs the code in `# do stuff here`, and once complete, outputs 'Done!' on the same line. Note that `section_block` is the same exact signature (except for the method name, of course!).

### Message Wrapping

PrettyIO also gives `messenger` the ability to wrap your messages so that they don't span off into infinity. You can even control what the wrap limit (in characters) is:

```Ruby
CLIUtils::PrettyIO::wrap_amount(50)
messenger.info('This is a really long message, okay? It should wrap at some point. Seriously. Wrapping is nice.')
puts ''
CLIUtils::PrettyIO::wrap_amount(20)
messenger.info('This is a really long message, okay? It should wrap at some point. Seriously. Wrapping is nice.')
puts ''
CLIUtils::PrettyIO::wrap(false)
messenger.info('This is a really long message, okay? It should wrap at some point. Seriously. Wrapping is nice.')
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/wrapping.png "Text Wrapping")

### Prompting

`messenger` also carries a convenient method to prompt your users to give input (including an optional default). It makes use of `readline`, so you can do cool things like text expansion of paths.

```Ruby
p = messenger.prompt('Are you a fan of Battlestar Galactica?', default = 'Y')
messenger.info("You answered: #{ p }")
```
![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/prompting.png "Prompting")

### Logging

Often, it's desirable to log messages as they appear to your user. `messenging` makes this a breeze by allowing you to attach and detach Logger instances at will.

For instance, let's say you wanted to log a few messages to both your user's STDOUT and to `file.txt`:

```Ruby
file_logger = Logger.new('file.txt')

messenger.info('This should only appear in STDOUT.')

messenger.attach(file_logger)

messenger.warn('This warning should appear in STDOUT and file.txt')
messenger.error('This error should appear in STDOUT and file.txt')
messenger.debug('This debug message should only appear in file.txt')

messenger.detach(file_logger)

messenger.section('This section message should appear only in STDOUT')
```

In STDOUT:

![alt text](https://raw.githubusercontent.com/bachya/cli-utils/master/res/readme-images/multi-logger.png "Multi-logging")

...and in `file.txt`:

```
W, [2014-03-29T15:14:34.844406 #4497]  WARN -- : This warning should appear in STDOUT and file.txt
E, [2014-03-29T15:14:34.844553 #4497] ERROR -- : This error should appear in STDOUT and file.txt
D, [2014-03-29T15:14:34.844609 #4497] DEBUG -- : This debug message should only appear in file.txt
```

Since you can attach Logger objects, each can have it's own format and severity level. Cool!

# Known Issues

* LoggerDelegator doesn't currently know what to do with `messenger.prompt`, so you'll have to manually log a `debug` message if you want that information logged.

# Contributing

1. Fork it ( http://github.com/bachya/cliutils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
