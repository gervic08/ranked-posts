# Ranked Posts API

A Ruby on Rails API application to manage posts and ratings, designed to handle large datasets efficiently.

## Features

- Create posts associated with users and IP addresses.

- Rate posts with one rating per user per post.

- Retrieve average post ratings.

- Get top N posts by average rating.

- Query IPs shared by multiple users, along with their logins.

- Handles concurrent requests safely with pessimistic locking.

## Tech Stack

- **Backend:** Ruby on Rails 8  
- **Database:** PostgreSQL (with `inet` for IP addresses and PostGIS support)  
- **Testing:** RSpec (request specs for API endpoints)  

## API Endpoints
  ### Posts
  
    - **Create Post**
      ```http
      POST /api/v1/posts
    
      
      Parameters: title, body, user_login, ip
    
    - **Top Posts**
      ```http
      GET /api/v1/posts?top=N
    
    
      Returns top N posts by average rating
  
  ### Ratings
  
    - **Create Rating**
      ```http
      POST /api/v1/posts/ratings
  
  
      Parameters: post_id, user_id, value
  
  
  ### IPs with Multiple Authors
    ```http
    GET /api/v1/posts/ips
  
  
    Returns array of objects: { ip, user_logins[] }

## Data Seeding

  The project supports large-scale seeding using the API and curl.
  
  ### Sample configuration:
  
    num_users: 100
    num_ips: 50
    num_posts: 200_000
    rating_ratio: 0.75
    threads: 20
  
  Seeds are executed in batches with multiple threads using persistent HTTP connections for better performance.
  
  Users are created with unique logins enforced by database index.
    
  Ratings use pessimistic locking to ensure correct average calculations under concurrency.


  ### Running seeds:
  
    # Terminal 1: Start the server
    bin/rails server
    
    # Terminal 2: Run seeds
    bin/rails db:seed


## Installation

  ### Clone the repository:
    ```http
    git clone <repo-url>
    cd ranked-posts-api


   ### Install dependencies:
    ```http
    bundle install

  ### Setup the database:
    ```http
    rails db:create db:migrate


  ### Seed the database:
    ```http
    rails db:seed
