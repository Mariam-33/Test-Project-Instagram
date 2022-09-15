# Instagram Clone

The web application is developed using ruby on rails. The application includes the features of sign in and sign up for users. Other than that user can upload post and stories. User can follow friends as well. The user can view other user stories and posts and can like and comment on them. The user can set account as private to only allow the authorized users to access their posts and stories.
Things you may want to cover:

- Ruby version
  Ruby version: ruby 2.7.2p137
  Rails version: Rails 5.2.8.1

- System dependencies
  Postgresql: for db
  Devise: for user authentication
  pundit:f or authorization
  Cloundinary

- Database creation
  Postgress has been used in this Project, new database can be created using following commands.

  rails db:drop
  rails db:create
  rails db:migrate

- Database initialization
  Database with initial data can be load by running.

rails db:seed

- Services (job queues, cache servers, search engines, etc.)
  Background job: In order to delete the story after 24 hours, a background job was created using sidekiq

- Deployment instructions
  heroku login
  heroku create #To create new application.
  heroku rename #To rename application.
  git push heroku master or git push heroku develop:master (To push branch other than master)
  heroku run rails db:migrate, rails db:seed
- ...
