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
  -- Subquery to get the closest previous ab administration by subject_id
  SELECT
    s.*,
    md.charttime AS cultive_charttime,
    ROW_NUMBER() OVER (PARTITION BY md.stay_id, md.charttime ORDER BY md.charttime - s.charttime ASC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_ed.pyxis` s
  ON
    s.stay_id = md.stay_id
  WHERE
    (
    LOWER(name) LIKE '%ala-tet%' OR
    LOWER(name) LIKE '%alodox%' OR
    LOWER(name) LIKE '%amikacin%' OR
    LOWER(name) LIKE '%amikin%' OR
    LOWER(name) LIKE '%amoxicill%' OR
    LOWER(name) LIKE '%amphotericin%' OR
    LOWER(name) LIKE '%anidulafungin%' OR
    LOWER(name) LIKE '%ancef%' OR
    LOWER(name) LIKE '%clavulanate%' OR
    LOWER(name) LIKE '%ampicillin%' OR
    LOWER(name) LIKE '%augmentin%' OR
    LOWER(name) LIKE '%avelox%' OR
    LOWER(name) LIKE '%avidoxy%' OR
    LOWER(name) LIKE '%azactam%' OR
    LOWER(name) LIKE '%azithromycin%' OR
    LOWER(name) LIKE '%aztreonam%' OR
    LOWER(name) LIKE '%axetil%' OR
    LOWER(name) LIKE '%bactocill%' OR
    LOWER(name) LIKE '%bactrim%' OR
    LOWER(name) LIKE '%bactroban%' OR
    LOWER(name) LIKE '%bethkis%' OR
    LOWER(name) LIKE '%biaxin%' OR
    LOWER(name) LIKE '%bicillin l-a%' OR
    LOWER(name) LIKE '%cayston%' OR
    LOWER(name) LIKE '%cefazolin%' OR
    LOWER(name) LIKE '%cedax%' OR
    LOWER(name) LIKE '%cefoxitin%' OR
    LOWER(name) LIKE '%ceftazidime%' OR
    LOWER(name) LIKE '%cefaclor%' OR
    LOWER(name) LIKE '%cefadroxil%' OR
    LOWER(name) LIKE '%cefdinir%' OR
    LOWER(name) LIKE '%cefditoren%' OR
    LOWER(name) LIKE '%cefepime%' OR
    LOWER(name) LIKE '%cefotan%' OR
    LOWER(name) LIKE '%cefotetan%' OR
    LOWER(name) LIKE '%cefotaxime%' OR
    LOWER(name) LIKE '%ceftaroline%' OR
    LOWER(name) LIKE '%cefpodoxime%' OR
    LOWER(name) LIKE '%cefpirome%' OR
    LOWER(name) LIKE '%cefprozil%' OR
    LOWER(name) LIKE '%ceftibuten%' OR
    LOWER(name) LIKE '%ceftin%' OR
    LOWER(name) LIKE '%ceftriaxone%' OR
    LOWER(name) LIKE '%cefuroxime%' OR
    LOWER(name) LIKE '%cephalexin%' OR
    LOWER(name) LIKE '%cephalothin%' OR
    LOWER(name) LIKE '%cephapririn%' OR
    LOWER(name) LIKE '%chloramphenicol%' OR
    LOWER(name) LIKE '%cipro%' OR
    LOWER(name) LIKE '%ciprofloxacin%' OR
    LOWER(name) LIKE '%claforan%' OR
    LOWER(name) LIKE '%clarithromycin%' OR
    LOWER(name) LIKE '%cleocin%' OR
    LOWER(name) LIKE '%clindamycin%' OR
    LOWER(name) LIKE '%cubicin%' OR
    LOWER(name) LIKE '%dicloxacillin%' OR
    LOWER(name) LIKE '%dirithromycin%' OR
    LOWER(name) LIKE '%doryx%' OR
    LOWER(name) LIKE '%doxycy%' OR
    LOWER(name) LIKE '%duricef%' OR
    LOWER(name) LIKE '%dynacin%' OR
    LOWER(name) LIKE '%ery-tab%' OR
    LOWER(name) LIKE '%eryped%' OR
    LOWER(name) LIKE '%eryc%' OR
    LOWER(name) LIKE '%erythrocin%' OR
    LOWER(name) LIKE '%erythromycin%' OR
    LOWER(name) LIKE '%factive%' OR
    LOWER(name) LIKE '%flagyl%' OR
    LOWER(name) LIKE '%fortaz%' OR
    LOWER(name) LIKE '%furadantin%' OR
    LOWER(name) LIKE '%garamycin%' OR
    LOWER(name) LIKE '%gentamicin%' OR
    LOWER(name) LIKE '%kanamycin%' OR
    LOWER(name) LIKE '%keflex%' OR
    LOWER(name) LIKE '%kefzol%' OR
    LOWER(name) LIKE '%ketek%' OR
    LOWER(name) LIKE '%levaquin%' OR
    LOWER(name) LIKE '%levofloxacin%' OR
    LOWER(name) LIKE '%lincocin%' OR
    LOWER(name) LIKE '%linezolid%' OR
    LOWER(name) LIKE '%macrobid%' OR
    LOWER(name) LIKE '%macrodantin%' OR
    LOWER(name) LIKE '%maxipime%' OR
    LOWER(name) LIKE '%mefoxin%' OR
    LOWER(name) LIKE '%metronidazole%' OR
    LOWER(name) LIKE '%meropenem%' OR
    LOWER(name) LIKE '%methicillin%' OR
    LOWER(name) LIKE '%minocin%' OR
    LOWER(name) LIKE '%minocycline%' OR
    LOWER(name) LIKE '%monodox%' OR
    LOWER(name) LIKE '%monurol%' OR
    LOWER(name) LIKE '%morgidox%' OR
    LOWER(name) LIKE '%moxatag%' OR
    LOWER(name) LIKE '%moxifloxacin%' OR
    LOWER(name) LIKE '%mupirocin%' OR
    LOWER(name) LIKE '%myrac%' OR
    LOWER(name) LIKE '%nafcillin%' OR
    LOWER(name) LIKE '%neomycin%' OR
    LOWER(name) LIKE '%nicazel doxy 30%' OR
    LOWER(name) LIKE '%nitrofurantoin%' OR
    LOWER(name) LIKE '%norfloxacin%' OR
    LOWER(name) LIKE '%noroxin%' OR
    LOWER(name) LIKE '%ocudox%' OR
    LOWER(name) LIKE '%ofloxacin%' OR
    LOWER(name) LIKE '%omnicef%' OR
    LOWER(name) LIKE '%oracea'
    )
    AND s.charttime < md.charttime -- ensure starttime is before charttime
    AND DATE_DIFF(md.charttime, s.charttime, DAY) <= 90 -- time window
)

-- Final query to select the closest previous ab administration by stay_id
SELECT 
ps.subject_id,
ps.stay_id,
ps.cultive_charttime,
ps.charttime,
ps.name
FROM
  PreviousAmines ps
WHERE
  ps.RowNum = 1;