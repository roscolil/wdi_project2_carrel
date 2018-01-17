/* Database schema:
DB name: carrel_db
Tables:
bookshelf			→ id, title, genre, author
wishlist				→ id, title, genre, author, image_url
comments			→ id, body, catalogue_id
users				→ id, name, email, password_digest */


CREATE DATABASE carrel_db;

CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(300),
  genre VARCHAR(300),
  author VARCHAR(300)
  );

CREATE TABLE wishlists (
  id SERIAL PRIMARY KEY,
  title VARCHAR(300),
  genre VARCHAR(300),
  author VARCHAR(300),
  );

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body VARCHAR(300) NOT NULL,
  book_id INTEGER NOT NULL,
  FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE RESTRICT
  );

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(300) NOT NULL,
  password_digest TEXT
  );

  CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    body VARCHAR(500) NOT NULL,
    dish_id INTEGER NOT NULL,
    FOREIGN KEY (dish_id) REFERENCES dishes (id) ON DELETE RESTRICT
    );
