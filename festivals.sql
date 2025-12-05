CREATE TABLE Festivals (
	festival_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	max_capacitty INT NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP NOT NULL,
	status Status NOT NULL,
	has_camp BOOLEAN NOT NULL,
	stages INT REFERENCES Stages(stages),
	artists INT REFERENCES Artists(artists)
)

CREATE TABLE Stages(
	stage_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	max_capacity INT NOT NULL,
	has_cover BOOLEAN NOT NULL,
	location Location NOT NULL,
)

CREATE TABLE Artists(
	artist_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100),
	country VARCHAR(100) NOT NULL,
	genre Genre NOT NULL,
	number_of_members INT DEFAULT 1,
	status BOOLEAN NOT NULL,
	festivals INT REFERENCES Festivals(festivals_id),
	performances INT REFERENCES Peroformances(performances_id)
)

CREATE TABLE Performances(
	performance_id SERIAL PRIMARY KEY,
	festivals INT REFERENCES Festivals(festivals_id),
	stage INT REFERENCES Stages(stage_id),
	artist INT REFERENCES Artists(artist_id),
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP NOT NULL,
	visitor_number INT NOT NULL
)

CREATE TABLE Visitors(
	visitor_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob TIMESTAMP NOT NULL,
	city VARCHAR NOT NULL,
	country VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
	ticket INT REFERENCES Tickets(ticket_id),
	workshop INT REFERENCES !!!!!!!!!!!!!!!!!!!!
)

CREATE TABLE Tickets(
	ticket_id SERIAL PRIMARY KEY,
	type TicketType NOT NULL,
	price DOUBLE NOT NULL,
	included TicketIncluded NOT NULL,
	duration ValidFor NOT NULL
)

CREATE TABLE Purchase(
	purchase_id SERIAL PRIMARY KEY,
	visitor INT REFERENCES Visitors(visitor_id),
	festival INT REFERENCES Festivals(festival_id),
	purchase_time TIMESTAMP NOT NULL,
	total_cost DOUBLE NOT NULL,
	ticket_type VARCHAR REFERENCES Tickets(type),
	ticket_number INT DEFAULT 1,
)

CREATE TABLE Workshops(
	workshop_id SERIAL PRIMARY KEY,
	festival INT REFERENCES Festivals(festival_id),
	name VARCHAR(100) NOT NULL,
	difficulty Difficulty NOT NULL,
	max_capacity INT NOT NULL,
	duration TIMESTAMP NOT NULL,
	prior_experience BOOLEAN NOT NULL,
)

CREATE TABLE Mentors(
	mentor_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob TIMESTAMP NOT NULL,
	area VARCHAR NOT NULL,
	experience TIMESTAMP NOT NULL,
)

CREATE TABLE Personnel(
	worker_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob TIMESTAMP NOT NULL,
	role VARCHAR NOT NULL,
	contact INT,
	safety_training BOOLEAN NOT NULL,
	festival INT REFERENCES Festivals(festival_id)
)

CREATE TABLE Memberships(
	membership_id SERIAL PRIMARY KEY,
	visitor INT REFERENCES Visitors(visitor_id),
	status Status NOT NULL,
	activation_time TIMESTAMP NOT NULL,
)

CREATE TYPE Status AS ENUM ('planned', 'active', 'ended')
CREATE TYPE Location AS ENUM ('beach', 'forest', 'main')
CREATE TYPE Genre AS ENUM ('pop', 'rock', 'metal', 'rap', 'country', 'hip-hop', 'jazz', 'electronic')
CREATE TYPE TicketType AS ENUM ('basic', 'festival', 'camp', 'VIP')
CREATE TYPE TicketIncluded AS ENUM ('none', 'backstage', 'camp')
CREATE TYPE ValidFor AS ENUM ('one-day-only', 'entire-festival')
CREATE TYPE Difficulty AS ENUM ('easy', 'average', 'advanced')
