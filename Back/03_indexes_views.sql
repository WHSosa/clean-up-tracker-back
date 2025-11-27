-- 03_indexes_views.sql
-- Indexes and reporting views

-- Indexes
CREATE INDEX idx_event_date ON event (date);
CREATE INDEX idx_event_org ON event (organizer_id);

CREATE INDEX idx_volunteer_name ON volunteer (name);

CREATE INDEX idx_participation_event ON participation (event_id);
CREATE INDEX idx_participation_volunteer ON participation (volunteer_id);

CREATE INDEX idx_waste_record_event ON waste_record (event_id);
CREATE INDEX idx_waste_record_category ON waste_record (waste_category_id);

CREATE INDEX idx_document_type ON document (type);
CREATE INDEX idx_document_upload_date ON document (upload_date);

CREATE INDEX idx_report_participation ON report (participation_id);
CREATE INDEX idx_report_document ON report (document_id);

CREATE INDEX idx_photo_event ON photo (event_id);
CREATE INDEX idx_photo_consent ON photo (consent_required);

-- Views
CREATE VIEW v_event_waste_summary AS
SELECT
    e.event_id,
    e.title,
    e.date,
    e.location,
    COALESCE(SUM(wr.quantity), 0)       AS total_items,
    COALESCE(SUM(wr.weight_kg), 0.00)   AS total_weight_kg
FROM event e
LEFT JOIN waste_record wr ON wr.event_id = e.event_id
GROUP BY e.event_id, e.title, e.date, e.location;

CREATE VIEW v_event_participation_summary AS
SELECT
    e.event_id,
    e.title,
    COUNT(p.participation_id)       AS volunteers_count,
    COALESCE(SUM(p.hours), 0.00)    AS volunteer_hours
FROM event e
LEFT JOIN participation p ON p.event_id = e.event_id
GROUP BY e.event_id, e.title;

CREATE VIEW v_event_dashboard AS
SELECT
    e.event_id,
    e.title,
    e.date,
    e.location,
    e.status,
    o.organizer_name,
    p.volunteers_count,
    p.volunteer_hours,
    w.total_items,
    w.total_weight_kg
FROM event e
JOIN organizer o ON o.organizer_id = e.organizer_id
LEFT JOIN v_event_participation_summary p ON p.event_id = e.event_id
LEFT JOIN v_event_waste_summary w ON w.event_id = e.event_id;
