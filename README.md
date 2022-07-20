# SeekRightJobs API

This is the API App for posting and searching right jobs as well as creating personal portfolio.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing
purposes.

### Prerequisites

Make sure you have installed `ruby-3.0.3` and have `bundler`

### Running the API App

1. Install dependency by running `bundle install`

2. Create database.yml file using the following command
    ```
    cp config/database.sample.yml config/database.yml
    ```
3. Create, migrate, and seed database
   ```
   rake db:create
   rake db:migrate
   rake db:seed
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

You will get `ok 200` status along with signed in `user_email` and `auth_token` as the response. You will need
this `auth_token` to verify your identity.

#### 3. Visit dashboard

- To verify your identity, you must need to provide `auth_token` what you got while signing in as an `Authorization`
  header.

```bash
curl --location --request GET 'http://localhost:3000/api/v1/dashboard' \
--header 'Content-Type: application/json' \
--header 'Authorization: auth_token'
```

If you pass authentication, You will get `ok 200` status along with a welcome message response from the `dashboard`
endpoint.

#### 4. Sign out

````bash
curl --location --request DELETE 'http://localhost:3000/sign_out' \
--header 'Content-Type: application/json' \
--header 'Authorization: auth_token'
````

By passing your valid `auth_token` to the sign_out endpoint, you will get `sign_out: true` as a successful sign_out
response.

## User Profile

The `profile` endpoint has the following functionalities.

* [Show](#show)
* [Update](#update)

### Show

Shows the user's profile, features, skills, projects, blogs, work and education history.

* **URL:** `/api/v1p1/profiles/profile`

* **Method:** `GET`

* **Authentication required:** `No`

* **Required Fields:** `user_id = [user_id]`

* **Payload:**
  ```json
     {
        "user_id": 1
     }  
  ```

* **Success Response:**

  * **Code:** `200 OK`

  * **Content:**
    ```json
    {
      "user_id": 1,
      "profile": {
        "id": 1,
        "first_name": "Test",
        "last_name": "Name",
        "headline": "Headline okay",
        "title": "title okay",
        "bio": "bio okay updated\n",
        "avatar": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--956002e22b48d680e4b35f4c8581d4038a7eaa24/default-avatar.png",
        "expertises": [
          "Programmer",
          "Developer"
        ],
        "social_links": {
          "id": 1,
          "facebook": "fbokay.com",
          "github": "",
          "linkedin": "linkedin3.com"
        },
        "skills": [
          {
            "id": 1,
            "title": "Ruby",
            "icon": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--569e18b9d1443f95816c4905b147a22e4f085bb3/ruby.png",
            "rating": 100
          },
          {
            "id": 49,
            "title": "Javascript",
            "icon": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--3352ff4705a695aca963fe35ec1a19c2bdc6d6eb/javascript.png",
            "rating": 80
          },
          {
            "id": 50,
            "title": "Python",
            "icon": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--145fc908b53231f7543bf540f485e12a71053e53/python.png",
            "rating": 90
          }
        ]
      },
      "portfolio_data": {
        "projects": [
          {
            "id": 50,
            "title": "ikk ",
            "description": "f dfg",
            "image": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBQZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--813a7ace0088468c8d66ba16346cbee588335f1a/portfolio-01.jpg",
            "live_url": "live.com",
            "source_url": "source.com",
            "categories": [
              {
              "id": 185,
              "category_id": 3,
              "title": "photoshop"
              },
              {
              "id": 186,
              "category_id": 1,
              "title": "application"
              }
            ],
            "react_count": 99
          }
        ]
      },
      "features": [
        {
          "id": 4,
          "title": "mobile app",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        },
        {
          "id": 5,
          "title": "CEO marketing",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        },
        {
          "id": 6,
          "title": "UI & UX design",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        },
        {
          "id": 2,
          "title": "dfg dfgdfgapp development",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        }
      ],
      "blogs": [
        {
          "id": 2,
          "title": "Mobile app landing design & app maintain",
          "body": "Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.",
          "image": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--1e2f12515acfd05a66757975406bb7cb6a14ed03/blog-02.jpg",
          "reading_time": 132,
          "categories": [
            {
              "id": 5,
              "category_id": 3,
              "title": "photoshop"
            }
          ]
        },
        {
          "id": 3,
          "title": "T-shirt design is the part of design",
          "body": "Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.",
          "image": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--802b32ffe83d652e5fe0277abe655e77c1eb6b68/blog-03.jpg",
          "reading_time": 334,
          "categories": [
            {
            "id": 6,
            "category_id": 5,
            "title": "web design"
            }
         ]
        }
      ],
      "resume_data": {
        "educations": [
          {
            "id": 1,
            "institution": "University of A",
            "degree": "diploma",
            "grade": "B",
            "currently_enrolled": false,
            "visibility": true,
            "start_date": "2012-01-01T00:00:00.000Z",
            "end_date": "2013-12-01T00:00:00.000Z",
            "description": "xcv sdf education description education description education description education description"
          }
        ],
        "skills": [
          {
            "id": 1,
            "name": "Ruby",
            "rating": 100
          },
          {
            "id": 49,
            "name": "Javascript",
            "rating": 80
          },
          {
            "id": 50,
            "name": "Python",
            "rating": 90
          }
        ],
        "experiences": [
          {
            "id": 1,
            "title": "The Personal Portfolio ghgh",
            "employment_type": 0,
            "company_name": "Company A",
            "description": "Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.",
            "start_date": "2012-02-01T00:00:00.000Z",
            "end_date": "2022-01-01T00:00:00.000Z",
            "currently_employed": true,
            "visibility": true
          }
        ]
      },
      "contacts_data": {
        "first_name": "Test",
        "last_name": "Name",
        "contact_email": "test@email.com",
        "designation": "Chief operating officer",
        "description": "I am available for freelance work. Connect with me via and call in to my account."
      },
      "all_categories": [
        {
          "id": 1,
          "title": "application"
        },
        {
          "id": 2,
          "title": "development"
        },
        {
          "id": 3,
          "title": "photoshop"
        },
        {
          "id": 4,
          "title": "figma"
        },
        {
          "id": 5,
          "title": "web design"
        }
      ]
    }
    ```

* **Error Response:**

  * **Code:** `404 Not Found`
  * **Content:**
    ```json
      {   
          "error": "User is not found"
      }
    ```

* **Notes:**

         The response will return an nested json objects of profile, skills, features, projects, blogs, categories, work history, education history, and contact. 

### Update

Updates the user's profile, features, skills, projects, blogs, work and education history.

* **URL:** `/api/v1p1/profiles/profile`

* **Method:** `PATCH`

* **Authentication required:** `Yes`

* **Required Fields:**
  * `token=[string]` This token will identify the current user to update.

* **Payload:**

  ```json 
  {
    "user": {
      "profile": {
        "id": 1,
        social_link_attributes: {
          "id": 1,
          "facebook": "www.facebook.com",
          "github": "www.github.com",
          "linkedin": "www.linkedin.com",
        },
        "expertises": "{Ruby on Rails,Ruby,Javascript}" 
      },
      "users_skills_attributes": [
        {
          "id": 1,
          "_destroy": true 
        },
        {
          "skill_id": 3,
          "rating": 99
        } 
      ],
      
      "features_attributes" : [
        {
            "title": "Network Engineer",
            "description": "As a network engineer, I design network and lead network maintenance"
        },
        {
          "id": 1,
          "_destroy": true
        } 
      ],
      "projects_attributes": [
        {
          "id": 1,
          "_destroy": true
        },
        {
          "title": "Project Title",
          "description": "Project Description",
          "react_count": 100,  
          "live_url": "liveurl.com",
          "soruce_url": "sourceurl.com",
          "categorizations_attributes": [
            {
              "category_id": 1
            }
          ],
          "image": [imagefile]
        },        
      ],
      "education_histories_attributes": [
        {
          "institution": "New Institution",
          "degree": "New Degree",
          "grade": "A+",
          "description": "New Education Histroy New Education Histroy New Education Histroy",
          "start_date": "2018-05-26",
          "end_date": "2022-10-26",
          "currently_enrolled": true,
          "visibility": true
        },
      ],
      "work_histories_attributes": [
        {                                   
            "title": "Work 2",
            "employment_type": 1,
            "company_name": "ABC Company",
            "description": "I have joined this company as a software engineer",
            "start_date": "2018-05-26",
            "end_date": "2022-05-26",
            "currently_employed": false,
            "visibility": true
        }
      ]
      "blogs_attributes": [        
        {
          "title": "Blog Title",
          "description": "Project Description",
          "react_count": 100,  
          "live_url": "liveurl.com",
          "soruce_url": "sourceurl.com",
          "categorizations_attributes": [
            {
              "category_id": 1
            }
          ],
          "image": [imagefile]
        },        
      ],
    }
  }  
  ```

* **Success Response:**

  * **Code:** `200 OK`

  * **Content:**

    ```json
    {
      "user_id": 1,
      "profile": {
        "id": 1,
        "first_name": "Test",
        "last_name": "Name",
        "headline": "Headline okay",
        "title": "title okay",
        "bio": "bio okay updated\n",
        "avatar": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--956002e22b48d680e4b35f4c8581d4038a7eaa24/default-avatar.png",
        "expertises": [
          "Programmer",
          "Developer"
        ],
        "social_links": {
          "id": 1,
          "facebook": "fbokay.com",
          "github": "",
          "linkedin": "linkedin3.com"
        },
        "skills": [
          {
            "id": 1,
            "title": "Ruby",
            "icon": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--569e18b9d1443f95816c4905b147a22e4f085bb3/ruby.png",
            "rating": 100
          },
          {
            "id": 49,
            "title": "Javascript",
            "icon": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--3352ff4705a695aca963fe35ec1a19c2bdc6d6eb/javascript.png",
            "rating": 80
          },
          {
            "id": 50,
            "title": "Python",
            "icon": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--145fc908b53231f7543bf540f485e12a71053e53/python.png",
            "rating": 90
          }
        ]
      },
      "portfolio_data": {
        "projects": [
          {
            "id": 50,
            "title": "ikk ",
            "description": "f dfg",
            "image": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBQZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--813a7ace0088468c8d66ba16346cbee588335f1a/portfolio-01.jpg",
            "live_url": "live.com",
            "source_url": "source.com",
            "categories": [
              {
                "id": 185,
                "category_id": 3,
                "title": "photoshop"
              },
              {
                "id": 186,
                "category_id": 1,
                "title": "application"
              }
            ],
            "react_count": 99
          }
        ]
      },
      "features": [
        {
          "id": 4,
          "title": "mobile app",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        },
        {
          "id": 5,
          "title": "CEO marketing",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        },
        {
          "id": 6,
          "title": "UI & UX design",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        },
        {
          "id": 2,
          "title": "dfg dfgdfgapp development",
          "description": "I throw myself down among the tall grass by the stream as I lie close to the earth."
        }
      ],
      "blogs": [
        {
          "id": 2,
          "title": "Mobile app landing design & app maintain",
          "body": "Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.",
          "image": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--1e2f12515acfd05a66757975406bb7cb6a14ed03/blog-02.jpg",
          "reading_time": 132,
          "categories": [
              {
                "id": 5,
                "category_id": 3,
                "title": "photoshop"
              }
            ]
        },
        {
          "id": 3,
          "title": "T-shirt design is the part of design",
          "body": "Nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum.",
          "image": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--802b32ffe83d652e5fe0277abe655e77c1eb6b68/blog-03.jpg",
          "reading_time": 334,
          "categories": [
              {
                "id": 6,
                "category_id": 5,
                "title": "web design"
              }
           ]
        }
      ],
      "resume_data": {
        "educations": [
          {
            "id": 1,
            "institution": "University of A",
            "degree": "diploma",
            "grade": "B",
            "currently_enrolled": false,
            "visibility": true,
            "start_date": "2012-01-01T00:00:00.000Z",
            "end_date": "2013-12-01T00:00:00.000Z",
            "description": "xcv sdf education description education description education description education description"
          }
        ],
        "skills": [
          {
            "id": 1,
            "name": "Ruby",
            "rating": 100
          },
          {
            "id": 49,
            "name": "Javascript",
            "rating": 80
          },
          {
            "id": 50,
            "name": "Python",
            "rating": 90
          }
        ],
        "experiences": [
          {
            "id": 1,
            "title": "The Personal Portfolio ghgh",
            "employment_type": 0,
            "company_name": "Company A",
            "description": "Contrary to popular belief. Ut tincidunt est ac dolor aliquam sodales. Phasellus sed mauris hendrerit, laoreet sem in, lobortis mauris hendrerit ante.",
            "start_date": "2012-02-01T00:00:00.000Z",
            "end_date": "2022-01-01T00:00:00.000Z",
            "currently_employed": true,
            "visibility": true
          }
        ]
      },
      "contacts_data": {
        "first_name": "Test",
        "last_name": "Name",
        "contact_email": "test@email.com",
        "designation": "Chief operating officer",
        "description": "I am available for freelance work. Connect with me via and call in to my account."
      },
      "all_categories": [
        {
          "id": 1,
          "title": "application"
        },
        {
          "id": 2,
          "title": "development"
        },
        {
          "id": 3,
          "title": "photoshop"
        },
        {
          "id": 4,
          "title": "figma"
        },
        {
          "id": 5,
          "title": "web design"
        }
      ]
    }
    ```

* **Error Response:**

  * **Code:** `401 Unauthorized`
  * **Content:**
      ```json
      {
        "error": "Unauthorized"
      }
      ```


* **Notes:**

         The response will return an nested json objects of profile, skills, features, projects, blogs, categories, work history, education history, and contact.

