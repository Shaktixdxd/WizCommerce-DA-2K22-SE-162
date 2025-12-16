/* =========================================================
   FILE: 30_Days_Upgrade.sql

   PURPOSE:
   - Calculate how many users upgraded within 30 days of signup
   - Compute upgrade rate within 30 days
========================================================= */

-- ---------------------------------------------------------
-- UPGRADE WITHIN 30 DAYS OF SIGNUP
-- ---------------------------------------------------------

WITH upgrade_timing AS (
    SELECT
        pay.user_id,
        (pay.payment_date - u.signup_date) AS days_to_upgrade
    FROM payments pay
    JOIN users u
      ON pay.user_id = u.user_id
),

upgraded_30 AS (
    SELECT COUNT(DISTINCT user_id) AS users
    FROM upgrade_timing
    WHERE days_to_upgrade <= 30
),

all_users AS (
    SELECT COUNT(DISTINCT user_id) AS users
    FROM users
)

SELECT
    u30.users AS upgraded_within_30_days,
    au.users  AS total_users,
    u30.users * 1.0 / au.users AS upgrade_rate_30_days
FROM upgraded_30 u30
CROSS JOIN all_users au;
