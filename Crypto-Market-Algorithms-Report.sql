WITH QuarterVolumes AS (
  SELECT 
    c.algorithm,
    QUARTER(dt) AS Quarter, 
    SUM(volume) AS V
  FROM coins c
  INNER JOIN transactions t 
    ON t.coin_code = c.code
  WHERE YEAR(dt) = 2020
  GROUP BY c.algorithm, QUARTER(dt)
)

SELECT 
  Q1.algorithm,
  ROUND(Q1.V, 6) AS Q1_v,
  ROUND(Q2.V, 6) AS Q2_v,
  ROUND(Q3.V, 6) AS Q3_v,
  ROUND(Q4.V, 6) AS Q4_v
FROM QuarterVolumes Q1
LEFT JOIN QuarterVolumes Q2 ON Q1.algorithm = Q2.algorithm AND Q2.Quarter = 2
LEFT JOIN QuarterVolumes Q3 ON Q1.algorithm = Q3.algorithm AND Q3.Quarter = 3
LEFT JOIN QuarterVolumes Q4 ON Q1.algorithm = Q4.algorithm AND Q4.Quarter = 4
WHERE Q1.Quarter = 1
ORDER BY Q1.algorithm ASC;
