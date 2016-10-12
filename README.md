# Rspec::Raml

RSpec matchers for working with [RAML](http://raml.org).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-raml'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-raml

## Setup

First, you'll need to include RSpec::Raml's helpers in your RSpec configuration.

```ruby
RSpec.configure do |config|
  config.include RSpec::Raml::Matchers, type: :request
end
```

## Usage

Assume you've got a RAML specification:

```yaml
#%RAML 0.8
---
title: Dummy API
baseUri: https://dummy-api.com/api/{version}
version: v1

/users:
  /{id}:
    displayName: Find a user
    get:
      responses:
        200:
          description: User was found.
          body:
            application/json:
              example: |-
                {
                  "id": 1,
                  "first_name": "John",
                  "last_name": "Doe"
                }

```

You can write a spec that compares an HTTP response with the RAML specifcation you've written.

```ruby
# spec/requests/api/v1/users_spec.rb

describe 'Users API' do
  describe 'GET /api/v1/users/:id' do
    raml { Rails.root.join('docs/api/v1.raml') }

    let(:user) {
      User.create!(
        id: 1,
        first_name: 'John',
        last_name: 'Doe'
      )
    }

    it 'is documented' do
      get "/api/v1/users/#{user.id}"
      expect(response).to match_raml(:get, '/users/{id}', 200)
    end
  end
end
```

The `match_raml` matcher will verify that the status code returns successfully, and that the response body matches what you've declared in your RAML specification.

If you haven't written your specification yet, RSpec::Raml will output an example RAML specification.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/rspec-raml.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
