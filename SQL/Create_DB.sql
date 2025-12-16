CREATE TABLE users (
  user_id      INT,
  signup_date  DATE,
  country      TEXT,
  device       TEXT,
  source       TEXT
);

CREATE TABLE events (
  user_id     INT,
  event_name  TEXT,
  event_time  TIMESTAMP
);

CREATE TABLE payments (
  user_id      INT,
  plan_type    TEXT,
  amount       NUMERIC,
  payment_date DATE
);

-- Verification
SELECT * FROM users LIMIT 5;
SELECT * FROM payments LIMIT 5;
SELECT * FROM events LIMIT 5;

-- Step 1: Signed up users
-- total signed-up users
SELECT COUNT(*) AS signed_up
FROM users;

-- Step 2: Viewed Feature
-- users with at least one viewed_feature event
SELECT COUNT(DISTINCT user_id) AS viewed_feature
FROM events
WHERE event_name = 'viewed_feature';

-- Step 3: Returned in 7 days
-- users who returned within 7 days after signup
SELECT COUNT(DISTINCT e.user_id) AS returned_in_7days
FROM events e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_time <= u.signup_date + INTERVAL '7 days';

-- Step 4: Upgraded
-- users present in payments (upgraded to paid)
SELECT COUNT(DISTINCT user_id) AS upgraded
FROM payments;


