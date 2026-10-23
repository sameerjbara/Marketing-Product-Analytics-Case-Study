/* =========================================================
   GRAPH 1 — USER PROGRESSION
   ========================================================= */

WITH params AS (
    SELECT
        DATE '2025-02-18' AS launch_date,
        MAX(activity_date) AS data_end_date
    FROM dice_user_level
),

user_installs AS (
    SELECT
        user_id,
        MIN(install_date) AS install_date
    FROM marketing_user_level
    GROUP BY user_id
),

cohorts AS (
    SELECT
        ui.user_id,
        ui.install_date,

        CASE
            WHEN ui.install_date + INTERVAL '29 days' < p.launch_date
                THEN 'Pre-feature'
            WHEN ui.install_date >= p.launch_date
                THEN 'Post-feature'
        END AS cohort

    FROM user_installs ui
    CROSS JOIN params p

    WHERE
        (
            ui.install_date + INTERVAL '29 days' < p.launch_date
        )
        OR
        (
            ui.install_date >= p.launch_date
            AND ui.install_date + INTERVAL '29 days' <= p.data_end_date
        )
),

user_max_level AS (
    SELECT
        c.user_id,
        c.cohort,
        MAX(COALESCE(d.level_end_day, 0)) AS max_level

    FROM cohorts c

    LEFT JOIN dice_user_level d
        ON c.user_id = d.user_id
        AND d.activity_date >= c.install_date
        AND d.activity_date < c.install_date + INTERVAL '30 days'

    GROUP BY
        c.user_id,
        c.cohort
),

milestones AS (
    SELECT 20 AS level_milestone
    UNION ALL SELECT 25
    UNION ALL SELECT 30
    UNION ALL SELECT 40
    UNION ALL SELECT 50
)

SELECT
    u.cohort,
    m.level_milestone,

    COUNT(*) AS total_users,

    SUM(
        CASE
            WHEN u.max_level >= m.level_milestone THEN 1
            ELSE 0
        END
    ) AS users_reaching_level,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN u.max_level >= m.level_milestone THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS pct_users_reaching_level

FROM user_max_level u

CROSS JOIN milestones m

GROUP BY
    u.cohort,
    m.level_milestone

ORDER BY
    m.level_milestone,
    u.cohort;


/* =========================================================
   GRAPH 2 — ENGAGEMENT AROUND LEVEL 25
   ========================================================= */

WITH params AS (
    SELECT
        DATE '2025-02-18' AS launch_date,
        MAX(activity_date) AS data_end_date
    FROM dice_user_level
),

user_installs AS (
    SELECT
        user_id,
        MIN(install_date) AS install_date
    FROM marketing_user_level
    GROUP BY user_id
),

base_users AS (
    SELECT
        ui.user_id,
        ui.install_date,

        CASE
            WHEN ui.install_date < p.launch_date
                THEN 'Pre-feature'
            WHEN ui.install_date >= p.launch_date
                THEN 'Post-feature'
        END AS cohort

    FROM user_installs ui
    CROSS JOIN params p
),

level_25_users AS (
    SELECT
        b.user_id,
        b.install_date,
        b.cohort,
        MIN(d.activity_date) AS level_25_date

    FROM base_users b

    INNER JOIN dice_user_level d
        ON b.user_id = d.user_id
        AND d.activity_date >= b.install_date
        AND d.level_end_day >= 25

    GROUP BY
        b.user_id,
        b.install_date,
        b.cohort
),

eligible_users AS (
    SELECT
        u.*

    FROM level_25_users u
    CROSS JOIN params p

    WHERE

        -- Full 7 days before Level 25
        u.level_25_date >= u.install_date + INTERVAL '7 days'

        -- Full 7 days after Level 25
        AND u.level_25_date + INTERVAL '7 days' <= p.data_end_date

        -- For pre-feature users, the entire observation window
        -- must occur before the feature launch
        AND (
            u.cohort = 'Post-feature'
            OR
            u.level_25_date + INTERVAL '7 days' < p.launch_date
        )
),

