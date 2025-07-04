-- Test Queries for Dictionary Table
-- These queries demonstrate various ways to select and search dictionary data

-- =============================================================================
-- BASIC SELECT QUERIES
-- =============================================================================

-- 1. Get all dictionary entries (limit for performance)
SELECT chinese, pinyin, type, meaning_vi, meaning_en 
FROM dictionary 
ORDER BY chinese 
LIMIT 10;

-- 2. Count total entries
SELECT COUNT(*) as total_entries FROM dictionary;

-- 3. Get entries by specific word type
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE type = 'danh từ' 
LIMIT 10;

-- 4. Get a specific word by Chinese characters (primary key lookup - fastest)
SELECT * FROM dictionary WHERE chinese = '爱';

-- 5. Get multiple specific words
SELECT chinese, pinyin, meaning_vi, meaning_en 
FROM dictionary 
WHERE chinese IN ('爱', '你好', '谢谢', '再见') 
ORDER BY chinese;

-- =============================================================================
-- SEARCH QUERIES
-- =============================================================================

-- 6. Search by pinyin (partial match)
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE pinyin ILIKE '%ai%' 
ORDER BY chinese 
LIMIT 10;

-- 7. Search Vietnamese meaning (case-insensitive)
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE meaning_vi ILIKE '%yêu%' 
ORDER BY chinese 
LIMIT 5;

-- 8. Search English meaning
SELECT chinese, pinyin, meaning_en 
FROM dictionary 
WHERE meaning_en ILIKE '%love%' 
ORDER BY chinese 
LIMIT 5;

-- 9. Full-text search using search_vector
SELECT chinese, pinyin, meaning_vi, meaning_en,
       ts_rank(search_vector, plainto_tsquery('simple', 'love')) as rank
FROM dictionary 
WHERE search_vector @@ plainto_tsquery('simple', 'love')
ORDER BY rank DESC 
LIMIT 10;

-- =============================================================================
-- ADVANCED QUERIES
-- =============================================================================

-- 10. Get statistics by word type
SELECT type, COUNT(*) as count, 
       AVG(LENGTH(chinese)) as avg_chinese_length,
       AVG(LENGTH(meaning_vi)) as avg_meaning_length
FROM dictionary 
GROUP BY type 
ORDER BY count DESC;

-- 11. Find words with longest Chinese characters
SELECT chinese, pinyin, meaning_vi, LENGTH(chinese) as char_length
FROM dictionary 
ORDER BY LENGTH(chinese) DESC 
LIMIT 10;

-- 12. Find words with most detailed grammar explanations
SELECT chinese, pinyin, grammar, LENGTH(grammar) as grammar_length
FROM dictionary 
WHERE grammar IS NOT NULL AND grammar != ''
ORDER BY LENGTH(grammar) DESC 
LIMIT 5;

-- 13. Search with similarity (fuzzy matching)
SELECT chinese, pinyin, meaning_vi,
       similarity(pinyin, 'ni hao') as pinyin_similarity,
       similarity(meaning_vi, 'xin chào') as meaning_similarity
FROM dictionary 
WHERE similarity(pinyin, 'ni hao') > 0.3 
   OR similarity(meaning_vi, 'xin chào') > 0.3
ORDER BY GREATEST(pinyin_similarity, meaning_similarity) DESC
LIMIT 10;

-- =============================================================================
-- CUSTOM FUNCTION QUERIES
-- =============================================================================

-- 14. Use Vietnamese search function
SELECT * FROM search_dictionary_vietnamese('yêu') LIMIT 5;

-- 15. Use Chinese search function  
SELECT * FROM search_dictionary_chinese('爱') LIMIT 5;

-- 16. Get word by Chinese using custom function
SELECT * FROM get_word_by_chinese('爱');

-- 17. Batch lookup using custom function
SELECT * FROM get_words_by_chinese_list(ARRAY['爱', '你好', '谢谢']);

-- 18. Check if word exists
SELECT word_exists('爱') as love_exists,
       word_exists('不存在的词') as nonexistent_word;

-- =============================================================================
-- COMPLEX QUERIES
-- =============================================================================

-- 19. Find words that appear in both Chinese and Vietnamese examples
SELECT chinese, pinyin, meaning_vi, example_cn, example_vi
FROM dictionary 
WHERE example_cn ILIKE '%' || chinese || '%' 
  AND example_vi IS NOT NULL 
  AND example_vi != ''
LIMIT 10;

-- 20. Get recently added entries
SELECT chinese, pinyin, meaning_vi, created_at
FROM dictionary 
ORDER BY created_at DESC 
LIMIT 10;

-- 21. Find words with comprehensive examples (all example fields filled)
SELECT chinese, pinyin, meaning_vi, example_cn, example_vi, example_en
FROM dictionary 
WHERE example_cn IS NOT NULL AND example_cn != ''
  AND example_vi IS NOT NULL AND example_vi != ''  
  AND example_en IS NOT NULL AND example_en != ''
