-- Example queries and usage patterns for the optimized Chinese text learning schema

-- 1. Insert a batch processing record
INSERT INTO processing_batches (
  total_items, 
  successful_items, 
  failed_items, 
  status,
  summary
) VALUES (
  241,
  241,
  0,
  'completed',
  '{
    "totalWords": 6560,
    "hskDistribution": {
      "hsk1": 424,
      "hsk2": 293,
      "hsk3": 38,
      "hsk4": 165,
      "hsk5": 17,
      "hsk6": 9,
      "other": 5614
    },
    "categories": {
      "life": 241
    },
    "sources": {
      "999 letters to yourself": 241
    },
    "averageLength": 73,
    "languageCoverage": {
      "hasVietnamese": 241,
      "hasPinyin": 241
    },
    "hskPercentages": {
      "hsk1": "6.5",
      "hsk2": "4.5",
      "hsk3": "0.6",
      "hsk4": "2.5",
      "hsk5": "0.3",
      "hsk6": "0.1",
      "other": "85.6"
    }
  }'::jsonb
);

-- 2. Example: Insert a complete letter using the function
SELECT insert_complete_letter(
  p_original := '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多',
  p_batch_id := (SELECT id FROM processing_batches ORDER BY created_at DESC LIMIT 1),
  p_pinyin := 'bié rén zài áo yè de shí hòu ， nǐ zài shuì jiào ； bié rén yǐ jīng qǐ chuáng ， nǐ hái zài zhēng zhá zài duō shuì jǐ fēn zhōng 。 nǐ yǒu hěn duō xiǎng fǎ ， dàn nǎo dài rè le jiù guò le ， bié rén què yí jiàn shì jiān chí dào dǐ 。 nǐ lián yí běn shū dōu yào kàn hěn jiǔ ， gāi gōng zuò de shí hòu jiù shuā qǐ shǒu jī ， kěn dìng yě bù néng zǎo chén qǐ lái bèi dān cí ， wǎn shàng jiā bān dào shēn yè 。 hěn duō shí hòu bù shì nǐ píng fán ， lù lù wú wéi ， ér shì nǐ méi yǒu bié rén fù chū dé duō',
  p_vietnamese := 'Khi người khác đang thức khuya, bạn lại đi ngủ; khi người khác đã thức dậy, bạn vẫn cố gắng nán lại thêm vài phút. Bạn có rất nhiều ý tưởng, nhưng chỉ trong chốc lát nhiệt huyết qua đi, người khác lại kiên trì đến cùng với một việc. Bạn đọc một cuốn sách cũng mất rất nhiều thời gian, khi cần làm việc thì lại lướt điện thoại, chắc chắn cũng không thể dậy sớm để học từ vựng, hay làm thêm đến khuya. Đôi khi, không phải bạn tầm thường hay vô dụng, mà chỉ đơn giản là bạn không nỗ lực nhiều như người khác.',
  p_category_name := 'life',
  p_source_name := '999 letters to yourself',
  p_words := '{
    "hsk1": ["时候", "睡觉", "看", "工作"],
    "hsk2": ["别人", "已经", "还", "但", "就", "过", "早晨", "晚上", "到", "得"],
    "hsk3": ["该", "手机", "加班", "平凡", "而是"],
    "hsk4": ["却", "坚持到底", "连", "肯定", "深夜", "付出"],
    "hsk5": ["熬夜", "挣扎"],
    "hsk6": ["碌碌无为"],
    "other": ["起床", "再", "多", "睡", "几分钟", "很多", "想法", "脑袋", "热", "一件", "事", "本书", "要", "久", "刷起", "不能", "起来", "背单词", "不是", "没有"]
  }'::jsonb,
  p_vocabulary := '{
    "别人": 4,
    "熬夜": 1,
    "时候": 3,
    "睡觉": 1,
    "已经": 1,
    "起床": 1,
    "还": 1,
    "挣扎": 1,
    "再": 1,
    "多": 2,
    "睡": 1,
    "几分钟": 1,
    "很多": 2,
    "想法": 1,
    "但": 1,
    "脑袋": 1,
    "热": 1,
    "就": 2,
    "过": 1,
    "却": 1,
    "一件": 1,
    "事": 1,
    "坚持到底": 1,
    "连": 1,
    "本书": 1,
    "要": 1,
    "看": 1,
    "久": 1,
    "该": 1,
    "工作": 1,
    "刷起": 1,
    "手机": 1,
    "肯定": 1,
    "不能": 1,
    "早晨": 1,
    "起来": 1,
    "背单词": 1,
    "晚上": 1,
    "加班": 1,
    "到": 1,
    "深夜": 1,
    "不是": 1,
    "平凡": 1,
    "碌碌无为": 1,
    "而是": 1,
    "没有": 1,
    "付出": 1,
    "得": 1
  }'::jsonb,
  p_text_stats := '{
    "characterCount": 130,
    "wordCount": 56,
    "uniqueWordCount": 48,
    "averageWordLength": 1.7678571428571428
  }'::jsonb
);

