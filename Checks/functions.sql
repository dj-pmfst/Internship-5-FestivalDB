CREATE OR REPLACE FUNCTION CheckMembershipEligibility()
RETURNS TRIGGER AS $$
DECLARE
    festival_count INTEGER;
    total_spending DECIMAL(10,2);
BEGIN
    SELECT 
        COUNT(DISTINCT p.festival),
        COALESCE(SUM(p.total_cost), 0)
    INTO festival_count, total_spending
    FROM Purchase p
    WHERE p.visitor = NEW.visitor;
    
    IF festival_count <= 3 THEN
        RAISE EXCEPTION 'min. 3 festivals req.';
    END IF;
    
    IF total_spending <= 600 THEN
        RAISE EXCEPTION 'min. 600 EUR spent';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER MembershipEligibilityCheck
    BEFORE INSERT OR UPDATE ON Memberships
    FOR EACH ROW
    EXECUTE FUNCTION CheckMembershipEligibility();


CREATE OR REPLACE FUNCTION CheckPersonnelFestivalOverlap()
RETURNS TRIGGER AS $$
DECLARE
    new_start DATE;
    new_end DATE;
BEGIN
    SELECT start_date, end_date 
    INTO new_start, new_end
    FROM Festivals 
    WHERE festival_id = NEW.festival;
    
    IF EXISTS (
        SELECT 1
        FROM Personnel p
        JOIN Festivals f ON p.festival = f.festival_id
        WHERE p.worker_id != COALESCE(NEW.worker_id, -1) 
          AND p.name = NEW.name
          AND p.surname = NEW.surname
          AND (
              (f.start_date <= new_end AND f.end_date >= new_start)
          )
    ) THEN
        RAISE EXCEPTION 'Radnik je već zaposlen na drugom festivalu u ovo vrijeme.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER PersonnelFestivalOverlapCheck
    BEFORE INSERT OR UPDATE ON Personnel
    FOR EACH ROW
    EXECUTE FUNCTION CheckPersonnelFestivalOverlap();


CREATE OR REPLACE FUNCTION CheckPerformanceOverlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Performances p
        WHERE p.performance_id != COALESCE(NEW.performance_id, -1)
          AND p.artist = NEW.artist
          AND p.stage = NEW.stage
          AND (
              (NEW.start_time >= p.start_time AND NEW.start_time < p.end_time)
              OR
              (NEW.end_time > p.start_time AND NEW.end_time <= p.end_time)
              OR
              (NEW.start_time <= p.start_time AND NEW.end_time >= p.end_time)
          )
    ) THEN
        RAISE EXCEPTION 'Izvođač već ima nastup u ovo vrijeme';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER PerformanceOverlapCheck
    BEFORE INSERT OR UPDATE ON Performances
    FOR EACH ROW
    EXECUTE FUNCTION CheckPerformanceOverlap();


CREATE OR REPLACE FUNCTION CheckWorkshopCapacity()
RETURNS TRIGGER AS $$
DECLARE
    festival_capacity INTEGER;
BEGIN
    SELECT max_capacity 
    INTO festival_capacity
    FROM Festivals 
    WHERE festival_id = NEW.festival;
    
    IF NEW.max_capacity > festival_capacity THEN
        RAISE EXCEPTION 'Kapacitet radionice veći od kapaciteta festivala';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER WorkshopCapacityCheck
    BEFORE INSERT OR UPDATE ON Workshops
    FOR EACH ROW
    EXECUTE FUNCTION CheckWorkshopCapacity();