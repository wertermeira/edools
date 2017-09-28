# Edools

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/edools`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'edools'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install edools

## Usage
### config
```
config = {
  :access_token => 'token'
}
client = Edools::Client.new(config)
```

### school
http://docs.edools.com/api/V1/SchoolsController.html <br />
use token for create school wizard
```
params = {"school": {"name": "test name", "email": "test@gtest.com", "password": "1234567" }}
client.create_school(params)
```


#### courses resource
http://docs.edools.com/api/V1/CoursesController.html <br />
use generated token for school
```
#list
client.courses

#create
params = {school_cource: {name: "course test}}
client.create_course(params)

#update
id = 10
params = {"school_cource": {"name": "course test"}}
client.update_course(id, params)

#show
id = 10
client.show_course(id)

#destroy
client.destroy_course(id)
```
#### school_products resource
http://docs.edools.com/api/V1/SchoolProductsController.html not complet <br />
use generated token for school
```
#list
client.products

#create
params = {school_product: {"name": "product test, "school_id": 10}}
client.create_product(params)
```

#### studantes resource

http://docs.edools.com/api/V1/InvitationsController.html<br />
http://docs.edools.com/api/V1/UsersController.html<br />
use generated token for school
```
#list
client.studantes

#create with invidation
params = {invitation: {"first_name": "First", "last_name": "Last", "email": "first@gmail.com", "password": "12345678", "password_confirmation": "12345678"  }}
client.create_and_invitation_studant(params)

#create without invidation
params = {studant: {"first_name": "First", "last_name": "Last", "email": "first@gmail.com", "password": "12345678", "password_confirmation": "12345678"  }}
client.create_studant(params)

#update
id = 10
params = {studant: {"first_name": "First", "last_name": "Last" }}

client.update_studant(id, params)

#show
id = 10
client.show_studant(id)

#destroy
client.destroy_studant(id)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wertermeira/edools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Edools project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/edools/blob/master/CODE_OF_CONDUCT.md).
