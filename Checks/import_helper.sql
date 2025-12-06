ALTER TABLE Festivals DISABLE TRIGGER ALL;
ALTER TABLE Performances DISABLE TRIGGER ALL;
ALTER TABLE Mentors DISABLE TRIGGER ALL;
ALTER TABLE Personnel DISABLE TRIGGER ALL;
ALTER TABLE Workshops DISABLE TRIGGER ALL;
ALTER TABLE Visitors DISABLE TRIGGER ALL;
ALTER TABLE Memberships DISABLE TRIGGER ALL;
ALTER TABLE Artists DISABLE TRIGGER ALL;
ALTER TABLE Stages DISABLE TRIGGER ALL;
ALTER TABLE Tickets DISABLE TRIGGER ALL;
ALTER TABLE Purchase DISABLE TRIGGER ALL;
ALTER TABLE PurchaseItem DISABLE TRIGGER ALL;
ALTER TABLE WorkshopSignUp DISABLE TRIGGER ALL;

ALTER TABLE Festivals ALTER COLUMN end_date DROP NOT NULL;
ALTER TABLE Performances ALTER COLUMN end_time DROP NOT NULL;

---dodavanje mockaroo fileovea

DELETE FROM Festivals 
WHERE end_date < start_date;

DELETE FROM Performances 
WHERE end_time <= start_time;

DELETE FROM Mentors 
WHERE EXTRACT(YEAR FROM AGE(dob)) < 18 
   OR experience < 2;

DELETE FROM Mentors 
WHERE experience > EXTRACT(YEAR FROM AGE(dob)) - 18;

DELETE FROM Personnel 
WHERE role = 'security' 
  AND DATE_PART('year', AGE(dob)) < 21;

UPDATE Workshops 
SET prior_experience = TRUE 
WHERE difficulty = 'advanced' AND prior_experience = FALSE;

DELETE FROM Visitors 
WHERE email NOT LIKE '%_@_%._%' 
   OR LENGTH(email) <= 5;

DELETE FROM Performances p1
WHERE EXISTS (
    SELECT 1 FROM Performances p2
    WHERE p1.artist = p2.artist 
      AND p1.stage = p2.stage
      AND p1.performance_id > p2.performance_id
      AND (
          (p1.start_time >= p2.start_time AND p1.start_time < p2.end_time)
          OR (p1.end_time > p2.start_time AND p1.end_time <= p2.end_time)
          OR (p1.start_time <= p2.start_time AND p1.end_time >= p2.end_time)
      )
);

DELETE FROM Personnel p1
WHERE EXISTS (
    SELECT 1 
    FROM Personnel p2
    JOIN Festivals f1 ON p1.festival = f1.festival_id
    JOIN Festivals f2 ON p2.festival = f2.festival_id
    WHERE p1.worker_id > p2.worker_id
      AND p1.name = p2.name
      AND p1.surname = p2.surname
      AND (f1.start_date <= f2.end_date AND f1.end_date >= f2.start_date)
);

DELETE FROM Memberships m
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT 
            visitor,
            COUNT(DISTINCT festival) as fest_count,
            SUM(total_cost) as total_spent
        FROM Purchase
        GROUP BY visitor
    ) p
    WHERE p.visitor = m.visitor
      AND p.fest_count > 3
      AND p.total_spent > 600
);

ALTER TABLE Festivals ENABLE TRIGGER ALL;
ALTER TABLE Performances ENABLE TRIGGER ALL;
ALTER TABLE Mentors ENABLE TRIGGER ALL;
ALTER TABLE Personnel ENABLE TRIGGER ALL;
ALTER TABLE Workshops ENABLE TRIGGER ALL;
ALTER TABLE Visitors ENABLE TRIGGER ALL;
ALTER TABLE Memberships ENABLE TRIGGER ALL;
ALTER TABLE Artists ENABLE TRIGGER ALL;
ALTER TABLE Stages ENABLE TRIGGER ALL;
ALTER TABLE Tickets ENABLE TRIGGER ALL;
ALTER TABLE Purchase ENABLE TRIGGER ALL;
ALTER TABLE PurchaseItem ENABLE TRIGGER ALL;
ALTER TABLE WorkshopSignUp ENABLE TRIGGER ALL;


SELECT COUNT(*) FROM Artists;
SELECT COUNT(*) FROM Visitors;
SELECT COUNT(*) FROM Mentors;
SELECT COUNT(*) FROM Stages;
SELECT COUNT(*) FROM Tickets;
SELECT COUNT(*) FROM Performances;
SELECT COUNT(*) FROM Workshops;
SELECT COUNT(*) FROM Purchase;
SELECT COUNT(*) FROM PurchaseItem;
SELECT COUNT(*) FROM WorkshopSignUp;
SELECT COUNT(*) FROM Personnel;
SELECT COUNT(*) FROM Memberships;