period_metrics AS (

    /* -------------------------
       BEFORE LEVEL 25
       ------------------------- */

    SELECT
        u.cohort,
        'Before Level 25' AS period,

        SUM(d.rolls_count) AS total_rolls,
        COUNT(*) AS active_user_days

    FROM eligible_users u

    INNER JOIN dice_user_level d
        ON u.user_id = d.user_id
        AND d.activity_date >= u.level_25_date - INTERVAL '7 days'
        AND d.activity_date < u.level_25_date

    GROUP BY
        u.cohort

    UNION ALL

    /* -------------------------
       LEVEL 25 DAY
       ------------------------- */

    SELECT
        u.cohort,
        'Level 25 day' AS period,

        SUM(d.rolls_count) AS total_rolls,
        COUNT(*) AS active_user_days

    FROM eligible_users u

    INNER JOIN dice_user_level d
        ON u.user_id = d.user_id
        AND d.activity_date = u.level_25_date

    GROUP BY
        u.cohort

    UNION ALL

    /* -------------------------
       AFTER LEVEL 25
       ------------------------- */

    SELECT
        u.cohort,
        'After Level 25' AS period,

        SUM(d.rolls_count) AS total_rolls,
        COUNT(*) AS active_user_days

    FROM eligible_users u

    INNER JOIN dice_user_level d
        ON u.user_id = d.user_id
        AND d.activity_date > u.level_25_date
        AND d.activity_date <= u.level_25_date + INTERVAL '7 days'

    GROUP BY
        u.cohort
)

SELECT
    cohort,
    period,

    ROUND(
        1.0 * total_rolls / NULLIF(active_user_days, 0),
        2
    ) AS avg_rolls_per_active_day

FROM period_metrics

ORDER BY
    CASE period
        WHEN 'Before Level 25' THEN 1
        WHEN 'Level 25 day' THEN 2
        WHEN 'After Level 25' THEN 3
    END,
    cohort;

/* =========================================================
   GRAPH 3 — NON-PAYING TO PAYING CONVERSION
   ========================================================= */
   WITH params AS (
    SELECT
        DATE '2025-02-18' AS launch_date,
        MAX(activity_date) AS data_end_date
    FROM marketing_user_level
),

user_installs AS (
    SELECT
        user_id,
        MIN(install_date) AS install_date
    FROM marketing_user_level
    GROUP BY user_id
),

base_users AS (
    SELECT
        ui.user_id,
        ui.install_date,

        CASE
            WHEN ui.install_date < p.launch_date
                THEN 'Pre-feature'
            ELSE 'Post-feature'
        END AS cohort

    FROM user_installs ui
    CROSS JOIN params p
),

level_25_users AS (
    SELECT
        b.user_id,
        b.cohort,
        MIN(d.activity_date) AS level_25_date

    FROM base_users b

    INNER JOIN dice_user_level d
        ON b.user_id = d.user_id
        AND d.activity_date >= b.install_date
        AND d.level_end_day >= 25

    GROUP BY
        b.user_id,
        b.cohort
),

eligible_users AS (
    SELECT
        u.*

    FROM level_25_users u
    CROSS JOIN params p

    WHERE

        -- Full 30-day follow-up after Level 25
        u.level_25_date + INTERVAL '30 days' <= p.data_end_date

        -- For pre-feature users, the entire 30-day
        -- post-Level-25 window must be before launch
        AND (
            u.cohort = 'Post-feature'
            OR
            u.level_25_date + INTERVAL '30 days' < p.launch_date
        )
),

user_revenue AS (
    SELECT
        u.user_id,
        u.cohort,
        u.level_25_date,

        /* Revenue before Level 25 */
        COALESCE(
            SUM(
                CASE
                    WHEN m.activity_date < u.level_25_date
                        THEN m.Revenue
                    ELSE 0
                END
            ),
            0
        ) AS revenue_before_25,

        /* Revenue after Level 25 */
        COALESCE(
            SUM(
                CASE
                    WHEN m.activity_date > u.level_25_date
                     AND m.activity_date <=
                         u.level_25_date + INTERVAL '30 days'
                        THEN m.Revenue
                    ELSE 0
                END
            ),
            0
        ) AS revenue_after_25

    FROM eligible_users u

    LEFT JOIN marketing_user_level m
        ON u.user_id = m.user_id

    GROUP BY
        u.user_id,
        u.cohort,
        u.level_25_date
),

eligible_non_payers AS (
    SELECT
        user_id,
        cohort,

        CASE
            WHEN revenue_after_25 > 0
                THEN 1
            ELSE 0
        END AS converted_to_payer

    FROM user_revenue

    WHERE revenue_before_25 = 0
)

SELECT
    cohort,

    COUNT(*) AS non_paying_users_before_25,

    SUM(converted_to_payer) AS converted_to_paying,

    COUNT(*) - SUM(converted_to_payer) AS stayed_non_paying,

    ROUND(
        100.0 *
        SUM(converted_to_payer) / COUNT(*),
        2
    ) AS converted_pct,

    ROUND(
        100.0 *
        (COUNT(*) - SUM(converted_to_payer)) / COUNT(*),
        2
    ) AS stayed_non_paying_pct

FROM eligible_non_payers

GROUP BY
    cohort

ORDER BY
    cohort;