= mygist

* http://www.akitaonrails.com

== DESCRIPTION:

Encapsulates the basic Gist operations in a simple Library that uses WWW::Mechanize 
while there is still no available public API

== FEATURES/PROBLEMS:

* Login
* Logout
* Create a new Gist
* Edit an existing Gist
* Delete a Gist
* List all Gists or just the logged in user gists

== SYNOPSIS:

  begin
    gist = Mygist::GistApi.new('username', 'password')
    gist.login!
    id = gist.create("Hello World", ".txt")
    gist.update!(id, "Hello World Again!")
    gist.delete!(id)
    gist.logout!
  rescue Mygist::GistApi::NotLoggedIn
    # if the login fails 
  end

== REQUIREMENTS:

* gem install mechanize

== INSTALL:

* gem install akitaonrails-mygist --source=http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Fabio Akita

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.