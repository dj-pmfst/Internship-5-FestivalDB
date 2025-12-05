CREATE TYPE Status AS ENUM ('planned', 'active', 'ended')
CREATE TYPE Location AS ENUM ('beach', 'forest', 'main', 'tent')
CREATE TYPE Genre AS ENUM ('pop', 'rock', 'metal', 'rap', 'country', 'hip-hop', 'jazz', 'electronic')
CREATE TYPE TicketType AS ENUM ('basic', 'festival', 'camp', 'VIP')
CREATE TYPE TicketIncluded AS ENUM ('none', 'backstage', 'camp')
CREATE TYPE ValidFor AS ENUM ('one-day-only', 'entire-festival')
CREATE TYPE Difficulty AS ENUM ('easy', 'average', 'advanced')
CREATE TYPE Role AS ENUM ('organiser', 'technician', 'security', 'volunteer')


CREATE TABLE Festivals (
	festival_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	max_capacity INT NOT NULL CHECK(max_capacity > 0),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	status Status NOT NULL DEFAULT 'planned',
	has_camp BOOLEAN DEFAULT FALSE,
)

CREATE TABLE Stages(
	stage_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	max_capacity INT NOT NULL CHECK(max_capacity > 0),
	has_cover BOOLEAN DEFAULT FALSE,
	location Location NOT NULL,
	festival INT NOT NULL REFERENCES Festivals(festival_id)
)

CREATE TABLE Artists(
	artist_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100),
	country VARCHAR(100) NOT NULL,
	genre Genre NOT NULL,
	number_of_members INT DEFAULT 1 CHECK(number_of_members > 0),
	status BOOLEAN DEFAULT TRUE,
)

CREATE TABLE Performances(
	performance_id SERIAL PRIMARY KEY,
	festivals INT NOT NULL REFERENCES Festivals(festivals_id),
	stage INT NOT NULL REFERENCES Stages(stage_id),
	artist INT NOT NULL REFERENCES Artists(artist_id),
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP NOT NULL,
	visitor_number INT NOT NULL CHECK(visitor_number >= 0)
)

CREATE TABLE Visitors(
	visitor_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob DATE NOT NULL,
	city VARCHAR(100) NOT NULL,
	country VARCHAR(100) NOT NULL,
	email VARCHAR NOT NULL,
)

CREATE TABLE Tickets(
	ticket_id SERIAL PRIMARY KEY,
	type TicketType NOT NULL,
	price DECIMAL(10,2) NOT NULL CHECK(price >= 0),
	included TicketIncluded NOT NULL,
	duration ValidFor NOT NULL,
	festival INT NOT NULL REFERENCES Festival(festival_id)
)

CREATE TABLE Purchase(
	purchase_id SERIAL PRIMARY KEY,
	visitor INT NOT NULL REFERENCES Visitors(visitor_id),
	festival INT NOT NULL REFERENCES Festivals(festival_id),
	purchase_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	total_cost DECIMAL(10,2) NOT NULL CHECK(total_cost >= 0)
)

CREATE TABLE PurchaseItem(
	item_id SERIAL PRIMARY KEY,
    purchase INTEGER NOT NULL REFERENCES Purchase(purchase_id),
    ticket INTEGER NOT NULL REFERENCES Ticket(ticket_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
)

CREATE TABLE Workshops(
	workshop_id SERIAL PRIMARY KEY,
	festival INT NOT NULL REFERENCES Festivals(festival_id),
	mentor INT NOT NULL REFERENCES Mentors(mentor_id),
	name VARCHAR(100) NOT NULL,
	difficulty Difficulty NOT NULL,
	max_capacity INT NOT NULL CHECK(max_capacity > 0),
	duration DECIMAL(4,2) NOT NULL CHECK(duration > 0),
	prior_experience BOOLEAN DEFAULT FALSE
)

CREATE TABLE WorkshopSignUp(
	signup_id SERIAL PRIMARY KEY,
	status Status NOT NULL,
	signup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	workshop INT NOT NULL REFERENCES Workshops(workshop_id),
	visitor INT NOT NULL REFERENCES Visitors(visitor_id)
)

CREATE TABLE Mentors(
	mentor_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob DATE NOT NULL,
	area VARCHAR(100) NOT NULL,
	experience INT NOT NULL CHECK(experience >= 0),
)

CREATE TABLE Personnel(
	worker_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	dob DATE NOT NULL,
	role Role NOT NULL,
	contact VARCHAR(20),
	safety_training BOOLEAN NOT NULL DEFAULT FALSE,
	festival INT NOT NULL REFERENCES Festivals(festival_id)
)

CREATE TABLE Memberships(
	membership_id SERIAL PRIMARY KEY,
	visitor INT NOT NULL REFERENCES Visitors(visitor_id),
	status Status NOT NULL,
	activation_time DATE NOT NULL,
)

