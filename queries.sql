SELECT 
	a.name AS artist,
	s.name AS stage,
	f.name AS festival,
	p.start_time
FROM performances p
JOIN artists a ON p.artist = a.artist_id
JOIN stages s ON p.stage = s.stage_id
JOIN festivals f ON p.festival = f.festival_id
WHERE visitor_number >= 10000;

SELECT * FROM Festivals WHERE EXTRACT(YEAR FROM start_date) = 2025

SELECT * FROM Workshops WHERE difficulty = 'advanced'
SELECT * FROM Workshops WHERE duration >= 4
SELECT * FROM Workshops WHERE prior_experience = true
SELECT * FROM Workshops 
	WHERE difficulty = 'advanced' 
	AND EXTRACT(YEAR FROM (
	    SELECT start_date 
	    FROM Festivals 
	    WHERE Festivals.festival_id = Workshops.festival
	)) = 2025;

SELECT * FROM Mentors WHERE experience >= 10
SELECT * FROM Mentors WHERE EXTRACT(YEAR FROM dob) < 1985

SELECT * FROM Visitors WHERE city = 'Split'
SELECT * FROM Visitors WHERE email LIKE '%@gmail.com'
SELECT * FROM Visitors WHERE EXTRACT(YEAR FROM AGE(dob)) < 25

SELECT * FROM Tickets WHERE price > 120
SELECT * FROM Tickets WHERE type = 'VIP'
SELECT * FROM Tickets WHERE duration = 'entire-festival'

SELECT * FROM Personnel WHERE safety_training = true
