-- 02_tables.sql
-- Core tables and relationships

-- 1) Organizer
CREATE TABLE organizer (
    organizer_id       SERIAL PRIMARY KEY,
    organizer_name     VARCHAR(150) NOT NULL,
    contact_info       VARCHAR(200),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (organizer_name)
);

-- 2) Event
CREATE TABLE event (
    event_id           SERIAL PRIMARY KEY,
    title              VARCHAR(120) NOT NULL,
    date               DATE NOT NULL,
    location           VARCHAR(150) NOT NULL,
    status             event_status NOT NULL DEFAULT 'Planned',
    organizer_id       INT NOT NULL REFERENCES organizer(organizer_id) ON DELETE RESTRICT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT event_date_check CHECK (date >= DATE '1900-01-01')
);

-- 3) Volunteer
CREATE TABLE volunteer (
    volunteer_id       SERIAL PRIMARY KEY,
    name               VARCHAR(100) NOT NULL,
    organization       VARCHAR(120),
    hours_contributed  NUMERIC(6,2) NOT NULL DEFAULT 0.00,
    role               VARCHAR(50) NOT NULL DEFAULT 'Volunteer',
    consent_status     BOOLEAN NOT NULL DEFAULT FALSE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT volunteer_role_check CHECK (role IN ('Volunteer', 'Organizer'))
);

-- 4) Participation
CREATE TABLE participation (
    participation_id   SERIAL PRIMARY KEY,
    event_id           INT NOT NULL REFERENCES event(event_id) ON DELETE RESTRICT,
    volunteer_id       INT NOT NULL REFERENCES volunteer(volunteer_id) ON DELETE RESTRICT,
    hours              NUMERIC(6,2) NOT NULL DEFAULT 0.00,
    notes              VARCHAR(250),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT participation_hours_check CHECK (hours >= 0),
    UNIQUE (event_id, volunteer_id)
);

-- 5) Waste category
CREATE TABLE waste_category (
    waste_category_id  SERIAL PRIMARY KEY,
    category_name      VARCHAR(80) NOT NULL,
    description        VARCHAR(200),
    UNIQUE (category_name)
);

-- 6) Waste record
CREATE TABLE waste_record (
    record_id          SERIAL PRIMARY KEY,
    event_id           INT NOT NULL REFERENCES event(event_id) ON DELETE RESTRICT,
    waste_category_id  INT NOT NULL REFERENCES waste_category(waste_category_id) ON DELETE RESTRICT,
    quantity           INT NOT NULL DEFAULT 0,
    weight_kg          NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT waste_quantity_check CHECK (quantity >= 0),
    CONSTRAINT waste_weight_check CHECK (weight_kg >= 0)
);

-- 7) Document
CREATE TABLE document (
    document_id        SERIAL PRIMARY KEY,
    title              VARCHAR(150) NOT NULL,
    type               document_type NOT NULL,
    upload_date        DATE NOT NULL DEFAULT CURRENT_DATE,
    url                VARCHAR(400),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8) Report
CREATE TABLE report (
    report_id          SERIAL PRIMARY KEY,
    participation_id   INT REFERENCES participation(participation_id) ON DELETE SET NULL,
    summary            TEXT,
    document_id        INT REFERENCES document(document_id) ON DELETE SET NULL,
    date_generated     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 9) Photo
CREATE TABLE photo (
    photo_id           SERIAL PRIMARY KEY,
    event_id           INT NOT NULL REFERENCES event(event_id) ON DELETE RESTRICT,
    url                VARCHAR(400) NOT NULL,
    consent_required   BOOLEAN NOT NULL DEFAULT FALSE,
    latitude           NUMERIC(9,6),
    longitude          NUMERIC(9,6),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT url_format_check CHECK (url ~* '^(https?://)')
);

-- 10) App user (basic auth)
CREATE TABLE app_user (
    user_id            SERIAL PRIMARY KEY,
    username           VARCHAR(60) NOT NULL UNIQUE,
    password_hash      VARCHAR(255) NOT NULL,
    role               VARCHAR(30) NOT NULL DEFAULT 'Volunteer',
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT app_user_role_check CHECK (role IN ('Volunteer','Organizer','Admin'))
);

-- Optional link organizer -> app_user
ALTER TABLE organizer
    ADD COLUMN user_id INT UNIQUE REFERENCES app_user(user_id) ON DELETE SET NULL;
