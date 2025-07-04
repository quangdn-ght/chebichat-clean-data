-- Quick Test Queries for Dictionary Data
-- Run these queries to verify and explore your dictionary data

-- ===========================================================================
-- BASIC DATA EXPLORATION
-- ===========================================================================

-- 1. Count total entries
SELECT COUNT(*) as total_entries FROM dictionary;

-- 2. Get first 10 entries alphabetically
SELECT chinese, pinyin, type, meaning_vi 
FROM dictionary 
ORDER BY chinese 
LIMIT 10;

-- 3. Distribution by word type
SELECT type, COUNT(*) as count, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dictionary), 2) as percentage
FROM dictionary 
GROUP BY type 
ORDER BY count DESC;

-- 4. Sample from each word type
SELECT DISTINCT ON (type) 
  type, chinese, pinyin, meaning_vi
FROM dictionary 
ORDER BY type, chinese;

-- ===========================================================================
-- SEARCH EXAMPLES
-- ===========================================================================

-- 5. Find specific word
SELECT * FROM dictionary WHERE chinese = '爱';

-- 6. Search by pinyin pattern
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE pinyin ILIKE '%ai%' 
ORDER BY chinese 
LIMIT 5;

-- 7. Search Vietnamese meaning
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE meaning_vi ILIKE '%yêu%' 
LIMIT 5;

-- 8. Search English meaning
SELECT chinese, pinyin, meaning_en 
FROM dictionary 
WHERE meaning_en ILIKE '%love%' 
LIMIT 5;

-- 9. Find common words (short Chinese characters)
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE LENGTH(chinese) = 1 
ORDER BY chinese 
LIMIT 10;

-- 10. Find compound words (longer Chinese)
SELECT chinese, pinyin, meaning_vi, LENGTH(chinese) as char_length
FROM dictionary 
WHERE LENGTH(chinese) > 2 
ORDER BY LENGTH(chinese) DESC, chinese 
LIMIT 10;

-- ===========================================================================
-- DATA QUALITY CHECKS
-- ===========================================================================

-- 11. Check data completeness
SELECT 
  COUNT(*) as total,
  COUNT(CASE WHEN pinyin IS NOT NULL AND pinyin != '' THEN 1 END) as has_pinyin,
  COUNT(CASE WHEN meaning_vi IS NOT NULL AND meaning_vi != '' THEN 1 END) as has_meaning_vi,
  COUNT(CASE WHEN meaning_en IS NOT NULL AND meaning_en != '' THEN 1 END) as has_meaning_en,
  COUNT(CASE WHEN example_cn IS NOT NULL AND example_cn != '' THEN 1 END) as has_example_cn,
  COUNT(CASE WHEN grammar IS NOT NULL AND grammar != '' THEN 1 END) as has_grammar
FROM dictionary;

-- 12. Find entries with comprehensive data (all fields filled)
SELECT chinese, pinyin, meaning_vi, LENGTH(grammar) as grammar_length
FROM dictionary 
WHERE pinyin IS NOT NULL AND pinyin != ''
  AND meaning_vi IS NOT NULL AND meaning_vi != ''
  AND meaning_en IS NOT NULL AND meaning_en != ''
  AND example_cn IS NOT NULL AND example_cn != ''
  AND example_vi IS NOT NULL AND example_vi != ''
  AND example_en IS NOT NULL AND example_en != ''
  AND grammar IS NOT NULL AND grammar != ''
ORDER BY grammar_length DESC
LIMIT 5;

-- 13. Recent entries
SELECT chinese, pinyin, meaning_vi, created_at
FROM dictionary 
ORDER BY created_at DESC 
LIMIT 10;

-- ===========================================================================
-- USEFUL STATISTICAL QUERIES
-- ===========================================================================

-- 14. Average lengths
SELECT 
  AVG(LENGTH(chinese)) as avg_chinese_length,
  AVG(LENGTH(pinyin)) as avg_pinyin_length,
  AVG(LENGTH(meaning_vi)) as avg_meaning_vi_length,
  AVG(LENGTH(meaning_en)) as avg_meaning_en_length
FROM dictionary;

-- 15. Longest entries in each field
SELECT 
  'chinese' as field, chinese as content, LENGTH(chinese) as length
FROM dictionary 
ORDER BY LENGTH(chinese) DESC 
LIMIT 3

UNION ALL

SELECT 
  'pinyin' as field, pinyin as content, LENGTH(pinyin) as length
FROM dictionary 
ORDER BY LENGTH(pinyin) DESC 
LIMIT 3

UNION ALL

SELECT 
  'meaning_vi' as field, meaning_vi as content, LENGTH(meaning_vi) as length
FROM dictionary 
ORDER BY LENGTH(meaning_vi) DESC 
LIMIT 3

ORDER BY field, length DESC;

-- ===========================================================================
-- RANDOM SAMPLES FOR TESTING
-- ===========================================================================

-- 16. Random sample
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
ORDER BY RANDOM() 
LIMIT 10;

-- 17. Common characters appearing in multiple words
SELECT 
  SUBSTRING(chinese, 1, 1) as first_char,
  COUNT(*) as word_count,
  STRING_AGG(chinese, ', ' ORDER BY chinese) as examples
FROM dictionary 
WHERE LENGTH(chinese) > 1
GROUP BY SUBSTRING(chinese, 1, 1)
HAVING COUNT(*) > 5
ORDER BY word_count DESC
LIMIT 10;
