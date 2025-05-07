SELECT
  a.emp_id,
  SUM(
    TIMESTAMPDIFF(
      HOUR,
      STR_TO_DATE(a.`timestamp`, '%Y-%m-%d %H:%i:%s'),
      (
        -- find the very next timestamp **on the same date**
        SELECT MIN( STR_TO_DATE(b.`timestamp`, '%Y-%m-%d %H:%i:%s') )
        FROM attendance AS b
        WHERE
          b.emp_id = a.emp_id
          AND DATE( STR_TO_DATE(b.`timestamp`, '%Y-%m-%d %H:%i:%s') )
              = DATE( STR_TO_DATE(a.`timestamp`, '%Y-%m-%d %H:%i:%s') )
          AND STR_TO_DATE(b.`timestamp`, '%Y-%m-%d %H:%i:%s')
              > STR_TO_DATE(a.`timestamp`, '%Y-%m-%d %H:%i:%s')
      )
    )
  ) AS weekend_hours
FROM attendance AS a
WHERE DAYOFWEEK( STR_TO_DATE(a.`timestamp`, '%Y-%m-%d %H:%i:%s') ) IN (1,7)
GROUP BY a.emp_id
ORDER BY weekend_hours DESC;
