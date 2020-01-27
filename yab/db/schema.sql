CREATE TABLE IF NOT EXISTS category (
       id SERIAL PRIMARY KEY,
       label VARCHAR(300) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tag (
       id SERIAL PRIMARY KEY,
       label VARCHAR(300) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS entry (
	id SERIAL PRIMARY KEY,
	title VARCHAR(300) NOT NULL,
	content TEXT,
        category INTEGER REFERENCES category(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS post_tags (
       post INTEGER REFERENCES entry(id),
       tag INTEGER REFERENCES tag(id),
       UNIQUE (post, tag)
);
