-- hylowiki
-- GA WDI Project 1
-- Author: Michael N. Rubinstein

INSERT INTO
	users (username, password, fullname, email)
VALUES
	('voordrok', 'bluedude', 'Mortimer N. Snerd', 'tomes@yahoo.com'),
	('melkur', 'fr0tz', 'Melvin Frucht', 'frucht@gmail.com'),
	('suenteuspo', 'ast0ria', 'Dave Sim', 'cerebus@estarcion.net')
;


INSERT INTO
	page_versions (page_id, author_id, time_stamp, title, body)
VALUES
	(1, 1, 1410891767, 'Apple Watch', 'The Apple Watch is a smartwatch created by Apple Inc., announced by Tim Cook on September 9, 2014. It has activity tracking capabilities similar to other wearable technologies, such as Jawbone Up, Nike+ FuelBand and Fitbit. The Apple Watch must be used in conjunction with the iPhone 5 or a newer iPhone model. It is scheduled to be released in early 2015.'),
	(2, 1, 1410891802, 'Apple Inc.', 'Apple Inc. is an American multinational corporation headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Its best-known hardware products are the Mac line of computers, the iPod media player, the iPhone smartphone, and the iPad tablet computer. Its online services include iCloud, iTunes Store, and App Store. Its consumer software includes the OS X and iOS operating systems, the iTunes media browser, the Safari web browser, and the iLife and iWork creativity and productivity suites.'),
	(2, 3, 1410891885, 'Apple Inc.', 'Apple Inc. is an American multinational corporation headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Its best-known hardware products are the Mac line of computers, the iPod media player, the iPhone smartphone, and the iPad tablet computer. Its online services include iCloud, iTunes Store, and App Store. Its consumer software includes the OS X and iOS operating systems, the iTunes media browser, the Safari web browser, and the iLife and iWork creativity and productivity suites.

Apple was founded by Steve Jobs, Steve Wozniak, and Ronald Wayne on April 1, 1976, to develop and sell personal computers. It was incorporated as Apple Computer, Inc. on January 3, 1977, and was renamed as Apple Inc. on January 9, 2007, to reflect its shifted focus towards consumer electronics.'),
	(3, 2, 1410891831, 'smartwatch', 'A smartwatch (or smart watch) is a computerized wristwatch with functionality that is enhanced beyond timekeeping, and is often comparable to a personal digital assistant (PDA) device. While early models can perform basic tasks, such as calculations, translations, and game-playing, modern smartwatches are effectively wearable computers. Many smartwatches run mobile apps, while a smaller number of models run a mobile operating system and function as portable media players, offering playback of FM radio, audio, and video files to the user via a Bluetooth headset. Some smartwatches models, also called watch phones, feature full mobile phone capability, and can make or answer phone calls.')
;
