CREATE TYPE Status AS ENUM ('planned', 'active', 'ended')
CREATE TYPE Location AS ENUM ('beach', 'forest', 'main', 'tent')
CREATE TYPE Genre AS ENUM ('pop', 'rock', 'metal', 'rap', 'country', 'hip-hop', 'jazz', 'electronic')
CREATE TYPE TicketType AS ENUM ('basic', 'festival', 'camp', 'VIP')
CREATE TYPE TicketIncluded AS ENUM ('none', 'backstage', 'camp')
CREATE TYPE ValidFor AS ENUM ('one-day-only', 'entire-festival')
CREATE TYPE Difficulty AS ENUM ('easy', 'average', 'advanced')


CREATE TABLE Festivals (
	festival_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	max_capacitty INT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	status Status NOT NULL,
	has_camp BOOLEAN DEFAULT FALSE,
	stages INT REFERENCES Stages(stage_id),
	artists INT REFERENCES Artists(artist_id)
)

CREATE TABLE Stages(
	stage_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	max_capacity INT NOT NULL,
	has_cover BOOLEAN DEFAULT FALSE,
	location Location NOT NULL,
)

CREATE TABLE Artists(
	artist_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100),
	country VARCHAR(100) NOT NULL,
	genre Genre NOT NULL,
	number_of_members INT DEFAULT 1,
	status BOOLEAN DEFAULT TRUE,
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
	dob DATE NOT NULL,
	city VARCHAR(100) NOT NULL,
	country VARCHAR(100) NOT NULL,
	email VARCHAR NOT NULL,
	ticket INT REFERENCES Tickets(ticket_id),
	workshop INT REFERENCES WorkshopSignUp(signup_id)
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
	purchase_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	total_cost DOUBLE NOT NULL,
	--ticket_type VARCHAR REFERENCES Tickets(type),
	ticket_number INT DEFAULT 1,
)

CREATE TABLE Workshops(
	workshop_id SERIAL PRIMARY KEY,
	festival INT REFERENCES Festivals(festival_id),
	name VARCHAR(100) NOT NULL,
	difficulty Difficulty NOT NULL,
	max_capacity INT NOT NULL,
	duration TIMESTAMP NOT NULL,
	prior_experience BOOLEAN DEFAULT FALSE,
)

CREATE TABLE WorkshopSignUp(
	signup_id SERIAL PRIMARY KEY,
	status Status NOT NULL,
	signup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	workshop_id INTEGER NOT NULL REFERENCES Workshops(workshop_id)
)

CREATE TABLE Mentors(
	mentor_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob TIMESTAMP NOT NULL,
	area VARCHAR(100) NOT NULL,
	experience INT NOT NULL,
)

CREATE TABLE Personnel(
	worker_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob TIMESTAMP NOT NULL,
	role VARCHAR(50) NOT NULL,
	contact INT,
	safety_training BOOLEAN NOT NULL DEFAULT FALSE,
	festival INT REFERENCES Festivals(festival_id)
)

CREATE TABLE Memberships(
	membership_id SERIAL PRIMARY KEY,
	visitor INT REFERENCES Visitors(visitor_id),
	status Status NOT NULL,
	activation_time DATE NOT NULL,
)

