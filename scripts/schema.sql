-- hylowiki
-- GA WDI Project 1
-- Author: Michael N. Rubinstein

CREATE TABLE page_versions (
	id			INTEGER PRIMARY KEY,
	page_id		INTEGER NOT NULL,
	author_id	INTEGER NOT NULL,
	time_stamp	INTEGER NOT NULL,
	title		VARCHAR(255),
	body		TEXT
);

CREATE TABLE users (
	id			INTEGER PRIMARY KEY,
	username	VARCHAR(15),
	password	VARCHAR(15),
	fullname	VARCHAR(255),
	email		VARCHAR(50)
);
