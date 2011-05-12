GhostRed
========

GhostRed is designed to parse and migrate GitHub Pull Requests·
to a Redmine ticket tracker using the respective APIs.

GhostRed connects to GitHub using your GitHub username and API token.·
It then scans the repositories owned by the GitHub username (or you can·
specify another user or organisation using the --gh_org option). Each·
pull request is then captured, a corresponding ticket opened in a·
Redmine project (specified by either matching the name of a repository·
to the GitHub repository name or checking the PROJECT_MAP in the·
lib/ghostred.rb file).  You can update this map yourself to specify·
the relationship between a GitHub repository and it's Redmine project.

Authentication to Redmine is specified using the --rm_token flag and
the Redmine tracker to connect to using the --rm_site flag.

The GitHub pull request is finally closed with a comment linking to the·
newly created Redmine ticket.

Author
------

James Turnbull <james@lovedthanlost.net>

Prerequistes
------------

* Octokit - octokit

    $ sudo gem install octokit

Installation
------------

GhostRed is available as a RubyGem.

    $ sudo gem install ghostred

Usage
-----

Usage: ghostred [options] ...

Configuration options:
    -r, --rm_token TOKEN             The API token to use with Redmine
    -s, --rm_site SITE               The Redmine site to connect to
    -g, --gh_org GITHUB_ORG          The GitHub organisation
    -u, --gh_user GITHUB_USER        The GitHub user
    -t, --gh_token TOKEN             The GitHub token

Common options:
    -v, --version                    Display version
    -h, --help                       Display this screen

You can run GhostRed by specfying a number of command line options.

    $ ghostred --rm_token=redmineapitoken --rm_site=http://redmine.urol
      --gh_org=githuborg --gh_token=githubapitoken -gh_user=githubuser

License
-------

See LICENSE file.

