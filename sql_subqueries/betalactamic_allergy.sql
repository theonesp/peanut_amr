WITH hadm_ids AS (
    SELECT 
        hadm_id,
        subject_id
    FROM 
        `peanutproject-2024.stay_id_selection_peanut.stay_id_selection`
),
radiology_matches AS (
    SELECT
        r.hadm_id
    FROM
        `physionet-data.mimiciv_note.radiology` r
    WHERE
        LOWER(r.text) LIKE '%betalactamic%'
        OR LOWER(r.text) LIKE '%beta-lactamic%'
        OR LOWER(r.text) LIKE '%beta lactamic%'
        OR LOWER(r.text) LIKE '%beta-lactam%'
        OR LOWER(r.text) LIKE '%betalactam%'
        OR LOWER(r.text) LIKE '%beta lactam%'
        OR LOWER(r.text) LIKE '%beta-lactame%'
        OR LOWER(r.text) LIKE '%beta-lactm%'
        OR LOWER(r.text) LIKE '%betalactm%'
        OR LOWER(r.text) LIKE '%betalactaic%'
        OR LOWER(r.text) LIKE '%betalactmaic%'
        OR LOWER(r.text) LIKE '%betalactmi%'
        OR LOWER(r.text) LIKE '%betalctam%'
        OR LOWER(r.text) LIKE '%betalactomic%'
        OR LOWER(r.text) LIKE '%betalactimic%'
        OR LOWER(r.text) LIKE '%betalactaem%'
        OR LOWER(r.text) LIKE '%betalactemic%'
        OR LOWER(r.text) LIKE '%betalactamico%'
        OR LOWER(r.text) LIKE '%betalactmicos%'
        OR LOWER(r.text) LIKE '%beta-lactamicos%'
        OR LOWER(r.text) LIKE '%betalactemico%'
        OR LOWER(r.text) LIKE '%betalactemicos%'
        OR LOWER(r.text) LIKE '%betalactmaico%'
        OR LOWER(r.text) LIKE '%betalctamic%'
        OR LOWER(r.text) LIKE '%betalactomi%'
        OR LOWER(r.text) LIKE '%betalctamico%'
        OR LOWER(r.text) LIKE '%betalactai%'
        OR LOWER(r.text) LIKE '%betalactmac%'
        OR LOWER(r.text) LIKE '%betalactimac%'
        OR LOWER(r.text) LIKE '%betalactmc%'
),
discharge_matches AS (
    SELECT
        d.hadm_id
    FROM
        `physionet-data.mimiciv_note.discharge` d
    WHERE
        LOWER(d.text) LIKE '%betalactamic%'
        OR LOWER(d.text) LIKE '%beta-lactamic%'
        OR LOWER(d.text) LIKE '%beta lactamic%'
        OR LOWER(d.text) LIKE '%beta-lactam%'
        OR LOWER(d.text) LIKE '%betalactam%'
        OR LOWER(d.text) LIKE '%beta lactam%'
        OR LOWER(d.text) LIKE '%beta-lactame%'
        OR LOWER(d.text) LIKE '%beta-lactm%'
        OR LOWER(d.text) LIKE '%betalactm%'
        OR LOWER(d.text) LIKE '%betalactaic%'
        OR LOWER(d.text) LIKE '%betalactmaic%'
        OR LOWER(d.text) LIKE '%betalactmi%'
        OR LOWER(d.text) LIKE '%betalctam%'
        OR LOWER(d.text) LIKE '%betalactomic%'
        OR LOWER(d.text) LIKE '%betalactimic%'
        OR LOWER(d.text) LIKE '%betalactaem%'
        OR LOWER(d.text) LIKE '%betalactemic%'
        OR LOWER(d.text) LIKE '%betalactamico%'
        OR LOWER(d.text) LIKE '%betalactmicos%'
        OR LOWER(d.text) LIKE '%beta-lactamicos%'
        OR LOWER(d.text) LIKE '%betalactemico%'
        OR LOWER(d.text) LIKE '%betalactemicos%'
        OR LOWER(d.text) LIKE '%betalactmaico%'
        OR LOWER(d.text) LIKE '%betalctamic%'
        OR LOWER(d.text) LIKE '%betalactomi%'
        OR LOWER(d.text) LIKE '%betalctamico%'
        OR LOWER(d.text) LIKE '%betalactai%'
        OR LOWER(d.text) LIKE '%betalactmac%'
        OR LOWER(d.text) LIKE '%betalactimac%'
        OR LOWER(d.text) LIKE '%betalactmc%'
)
SELECT
    h.hadm_id,
    h.subject_id,
    CASE
        WHEN rm.hadm_id IS NOT NULL OR dm.hadm_id IS NOT NULL THEN 1
        ELSE 0
    END AS betalactamic_allergy
FROM
    hadm_ids h
LEFT JOIN
    radiology_matches rm ON h.hadm_id = rm.hadm_id
LEFT JOIN
    discharge_matches dm ON h.hadm_id = dm.hadm_id;