-- USEFUL QUERIES FOR THE APPLICATION

-- 1. Get all letters with difficulty analysis (most common query)
SELECT 
  l.id,
  l.original,
  l.pinyin,
  l.vietnamese,
  c.name as category,
  s.name as source,
  l.difficulty_score,
  l.beginner_friendly_percentage,
  l.total_hsk_words,
  l.character_count
FROM letters_difficulty_analysis l
ORDER BY l.difficulty_score ASC, l.beginner_friendly_percentage DESC
LIMIT 20;

-- 2. Search letters by text content (full-text search)
SELECT 
  l.id,
  l.original,
  l.vietnamese,
  l.difficulty_score,
  ts_rank(to_tsvector('simple', l.original), plainto_tsquery('simple', '工作 时候')) as rank
FROM letters_difficulty_analysis l
WHERE to_tsvector('simple', l.original) @@ plainto_tsquery('simple', '工作 时候')
ORDER BY rank DESC;

-- 3. Find letters suitable for beginners (high HSK 1-3 percentage)
SELECT 
  l.id,
  l.original,
  l.vietnamese,
  l.beginner_friendly_percentage,
  l.hsk1_percentage,
  l.hsk2_percentage,
  l.hsk3_percentage
FROM letters_difficulty_analysis l
WHERE l.beginner_friendly_percentage >= 50
  AND l.character_count BETWEEN 50 AND 150
ORDER BY l.beginner_friendly_percentage DESC;

-- 4. Get HSK word distribution for a specific letter
SELECT 
  hsk_level,
  COUNT(*) as word_count,
  array_agg(word ORDER BY word) as words
FROM letter_words
WHERE letter_id = 'your-letter-id-here'
GROUP BY hsk_level
ORDER BY hsk_level;

-- 5. Find most common vocabulary across all letters
SELECT 
  vf.word,
  COUNT(DISTINCT vf.letter_id) as letter_count,
  SUM(vf.frequency) as total_frequency,
  ROUND(AVG(vf.frequency), 2) as avg_frequency_per_letter
FROM vocabulary_frequency vf
GROUP BY vf.word
HAVING COUNT(DISTINCT vf.letter_id) >= 5
ORDER BY letter_count DESC, total_frequency DESC
LIMIT 50;

-- 6. Get letters by category with statistics
SELECT 
  c.name as category,
  COUNT(l.id) as letter_count,
  ROUND(AVG(l.difficulty_score), 2) as avg_difficulty,
  ROUND(AVG(l.character_count), 0) as avg_length,
  ROUND(AVG(l.beginner_friendly_percentage), 2) as avg_beginner_friendly
FROM categories c
JOIN letters l ON c.id = l.category_id
WHERE l.processed = true
GROUP BY c.id, c.name
ORDER BY letter_count DESC;

