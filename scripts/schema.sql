-- hylowiki
-- GA WDI Project 1
-- Author: Michael N. Rubinstein

CREATE TABLE users (
	id			INTEGER PRIMARY KEY,
	username	VARCHAR(50),
	password	VARCHAR(50),
	fullname	VARCHAR(255),
	email		VARCHAR(50)
);

CREATE TABLE page_versions (
	id			INTEGER PRIMARY KEY,
	page_id		INTEGER NOT NULL,
	author_id	INTEGER NOT NULL,
	time_stamp	INTEGER NOT NULL,
	title		VARCHAR(255),
	body		TEXT,
	FOREIGN KEY(author_id) REFERENCES users(id)
);
