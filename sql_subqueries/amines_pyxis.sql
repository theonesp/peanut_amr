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
  -- Subquery to get the closest previous amines administration by subject_id
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
 LOWER(s.name) LIKE '%adoxa%' OR
LOWER(s.name) LIKE '%ala-tet%' OR
LOWER(s.name) LIKE '%alodox%' OR
LOWER(s.name) LIKE '%amikacin%' OR
LOWER(s.name) LIKE '%amikin%' OR
LOWER(s.name) LIKE '%amoxicill%' OR
LOWER(s.name) LIKE '%amphotericin%' OR
LOWER(s.name) LIKE '%anidulafungin%' OR
LOWER(s.name) LIKE '%ancef%' OR
LOWER(s.name) LIKE '%clavulanate%' OR
LOWER(s.name) LIKE '%ampicillin%' OR
LOWER(s.name) LIKE '%augmentin%' OR
LOWER(s.name) LIKE '%avelox%' OR
LOWER(s.name) LIKE '%avidoxy%' OR
LOWER(s.name) LIKE '%azactam%' OR
LOWER(s.name) LIKE '%azithromycin%' OR
LOWER(s.name) LIKE '%aztreonam%' OR
LOWER(s.name) LIKE '%axetil%' OR
LOWER(s.name) LIKE '%bactocill%' OR
LOWER(s.name) LIKE '%bactrim%' OR
LOWER(s.name) LIKE '%bactroban%' OR
LOWER(s.name) LIKE '%bethkis%' OR
LOWER(s.name) LIKE '%biaxin%' OR
LOWER(s.name) LIKE '%bicillin l-a%' OR
LOWER(s.name) LIKE '%cayston%' OR
LOWER(s.name) LIKE '%cefazolin%' OR
LOWER(s.name) LIKE '%cedax%' OR
LOWER(s.name) LIKE '%cefoxitin%' OR
LOWER(s.name) LIKE '%ceftazidime%' OR
LOWER(s.name) LIKE '%cefaclor%' OR
LOWER(s.name) LIKE '%cefadroxil%' OR
LOWER(s.name) LIKE '%cefdinir%' OR
LOWER(s.name) LIKE '%cefditoren%' OR
LOWER(s.name) LIKE '%cefepime%' OR
LOWER(s.name) LIKE '%cefotan%' OR
LOWER(s.name) LIKE '%cefotetan%' OR
LOWER(s.name) LIKE '%cefotaxime%' OR
LOWER(s.name) LIKE '%ceftaroline%' OR
LOWER(s.name) LIKE '%cefpodoxime%' OR
LOWER(s.name) LIKE '%cefpirome%' OR
LOWER(s.name) LIKE '%cefprozil%' OR
LOWER(s.name) LIKE '%ceftibuten%' OR
LOWER(s.name) LIKE '%ceftin%' OR
LOWER(s.name) LIKE '%ceftriaxone%' OR
LOWER(s.name) LIKE '%cefuroxime%' OR
LOWER(s.name) LIKE '%cephalexin%' OR
LOWER(s.name) LIKE '%cephalothin%' OR
LOWER(s.name) LIKE '%cephapririn%' OR
LOWER(s.name) LIKE '%chloramphenicol%' OR
LOWER(s.name) LIKE '%cipro%' OR
LOWER(s.name) LIKE '%ciprofloxacin%' OR
LOWER(s.name) LIKE '%claforan%' OR
LOWER(s.name) LIKE '%clarithromycin%' OR
LOWER(s.name) LIKE '%cleocin%' OR
LOWER(s.name) LIKE '%clindamycin%' OR
LOWER(s.name) LIKE '%cubicin%' OR
LOWER(s.name) LIKE '%dicloxacillin%' OR
LOWER(s.name) LIKE '%dirithromycin%' OR
LOWER(s.name) LIKE '%doryx%' OR
LOWER(s.name) LIKE '%doxycy%' OR
LOWER(s.name) LIKE '%duricef%' OR
LOWER(s.name) LIKE '%dynacin%' OR
LOWER(s.name) LIKE '%ery-tab%' OR
LOWER(s.name) LIKE '%eryped%' OR
LOWER(s.name) LIKE '%eryc%' OR
LOWER(s.name) LIKE '%erythrocin%' OR
LOWER(s.name) LIKE '%erythromycin%' OR
LOWER(s.name) LIKE '%factive%' OR
LOWER(s.name) LIKE '%flagyl%' OR
LOWER(s.name) LIKE '%fortaz%' OR
LOWER(s.name) LIKE '%furadantin%' OR
LOWER(s.name) LIKE '%garamycin%' OR
LOWER(s.name) LIKE '%gentamicin%' OR
LOWER(s.name) LIKE '%kanamycin%' OR
LOWER(s.name) LIKE '%keflex%' OR
LOWER(s.name) LIKE '%kefzol%' OR
LOWER(s.name) LIKE '%ketek%' OR
LOWER(s.name) LIKE '%levaquin%' OR
LOWER(s.name) LIKE '%levofloxacin%' OR
LOWER(s.name) LIKE '%lincocin%' OR
LOWER(s.name) LIKE '%linezolid%' OR
LOWER(s.name) LIKE '%macrobid%' OR
LOWER(s.name) LIKE '%macrodantin%' OR
LOWER(s.name) LIKE '%maxipime%' OR
LOWER(s.name) LIKE '%mefoxin%' OR
LOWER(s.name) LIKE '%metronidazole%' OR
LOWER(s.name) LIKE '%meropenem%' OR
LOWER(s.name) LIKE '%methicillin%' OR
LOWER(s.name) LIKE '%minocin%' OR
LOWER(s.name) LIKE '%minocycline%' OR
LOWER(s.name) LIKE '%monodox%' OR
LOWER(s.name) LIKE '%monurol%' OR
LOWER(s.name) LIKE '%morgidox%' OR
LOWER(s.name) LIKE '%moxatag%' OR
LOWER(s.name) LIKE '%moxifloxacin%' OR
LOWER(s.name) LIKE '%mupirocin%' OR
LOWER(s.name) LIKE '%myrac%' OR
LOWER(s.name) LIKE '%nafcillin%' OR
LOWER(s.name) LIKE '%neomycin%' OR
LOWER(s.name) LIKE '%nicazel doxy 30%' OR
LOWER(s.name) LIKE '%nitrofurantoin%' OR
LOWER(s.name) LIKE '%norfloxacin%' OR
LOWER(s.name) LIKE '%noroxin%' OR
LOWER(s.name) LIKE '%ocudox%' OR
LOWER(s.name) LIKE '%ofloxacin%' OR
LOWER(s.name) LIKE '%omnicef%' OR
LOWER(s.name) LIKE '%oracea'
    )
    AND ABS(DATE_DIFF(s.charttime,md.charttime, HOUR)) <= 6
)

-- Final query to select the closest previous amines administration by stay_id
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