-- ============================================================
-- U.S. Sauna & Cold-Plunge Market Analysis
-- Author: Christina Hinds
-- Tools: MySQL
-- Dataset: Sauna & Cold-Plunge Venues
-- ============================================================


-- ============================================================
-- 1. Select Database
-- ============================================================

USE sauna_data;


-- ============================================================
-- 2. Explore the Dataset
-- View the structure of the venues table
-- ============================================================

DESCRIBE venues;


-- ============================================================
-- 3. Number of Venues by State
-- ============================================================

SELECT
    state,
    COUNT(*) AS number_of_venues
FROM venues
GROUP BY state
ORDER BY number_of_venues DESC;


-- ============================================================
-- 4. Number of Venues by City
-- ============================================================

SELECT
    locality,
    COUNT(*) AS number_of_venues
FROM venues
GROUP BY locality
ORDER BY number_of_venues DESC;


-- ============================================================
-- 5. Cold Plunge vs. Traditional Sauna
-- Count venues offering each service
-- ============================================================

SELECT
    'Cold Plunge' AS service,
    COUNT(*) AS number_of_venues
FROM venues
WHERE modalities LIKE '%cold_plunge%';

SELECT
    'Traditional Sauna' AS service,
    COUNT(*) AS number_of_venues
FROM venues
WHERE modalities LIKE '%traditional_sauna%';


-- ============================================================
-- 6. Review Available Modality Combinations
-- ============================================================

SELECT DISTINCT
    modalities
FROM venues
ORDER BY modalities;


-- ============================================================
-- 7. Average Drop-In Price
-- Initial analysis excluding NULL values
-- ============================================================

SELECT
    ROUND(AVG(dropIn), 2) AS average_drop_in
FROM venues
WHERE dropIn IS NOT NULL;


-- ============================================================
-- 8. Average Drop-In Price by State
-- Initial analysis
-- ============================================================

SELECT
    state,
    ROUND(AVG(dropIn), 2) AS average_drop_in
FROM venues
WHERE dropIn IS NOT NULL
GROUP BY state
ORDER BY average_drop_in DESC;


-- ============================================================
-- 9. Pricing Data Availability by State
-- Includes states with at least 5 records
-- ============================================================

SELECT
    state,
    COUNT(*) AS venues_with_price,
    ROUND(AVG(dropIn), 2) AS average_drop_in
FROM venues
WHERE dropIn IS NOT NULL
GROUP BY state
HAVING COUNT(*) >= 5
ORDER BY average_drop_in DESC;


-- ============================================================
-- 10. Investigate Missing/Blank Pricing Values
-- Check for blank strings as well as NULL values
-- ============================================================

SELECT
    name,
    state,
    dropIn,
    LENGTH(dropIn) AS value_length
FROM venues
WHERE state = 'VA';


-- ============================================================
-- 11. Cleaned Average Drop-In Price by State
-- Excludes both NULL and blank/whitespace values
-- Requires at least 5 venues with a usable price
-- ============================================================

SELECT
    state,
    COUNT(*) AS venues_with_price,
    ROUND(AVG(dropIn), 2) AS average_drop_in
FROM venues
WHERE NULLIF(TRIM(dropIn), '') IS NOT NULL
GROUP BY state
HAVING COUNT(*) >= 5
ORDER BY average_drop_in DESC;
