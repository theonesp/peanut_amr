WITH RankedMicrobiologyEvents AS (
  SELECT
    hadm_id,
    org_name,
    ab_name,
    interpretation,
    charttime,
    storetime,
    subject_id,
    spec_type_desc,
    microevent_id,
    ROW_NUMBER() OVER (
      PARTITION BY hadm_id, org_name, ab_name
      ORDER BY
        CASE WHEN interpretation = 'I' THEN 'S' ELSE interpretation END, -- Cambiar 'I' a 'S'
        charttime ASC -- Ordenar de forma ascendente para obtener el más antiguo primero
    ) AS RowNum
  FROM
    `physionet-data.mimiciv_hosp.microbiologyevents`
  WHERE
   interpretation IN ('R', 'S', 'I') -- Incluyendo 'I' para luego convertirlo a 'S'
    AND charttime IS NOT NULL -- Excluir NaT (Not a Time)
    AND interpretation != 'P' -- Excluir 'P'
     AND hadm_id IS NOT NULL
)
, FilteredMicrobiologyEvents AS (
  SELECT
    hadm_id,
    org_name,
    ab_name,
    subject_id,
    microevent_id,
    CASE WHEN interpretation = 'I' THEN 'S' ELSE interpretation END AS interpretation,
    charttime,
    storetime,
    spec_type_desc
  FROM RankedMicrobiologyEvents
  WHERE RowNum = 1 
)
  SELECT
    me.hadm_id,
    me.org_name,
    me.ab_name,
    me.charttime,
    me.interpretation,
    me.spec_type_desc,
    me.subject_id,
    me.microevent_id,
    me.storetime
  FROM
    FilteredMicrobiologyEvents me;