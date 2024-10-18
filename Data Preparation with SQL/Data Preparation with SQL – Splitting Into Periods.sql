-- I. Calculating Total Minutes Watched in Q2 2021 and Q2 2022

    -- Q2 2021
    SELECT 
        student_id,
        ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
    FROM
        student_video_watched
    WHERE
        date_watched >= '2021-04-01' AND date_watched < '2021-07-01'
    GROUP BY 
        student_id
    ORDER BY 
        student_id;

    -- Q2 2022
    SELECT 
        student_id,
        ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
    FROM
        student_video_watched
    WHERE
        date_watched >= '2022-04-01' AND date_watched < '2022-07-01'
    GROUP BY 
        student_id
    ORDER BY 
        student_id;



-- II. Creating a ‘paid’ Column

    -- Create the four data sources
    
        --Students engaged in Q2 2021 who haven’t had a paid subscription in Q2 2021
        SELECT 
            a.student_id,
            a.minutes_watched,
            IF( i.student_id IS NOT NULL, MAX(i.paid_q2_2021), 0) AS paid_in_q2 
        FROM 
            (
                SELECT 
                student_id,
                ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
            FROM
                student_video_watched
            WHERE
                date_watched >= '2021-04-01' AND date_watched < '2021-07-01'
            GROUP BY 
                student_id
            ORDER BY 
                student_id
            ) a
        LEFT JOIN purchases_info i ON a.student_id = i.student_id 
        
        GROUP BY 
                student_id
        HAVING 
            paid_in_q2 = 0; 

        -- Students engaged in Q2 2022 who haven’t had a paid subscription in Q2 2022
        SELECT 
            a.student_id,
            a.minutes_watched,
            IF( i.student_id IS NOT NULL, MAX(i.paid_q2_2022), 0) AS paid_in_q2 
        FROM 
            (
                SELECT 
                student_id,
                ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
            FROM
                student_video_watched
            WHERE
                date_watched >= '2022-04-01' AND date_watched < '2022-07-01'
            GROUP BY 
                student_id
            ORDER BY 
                student_id
            ) a
        LEFT JOIN purchases_info i ON a.student_id = i.student_id 
        
        GROUP BY 
                student_id
        HAVING 
            paid_in_q2 = 0; 

        -- Students engaged in Q2 2021 who have been paid subscribers in Q2 2021
        SELECT 
            a.student_id,
            a.minutes_watched,
            IF( i.student_id IS NOT NULL, MAX(i.paid_q2_2021), 0) AS paid_in_q2 
        FROM 
            (
                SELECT 
                student_id,
                ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
            FROM
                student_video_watched
            WHERE
                date_watched >= '2021-04-01' AND date_watched < '2021-07-01'
            GROUP BY 
                student_id
            ORDER BY 
                student_id
            ) a
        LEFT JOIN purchases_info i ON a.student_id = i.student_id 
        
        GROUP BY 
                student_id
        HAVING 
            paid_in_q2 = 1; 

        -- Students engaged in Q2 2022 who have been paid subscribers in Q2 2022
        SELECT 
            a.student_id,
            a.minutes_watched,
            IF( i.student_id IS NOT NULL, MAX(i.paid_q2_2022), 0) AS paid_in_q2 
        FROM 
            (
                SELECT 
                student_id,
                ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
            FROM
                student_video_watched
            WHERE
                date_watched >= '2022-04-01' AND date_watched < '2022-07-01'
            GROUP BY 
                student_id
            ORDER BY 
                student_id
            ) a
        LEFT JOIN purchases_info i ON a.student_id = i.student_id 
        
        GROUP BY 
                student_id
        HAVING 
            paid_in_q2 = 1; 