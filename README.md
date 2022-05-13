# SeekRightJobs API

This is the API App for posting and searching right jobs as well as creating personal portfolio.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Make sure you have installed `ruby-3.0.3` and have `bundler`

### Running the API App
1. Install dependency by running `bundle install`

2. Create database.yml file using the following command
    ```
    cp config/database.sample.yml config/database.yml
    ```
3. Create and migrate database
   ```
   rake db:create
   rake db:migrate
   ```

4. Start the `seekrightjobs_back` server at default port 3000 by running `rails s`

### Create User & authenticate using `auth_token`
#### 1. Create a user
```bash
  curl --location --request POST 'http://localhost:3000/users' \
  --header 'Content-Type: application/json' \
  --data-raw '{ "user": {"email": "test@example.com", "password": "password", "password_confirmation": "password"}}'
```
You will get `created 201` status along with newly registered email as the response.

#### 2. Sign in
```bash
curl --location --request POST 'http://localhost:3000/sign_in' \
--header 'Content-Type: application/json' \
--data-raw '{ "email": "test@example.com", "password": "password" }'
```
You will get `ok 200` status along with signed in `user_email` and `auth_token` as the response. You will need this `auth_token` to verify your identity.

#### 3. Visit dashboard
 - To verify your identity, you must need to provide `auth_token` what you got while signing in as an `Authorization` header. 
```bash
curl --location --request GET 'http://localhost:3000/api/v1/dashboard' \
--header 'Content-Type: application/json' \
--header 'Authorization: auth_token'
```
If you pass authentication, You will get `ok 200` status along with a welcome message response from the `dashboard` endpoint.

#### 4. Sign out
````bash
curl --location --request DELETE 'http://localhost:3000/sign_out' \
--header 'Content-Type: application/json' \
--header 'Authorization: auth_token'
````
By passing your valid `auth_token` to the sign_out endpoint, you will get `sign_out: true` as a successful sign_out response.

