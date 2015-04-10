# casino-salesforce_authenticator [![Build Status](https://travis-ci.org/rbCAS/casino-salesforce_authenticator.png?branch=master)](https://travis-ci.org/rbCAS/casino-salesforce_authenticator) [![Coverage Status](https://coveralls.io/repos/rbCAS/casino-salesforce_authenticator/badge.png)](https://coveralls.io/r/rbCAS/casino-salesforce_authenticator)

Provides mechanism to use Salesforce as an authenticator for [CASino](https://github.com/rbCAS/CASino).

To use the Salesforce authenticator, configure it in your cas.yml:

    authenticators:
      my_company_sql:
        authenticator: "Salesforce"
      options:
        connection:
          client_id: "xxx"
          client_secret: "123"
          username: "you@example.com"
          password: "zzz"
        sobject: "Contact"
        username_column: "Email"
        password_column: "Password"
        extra_attributes:
          first_name: "FirstName"
          last_name: "LastName"

Configuration examples for the `connection` part for other databases can be found [here](https://gist.github.com/erichurst/961978).

## Contributing to casino-salesforce_authenticator

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Nils Caspar, 2015 Steve Friedman. See LICENSE.txt
for further details.

