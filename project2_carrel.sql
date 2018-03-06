/* Database schema:
DB name: carrel_db
Tables:
bookshelf			→ id, title, genre, author
wishlist				→ id, title, genre, author, image_url
comments			→ id, body, catalogue_id
users				→ id, name, email, password_digest */

/* https://github.com/roscolil/wdi_project2_carrel/raw/master/db.dump

heroku pg:backups:restore 'https://github.com/roscolil/wdi_project2_carrel/raw/master/db.dump' DATABASE_URL */

CREATE DATABASE carrel_db;

CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(300),
  genre VARCHAR(300),
  author VARCHAR(300),
  );

CREATE TABLE wishes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(300),
  genre VARCHAR(300),
  author VARCHAR(300),
  price VARCHAR(300)
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