LIMIT 10;

-- 22. Search across all text fields
SELECT chinese, pinyin, type, meaning_vi,
       CASE 
         WHEN chinese ILIKE '%爱%' THEN 'Found in Chinese'
         WHEN pinyin ILIKE '%ai%' THEN 'Found in Pinyin'  
         WHEN meaning_vi ILIKE '%yêu%' THEN 'Found in Vietnamese'
         WHEN meaning_en ILIKE '%love%' THEN 'Found in English'
         ELSE 'Other match'
       END as match_location
FROM dictionary 
WHERE chinese ILIKE '%爱%' 
   OR pinyin ILIKE '%ai%'
   OR meaning_vi ILIKE '%yêu%' 
   OR meaning_en ILIKE '%love%'
ORDER BY chinese
LIMIT 10;

-- =============================================================================
-- PERFORMANCE TESTING QUERIES
-- =============================================================================

-- 23. Primary key performance test (should be fastest)
EXPLAIN ANALYZE SELECT * FROM dictionary WHERE chinese = '爱';

-- 24. Index usage test for pinyin
EXPLAIN ANALYZE SELECT * FROM dictionary WHERE pinyin ILIKE '%ai%' LIMIT 10;

-- 25. Full-text search performance
EXPLAIN ANALYZE 
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
WHERE search_vector @@ plainto_tsquery('simple', 'love') 
LIMIT 10;

-- =============================================================================
-- USEFUL ADMINISTRATION QUERIES
-- =============================================================================

-- 26. Check table size and index usage
SELECT 
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation,
  null_frac
FROM pg_stats 
WHERE tablename = 'dictionary';

-- 27. View dictionary statistics
SELECT * FROM dictionary_stats ORDER BY count_by_type DESC;

-- 28. Check recent activity
SELECT 
  COUNT(*) as total_entries,
  MIN(created_at) as first_entry,
  MAX(created_at) as last_entry,
  MAX(updated_at) as last_update
FROM dictionary;

-- 29. Find entries missing grammar explanations
SELECT COUNT(*) as missing_grammar_count
FROM dictionary 
WHERE grammar IS NULL OR grammar = '';

-- 30. Sample diverse entries (one from each type)
SELECT DISTINCT ON (type) 
  type, chinese, pinyin, meaning_vi
FROM dictionary 
ORDER BY type, chinese;

-- =============================================================================
-- SAMPLE RANDOM DATA FOR TESTING
-- =============================================================================

-- 31. Get random sample of entries
SELECT chinese, pinyin, meaning_vi 
FROM dictionary 
ORDER BY RANDOM() 
LIMIT 10;

-- 32. Get words starting with specific characters
SELECT chinese, pinyin, meaning_vi
FROM dictionary 
WHERE chinese ~ '^[我你他她它们]'
ORDER BY chinese
LIMIT 10;

-- 33. Find compound words (more than 1 Chinese character)
SELECT chinese, pinyin, meaning_vi, LENGTH(chinese) as char_count
FROM dictionary 
WHERE LENGTH(chinese) > 1
ORDER BY LENGTH(chinese) DESC, chinese
LIMIT 15;

-- =============================================================================
-- TESTING DATA QUALITY
-- =============================================================================

-- 34. Check for potential duplicates (same pinyin, different Chinese)
SELECT pinyin, COUNT(*) as count, 
       STRING_AGG(chinese, ', ') as chinese_variations
FROM dictionary 
GROUP BY pinyin 
HAVING COUNT(*) > 1
ORDER BY count DESC
LIMIT 10;

-- 35. Find entries with unusual characters or formatting
SELECT chinese, pinyin, meaning_vi
FROM dictionary 
WHERE chinese ~ '[^\u4e00-\u9fff]'  -- Non-Chinese characters
   OR pinyin ~ '[^a-zA-Z\s]'        -- Non-alphabetic in pinyin
LIMIT 5;

-- 36. Validate data completeness
SELECT 
  COUNT(*) as total,
  COUNT(CASE WHEN pinyin IS NOT NULL AND pinyin != '' THEN 1 END) as has_pinyin,
  COUNT(CASE WHEN meaning_vi IS NOT NULL AND meaning_vi != '' THEN 1 END) as has_meaning_vi,
  COUNT(CASE WHEN meaning_en IS NOT NULL AND meaning_en != '' THEN 1 END) as has_meaning_en,
  COUNT(CASE WHEN example_cn IS NOT NULL AND example_cn != '' THEN 1 END) as has_example_cn,
  COUNT(CASE WHEN grammar IS NOT NULL AND grammar != '' THEN 1 END) as has_grammar
FROM dictionary;