-- 7. Find similar letters by HSK level distribution
WITH target_letter AS (
  SELECT hsk1_percentage, hsk2_percentage, hsk3_percentage, 
         hsk4_percentage, hsk5_percentage, hsk6_percentage
  FROM letters 
  WHERE id = 'your-target-letter-id'
)
SELECT 
  l.id,
  l.original,
  l.vietnamese,
  -- Calculate similarity score based on HSK percentages
  (1 - (
    ABS(l.hsk1_percentage - t.hsk1_percentage) +
    ABS(l.hsk2_percentage - t.hsk2_percentage) +
    ABS(l.hsk3_percentage - t.hsk3_percentage) +
    ABS(l.hsk4_percentage - t.hsk4_percentage) +
    ABS(l.hsk5_percentage - t.hsk5_percentage) +
    ABS(l.hsk6_percentage - t.hsk6_percentage)
  ) / 600) as similarity_score
FROM letters l
CROSS JOIN target_letter t
WHERE l.id != 'your-target-letter-id'
  AND l.processed = true
ORDER BY similarity_score DESC
LIMIT 10;

-- 8. Get processing batch summary
SELECT 
  pb.id,
  pb.processed_at,
  pb.total_items,
  pb.successful_items,
  pb.failed_items,
  pb.status,
  pb.summary->'hskDistribution' as hsk_distribution,
  pb.summary->'hskPercentages' as hsk_percentages
FROM processing_batches pb
ORDER BY pb.processed_at DESC;

-- 9. Find letters containing specific HSK words
SELECT DISTINCT
  l.id,
  l.original,
  l.vietnamese,
  array_agg(lw.word) as matching_words
FROM letters l
JOIN letter_words lw ON l.id = lw.letter_id
WHERE lw.word = ANY(ARRAY['工作', '时候', '别人'])
  AND lw.hsk_level IN ('hsk1', 'hsk2', 'hsk3')
GROUP BY l.id, l.original, l.vietnamese
ORDER BY array_length(array_agg(lw.word), 1) DESC;

-- 10. Get vocabulary progression (words that appear in letters of increasing difficulty)
WITH letter_difficulty AS (
  SELECT 
    id,
    difficulty_score,
    CASE 
      WHEN difficulty_score <= 2 THEN 'easy'
      WHEN difficulty_score <= 4 THEN 'medium'
      ELSE 'hard'
    END as difficulty_level
  FROM letters_difficulty_analysis
)
SELECT 
  lw.word,
  lw.hsk_level,
  COUNT(DISTINCT CASE WHEN ld.difficulty_level = 'easy' THEN l.id END) as easy_count,
  COUNT(DISTINCT CASE WHEN ld.difficulty_level = 'medium' THEN l.id END) as medium_count,
  COUNT(DISTINCT CASE WHEN ld.difficulty_level = 'hard' THEN l.id END) as hard_count
FROM letter_words lw
JOIN letters l ON lw.letter_id = l.id
JOIN letter_difficulty ld ON l.id = ld.id
WHERE lw.hsk_level IN ('hsk1', 'hsk2', 'hsk3')
GROUP BY lw.word, lw.hsk_level
HAVING COUNT(DISTINCT l.id) >= 3
ORDER BY lw.hsk_level, COUNT(DISTINCT l.id) DESC;

-- PERFORMANCE OPTIMIZATION QUERIES

-- 1. Check index usage
SELECT 
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation
FROM pg_stats 
WHERE schemaname = 'public' 
  AND tablename IN ('letters', 'letter_words', 'vocabulary_frequency')
ORDER BY tablename, attname;

-- 2. Monitor query performance
EXPLAIN (ANALYZE, BUFFERS) 
SELECT l.id, l.original, l.difficulty_score
FROM letters_difficulty_analysis l
WHERE l.beginner_friendly_percentage >= 50
ORDER BY l.difficulty_score;

-- 3. Check table sizes
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
