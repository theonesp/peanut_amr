-- Select the data of hadm_id with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
-- Select the  amines administration previous cultive request present in inputevents table

WITH PreviousAmines AS (
  -- Subquery to get the closest previous amines administration by hadm_id
  SELECT
    s.*,
    md.charttime AS cultive_charttime,
    ROW_NUMBER() OVER (PARTITION BY md.stay_id, md.charttime ORDER BY md.charttime - s.charttime ASC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_hosp.emar` s
  ON
    s.hadm_id = md.hadm_id
  WHERE
    (
      LOWER(s.medication) LIKE '%dobutamine%' OR
      LOWER(s.medication) LIKE '%dobutrex%' OR
      LOWER(s.medication) LIKE '%norepinephrine%' OR
      LOWER(s.medication) LIKE '%levophed%' OR
      LOWER(s.medication) LIKE '%epinephrine%' OR
      LOWER(s.medication) LIKE '%phenylephrine%'
    )
    AND ABS(DATE_DIFF(s.charttime,md.charttime, HOUR)) <= 6
)

-- Final query to select the closest previous amines administration by stay_id
SELECT *
FROM
  PreviousAmines ps
WHERE
  ps.RowNum = 1;