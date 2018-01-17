/* Database schema:
DB name: carrel_db
Tables:
bookshelf			→ id, title, genre, author
wishlist				→ id, title, genre, author, image_url
comments			→ id, body, catalogue_id
users				→ id, name, email, password_digest */


CREATE DATABASE carrel_db;

CREATE TABLE bookshelves (
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
  bookshelf_id INTEGER NOT NULL
  );

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(300) NOT NULL,
  password_digest VARCHAR(300)
  );
