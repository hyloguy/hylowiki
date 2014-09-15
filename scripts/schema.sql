CREATE TABLE page_versions (
	id			INTEGER PRIMARY KEY,
	page_id		INTEGER NOT NULL,
	title		VARCHAR(255),
	body		TEXT
);
