#Steps to TorCrawl

My first attempt ended in heartbreak. I began by looking for tutorials on how to
use Ruby to connect to Tor hidden services. There's quite a bit of information on
how to connect to the Tor network, and even a couple gems to help you control an
active Tor client, but nothing that shows how to successfully create a connection
to a Tor hidden service site. I ended up finding a stack overflow post on using
cURL to connect to hidden services with PHP (more on that later), and tried to
adapt the apparently successful solution there to Ruby.

For those unfamiliar with cURL:

>cURL is a computer software project providing a library and command-line tool
>for transferring data using various protocols. The cURL project produces two
>products, libcurl and cURL. It was first released in 1997.
>...
>The libcurl library is free, thread-safe, IPv6 compatible, and fast. Bindings
>are available for more than 40 languages, including C/C++, Java, PHP and Python.
>[Wikipedia - cURL](http://en.wikipedia.org/wiki/CURL)

libcurl is a truly fantastic library that makes programmatic access to websites a
breeze in many languages. I was familiar with using it to make API requests in PHP,
so I figured it would a be a breeze to set up in Ruby. I was wrong. See above,
where it says: *"Bindings are available for more than 40 languages, including C/C++,
Java, PHP and Python."* ?

There's a reason Ruby isn't on that list. There are a few competing gems that
implement parts of libcurl's functionality, but none of them cover the complete
suite of tools available to programmers using more established languages. My attempts
to use *curb* and *Typhoeus*, the two most popular bindings for ruby were nothing
but frustrating. Neither offered the level of customization necessary to configure
a client to connect to a hidden service. NetHTTP, Ruby standard library's built
in suite of HTTP connection tools, also seemed like an option but I couldn't get it
to work either.

Eventually, after endless hours of Googling and futzing with HTTP headers, I landed
on a third approach: Tor2Web.

Tor2Web is a server written by Aaron Swartz to allow people who can't access the
Tor network directly to see hidden services and other Tor enabled sites via a
proxy page. The user goes to a link like "hiddenservicekey.tor2web.org", and the
Tor2Web server connects to the hidden service and delivers its content back to the
user over their non-tor HTTP connection. The software is open source, and there's
a pretty good manual for installation, so I thought I would try to get a Tor2Web
server running and see if I could automate it to make queries for me to the Tor
network.

I was immediately stymied by the fact that Tor2Web is really only made to run on
Ubuntu Linux. I had heard that Vagrant was an easy way to set up a linux virtual
machine, so I gave that a try. It was easy enough to get the "box" running, but
from there I had no idea what to do. After swimming through endless documentation
on "provisioning" and other completely arcane topics and trying everything I could
think of to get Tor2Web onto my VM, I came to an impasse. I decided to take a break,
get some perspective, and come back later.

The next day, I cracked open my laptop to work on a Flatiron lab, and things
immediately started to go wrong. Everything seemed very slow and jerky, like my
computer didn't have the resources to perform even simple tasks like saving documents.
Several programs began behaving in bizarre ways, including a local server that refused
to die even after I restarted my computer and sent a kill messages to almost every
process on the system. Finally, as I was hitting command + s to save my lab, I got
an error message saying that my computer couldn't save the file. I tried again, and
got the same error message. I tried to close the program, and suddenly my computer
turned off. When I booted it back up again, it couldn't read its own drive. Something
in memory had become so corrupted that the computer could no longer find files. I had
to completely wipe my computer and start over.

Site has many pages (the pages on the site)
     has many links => through pages
Page has many links (the links on the page)
Link belongs to page (the page the link appeared on)
