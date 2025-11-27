-- 04_seed.sql
-- Minimal seed data for River & Coastal Clean-Up Tracker

-- Users (⚠️ replace hashes with real bcrypt/argon2 hashes in production)
INSERT INTO app_user (username, password_hash, role) VALUES
('admin', '$argon2id$v=19$m=65536,t=3,p=2$REPLACE$REPLACE', 'Admin'),
('organizer1', '$argon2id$v=19$m=65536,t=3,p=2$REPLACE$REPLACE', 'Organizer');

-- Organizers
INSERT INTO organizer (organizer_name, contact_info)
VALUES ('Scouts Association of Belize', 'info@scoutsbelize.org');

-- Events
INSERT INTO event (title, date, location, status, organizer_id)
VALUES ('Coastal Cleanup - Yabra', DATE '2025-10-11', 'Belize City Waterfront', 'Completed', 1);

-- Volunteers
INSERT INTO volunteer (name, organization, role, hours_contributed, consent_status)
VALUES ('Alice Brown', 'UB', 'Volunteer', 0, TRUE),
       ('John Doe', 'Community Group', 'Volunteer', 0, TRUE);

-- Participation (link volunteers to event)
INSERT INTO participation (event_id, volunteer_id, hours)
VALUES (1, 1, 3.5),
       (1, 2, 2.0);

-- Waste categories
INSERT INTO waste_category (category_name) VALUES
('Plastic'), ('Glass'), ('Metal'), ('Paper'), ('Organic'), ('Mixed');

-- Waste records (example from Phase 3 report)
INSERT INTO waste_record (event_id, waste_category_id, quantity, weight_kg)
SELECT 1, wc.waste_category_id, x.qty, x.kg
FROM waste_category wc
JOIN (VALUES
    ('Plastic', 45, 12.30::NUMERIC),
    ('Glass',   10,  5.00::NUMERIC),
    ('Metal',   28,  7.10::NUMERIC)
) AS x(name, qty, kg) ON wc.category_name = x.name;

-- Document & Report
INSERT INTO document (title, type, url)
VALUES ('Coastal Cleanup - Yabra Summary', 'Report', 'https://example.org/reports/yabra-2025');

INSERT INTO report (participation_id, summary, document_id)
VALUES (1, 'Summary of activities and totals for Yabra cleanup.', 1);

-- Photos
INSERT INTO photo (event_id, url, consent_required, latitude, longitude)
VALUES (1, 'https://example.org/photos/yabra-group.jpg', TRUE, 17.4889, -88.1829);
