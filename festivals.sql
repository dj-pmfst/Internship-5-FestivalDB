CREATE TABLE Festivals (
	festival_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	max_capacitty INT NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP NOT NULL,
	status VARCHAR,
	has_camp BOOLEAN,
	stages INT REFERENCES Stages(stages),
	artists INT REFERENCES Artists(artists)
)

CREATE TABLE Stages(
	stage_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	max_capacity INT NOT NULL,
	has_cover BOOLEAN,
)

CREATE TABLE Artists(
	artist_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100),
	country VARCHAR(100),
	genre VARCHAR(100) NOT NULL,
	number_of_members INT,
	status BOOLEAN,
	festivals INT REFERENCES Festivals(festivals_id),
	performances INT REFERENCES Peroformances(performances_id)
)

CREATE TABLE Performances(
	performance_id SERIAL PRIMARY KEY,
	festivals INT REFERENCES Festivals(festivals_id),
	stage INT REFERENCES Stages(stage_id),
	artist INT REFERENCES Artists(artist_id),
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	visitor_number INT
)

CREATE TABLE Visitors(
	visitor_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob TIMESTAMP NOT NULL,
	city VARCHAR,
	country VARCHAR,
	email VARCHAR NOT NULL,
	ticket INT REFERENCES Tickets(ticket_id),
	workshop INT REFERENCES !!!!!!!!!!!!!!!!!!!!
)

CREATE TABLE Tickets(
	ticket_id SERIAL PRIMARY KEY,
	type VARCHAR NOT NULL,
	price DOUBLE NOT NULL,
	included VARCHAR,
	duration VARCHAR NOT NULL
)

CREATE TABLE Purchase(
	purchase_id SERIAL PRIMARY KEY,
	visitor INT REFERENCES Visitors(visitor_id),
	festival INT REFERENCES Festivals(festival_id),
	purchase_time TIMESTAMP NOT NULL,
	total_cost DOUBLE NOT NULL,
	ticket_type VARCHAR REFERENCES Tickets(type),
	ticket_number INT,
)

CREATE TABLE Workshops(
	workshop_id SERIAL PRIMARY KEY,
	festival INT REFERENCES Festivals(festival_id),
	name VARCHAR(100) NOT NULL,
	difficulty VARCHAR NOT NULL,
	max_capacity INT,
	duration TIMESTAMP,
	prior_experience BOOLEAN,
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
	safety_training BOOLEAN,
	festival INT REFERENCES Festivals(festival_id)
)

CREATE TABLE Memberships(
	membership_id SERIAL PRIMARY KEY,
	visitor INT REFERENCES Visitors(visitor_id),
	status VARCHAR,
	activation_time TIMESTAMP,
)





