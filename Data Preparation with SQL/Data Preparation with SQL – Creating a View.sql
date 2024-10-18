-- Calculating a Subscription’s End Date
SELECT
    purchase_id,
    student_id,
    plan_id,
    date_purchased AS date_start,
    CASE
        WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
        WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
        WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
    END AS date_end,
    date_refunded
FROM
    student_purchases;

-- Re-Calculating a Subscription’s End Date
SELECT
    purchase_id,
    student_id,
    plan_id,
    date_start,
    IF(date_refunded IS NULL, date_end, date_refunded) AS date_end
FROM
    (
        SELECT
            purchase_id,
            student_id,
            plan_id,
            date_purchased AS date_start,
            CASE
                WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
                WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
                WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
            END AS date_end,
            date_refunded
        FROM
            student_purchases
    ) a;

-- Creating Two ‘paid’ Columns and a MySQL View
DROP VIEW IF EXISTS purchases_info;
CREATE VIEW purchases_info AS
SELECT
    purchase_id,
    student_id,
    plan_id,
    date_start,
    date_end,
    CASE 
        WHEN date_end < '2021-04-01' THEN 0 
        WHEN date_start > '2021-06-30' THEN 0 
        ELSE 1 
    END AS paid_q2_2021,
    CASE 
        WHEN date_end < '2022-04-01' THEN 0 
        WHEN date_start > '2022-06-30' THEN 0 
        ELSE 1 
    END AS paid_q2_2022
FROM
    (SELECT
        purchase_id,
        student_id,
        plan_id,
        date_start,
        IF(date_refunded IS NULL, date_end, date_refunded) AS date_end
    FROM
        (
            SELECT
                purchase_id,
                student_id,
                plan_id,
                date_purchased AS date_start,
                CASE
                    WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
                    WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
                    WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
                END AS date_end,
                date_refunded
            FROM
                student_purchases
        ) AS a
    ) AS b;