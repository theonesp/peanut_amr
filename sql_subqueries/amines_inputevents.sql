-- Select the data of stay_id (ICU stays) with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
-- Select the  amines administration previous cultive request present in inputevents table
WITH PreviousAmines AS (
  -- Subquery to get the closest previous sofa record by stay_id
  SELECT
    s.itemid,
    s.starttime,
    md.charttime as cultive_charttime,
    s.stay_id,
    s.amount,
    s.rate,

    ROW_NUMBER() OVER (PARTITION BY s.stay_id, md.charttime ORDER BY s.starttime DESC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
  
  `physionet-data.mimiciv_icu.inputevents` s
    
  ON
    s.stay_id = md.stay_id
  WHERE 
  ABS(DATE_DIFF(s.starttime,md.charttime, HOUR)) <= 6 -- time window 
)

-- Final query to select the closest previous amines registration by stay_id
SELECT *
-- COUNT(DISTINCT ps.stay_id) AS unique_stay_count
FROM
  PreviousAmines ps
WHERE
  ps.stay_id IS NOT NULL 
  AND ps.RowNum = 1
 AND ps.itemid IN (221662 , 221289, 221653 ,  221906, 221749, 222315) 
 --221662 --DOPAMINE, 221289 -- epinephrine, 221653  --DOBUTAMINE,  221906 -- norepinephrine, 221749 -- phenylephrine, 222315 -- vasopressin