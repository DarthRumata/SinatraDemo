# TODO:

Please create API that allows us to create new task, show task by id, show all tasks, delete task by id.

Please see the routes section

# Routes

```
GET    /tasks     -> index
GET    /tasks/:id -> show
POST   /tasks     -> Create
DELETE /tasks/:id -> Delete
```

# Gems
```
gem 'dotenv' #.env
gem 'mongoid' # MogoDB Active Record
gem 'sinatra-initializers' # Initializer
gem 'active_model_serializers' # Active Record serializers
```

# Mongo DB

How to install
```
https://docs.mongodb.com/v3.0/tutorial/install-mongodb-on-os-x/
https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
GOOGLE: {MAC(brew)|Ubuntu} install mongodb
```
Test connection
```
mongo {server}:{port}/{database} -u {dbuser} -p {dbpassword}
mongo 127.0.0.1:27019
https://docs.mongodb.com/v3.2/reference/program/mongo/
```
