--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Postgres.app)
-- Dumped by pg_dump version 17.5 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articles (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    published_date DATE NOT NULL,
    category TEXT NOT NULL,
    author_id INT REFERENCES authors(id)
);

ALTER TABLE public.articles OWNER TO postgres;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

ALTER TABLE public.users OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id SERIAL PRIMARY KEY,
    article_id INT REFERENCES articles(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE SET NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.comments OWNER TO postgres;

--
-- Inserting data for users
--

INSERT INTO authors (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Bob', 'Smith', 'bob.smith@example.com');

--
-- Inserting data for articles
--

INSERT INTO public.articles (title, body, published_date, category) VALUES 
('PostgreSQL Performance Optimization', 
 'Optimizing PostgreSQL performance involves indexing strategies, query tuning, and proper database configuration. Using full-text search effectively can improve retrieval speed.', 
 '2024-01-15', 'Database', 1),

('Artificial Intelligence in Healthcare', 
 'AI-powered tools are transforming healthcare by improving diagnostics, patient care, and drug discovery. However, challenges such as data privacy and accuracy remain.', 
 '2024-02-10', 'Technology', 2),

('Introduction to Machine Learning', 
 'Machine learning enables computers to learn patterns from data and make predictions. Supervised and unsupervised learning are the two main approaches.', 
 '2024-03-01', 'AI', 2),

('Cloud Computing Trends in 2025', 
 'Cloud computing continues to evolve with serverless architectures, hybrid cloud strategies, and increased security measures shaping the industry.', 
 '2024-04-05', 'Technology', 2),

('Understanding Relational Databases', 
 'Relational databases store data in structured tables with relationships. SQL is commonly used to interact with these databases efficiently.', 
 '2024-05-20', 'Database', 1);

CREATE INDEX idx_articles_search ON public.articles USING GIN(to_tsvector('english', body));

--
-- Inserting data for users
--

INSERT INTO users (username, email) VALUES 
('john_doe', 'john.doe@example.com'),
('jane_doe', 'jane.doe@example.com');


--
-- Inserting data for comments
--

INSERT INTO comments (article_id, user_id, comment_text) VALUES 
(1, 1, 'Great insights on PostgreSQL performance!'),
(2, 2, 'Excited to see how cloud computing evolves.');
