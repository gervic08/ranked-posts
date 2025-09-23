# Ranked Posts API

A Ruby on Rails API application to manage posts and ratings, designed to handle large datasets efficiently.

## Features

- Create posts associated with users and IP addresses.

- Rate posts with one rating per user per post.

- Retrieve average post ratings.

- Get top N posts by average rating.

- Query IPs shared by multiple users, along with their logins.

- Fully API-driven, supporting bulk data generation via curl.

- Efficient and scalable handling of high-volume seeds with threads and batches.

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
    threads: 10
    batch_size: 20_000
  
  Seeds are executed in batches with multiple threads to optimize performance.
    
  Users are cached in memory to avoid duplicate creations.
    
  Ratings are calculated incrementally to avoid expensive AVG queries.

  ### Example curl request for creating a post
    ```http
    curl -s -X POST http://localhost:3000/api/v1/posts \
    -H 'Content-Type: application/json' \
    -d '{
    "title": "Post Title",
    "body": "Post body",
    "user_login": "user1",
    "ip": "123.45.67.89"
    }'

  ### Performance

  Creating 1000 posts with ratings takes ~19 seconds on a local development setup.
  
  Bulk creation of 200k posts is handled in batches with threads to reduce total runtime.

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
