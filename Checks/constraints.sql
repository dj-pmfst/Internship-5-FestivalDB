ALTER TABLE Festivals
	ADD CONSTRAINT ValidDate
	CHECK (end_date >= start_date);

ALTER TABLE Performances
	ADD CONSTRAINT ValidTime
	CHECK (end_time >= start_time);

ALTER TABLE Mentors
	ADD CONSTRAINT IsQualified
	CHECK (EXTRACT(YEAR FROM AGE(dob)) >= 18 AND experience >= 2);

ALTER TABLE Personnel
	ADD CONSTRAINT IsQualified
	CHECK (
	    role <> 'security'
	    OR DATE_PART('year', AGE(CURRENT_DATE, dob)) >= 21);

ALTER TABLE Workshops
	ADD CONSTRAINT ExperienceRequirement
	CHECK(difficulty != 'advanced' OR prior_experience = true);

ALTER TABLE Mentors
	ADD CONSTRAINT ExperienceCheck
	CHECK (experience <= EXTRACT(YEAR FROM AGE(dob)) - 18);

ALTER TABLE Visitors
	ADD CONSTRAINT EmailValid
	CHECK (email LIKE '%_@_%._%' AND LENGTH(email) > 5);

ALTER TABLE Workshops
	ADD CONSTRAINT ReasonableDuration
	CHECK (duration >= 0.5 AND duration <= 24);  

ALTER TABLE Visitors
	ADD CONSTRAINT DobValid
	CHECK (EXTRACT(YEAR FROM AGE(DOB)) <= 85);