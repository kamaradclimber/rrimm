=========
About rrimm
=========

[![Build Status](https://travis-ci.org/kamaradclimber/rrimm.png?branch=master)](https://travis-ci.org/kamaradclimber/rrimm)
[![Gem Version](https://badge.fury.io/rb/rrimm.png)](http://badge.fury.io/rb/rrimm)
[![Dependency Status](https://gemnasium.com/kamaradclimber/rrimm.png)](https://gemnasium.com/kamaradclimber/rrimm)
[![Coverage Status](https://coveralls.io/repos/kamaradclimber/rrimm/badge.png?branch=master)](https://coveralls.io/r/kamaradclimber/rrimm?branch=master)

In a nutshell
-------------

**Technically**, *rrimm* is a little tool that retrieves a list of RSS/Atom feeds and send them by email.

**Functionally**, *rrimm* makes it possible to use mail readers for feeds, for the sake of *I-want-the-mutt-of-feed-readers* zealots.

**Originally**, *rrimm* is the ruby reboot of the excellent k0ral's *imm* (https://github.com/k0ral/imm).
The original concept, this README and a lot of ideas are extracted from *imm*. 

*rrimm* is written and configured in *Ruby*.

Informations about versions, dependencies, source repositories and contacts can be found on rubygems.org_.


Need & purpose
--------------

Following numerous RSS/Atom feeds needs organization and aggregation.
Such needs are usually met by feed readers.
Although there are a lot of those, some people still feel unsatisfied with the existing implementations.

The expected features of a feed reader could be defined as follows:

- it retrieves items with the following attributes: an author, a date/time, a (possibly enriched) body;
- items can be sorted, categorized, marked as read/unread, tagged, shared/forwarded;
- items must be available from anywhere on the internet.

Luckily, there's already a widespread solution that provides such features: mail readers.
Considering that, *rrimm* aims at projecting the RSS/Atom paradigm onto the mail one; this way, all the existing tools that work on mails can be leveraged to work on RSS/Atom feeds as well, no wheel reinventing.

Such need is already covered by *imm*, a tool written and maintained by k0ral.
imm's code has grown and is now using powerful concepts for beauty sake. Its source code has lost its readability.
*rrimm* intends to keep it (really) simple both in features and source code.

    Every program attempts to expand until it can read mail
                                             Zawinski's Law

rrimm tries to avoid going that dangerous road and simply outputs email to stdout (or pass it to any program via a shell pipe).


Function
--------

*rrimm* does only one thing and does it well: it downloads an RSS/Atom feeds list, and for each new item it writes an email on the standard output. How to write mail is setup in *rrimm*'s configuration file.

No *SMTP* sending, no *IMAP* serving, no aggregating: those should be performed by external tools.


Example usage
-------------

It is possible to setup a Google Reader-like on a server using the following steps:

- schedule *rrimm* to check feeds regularly and write new items into mail format;
- pipe these emails into any smtp tool (msmtp, sendmail)
- setup a webmail, bound to the IMAP server above, to read feeds from any computer connected to the internet.


Getting started
---------------

To get started, please fill the configuration file at ``~/.config/rrimm/rrimm.rb`` with your feeds list and settings. An example configuration file is provided with the package. Configuring *rrimm* requires virtually no knowledge of *Ruby* language.


.. _rubygems: https://rubygems.org/rrimm
