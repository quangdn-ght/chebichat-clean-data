-- Import script for radicals poem data from JSON
-- This script imports data from the merged_radicals.json file structure

-- Function to import radicals data from JSON structure
CREATE OR REPLACE FUNCTION import_radicals_from_json(json_data JSONB)
RETURNS TABLE (
  imported_count INTEGER,
  skipped_count INTEGER,
  error_count INTEGER
) AS $$
DECLARE
  radical_key TEXT;
  poem_desc TEXT;
  total_imported INTEGER := 0;
  total_skipped INTEGER := 0;
  total_errors INTEGER := 0;
BEGIN
  -- Iterate through each key-value pair in the JSON
  FOR radical_key, poem_desc IN
    SELECT key, value 
    FROM jsonb_each_text(json_data)
  LOOP
    BEGIN
      -- Insert the radical and poem description
      INSERT INTO radicals_poem (chinese, poem_description, category)
      VALUES (
        radical_key, 
        poem_desc, 
        'other'  -- Default category, can be updated later
      )
      ON CONFLICT (chinese) DO UPDATE SET
        poem_description = EXCLUDED.poem_description,
        updated_at = NOW();
      
      total_imported := total_imported + 1;
      
    EXCEPTION WHEN OTHERS THEN
      -- Log error and continue
      RAISE NOTICE 'Error importing radical %: %', radical_key, SQLERRM;
      total_errors := total_errors + 1;
    END;
  END LOOP;
  
  RETURN QUERY SELECT total_imported, total_skipped, total_errors;
END;
$$ LANGUAGE plpgsql;

-- Function to estimate stroke count for characters (basic heuristic)
CREATE OR REPLACE FUNCTION estimate_stroke_count(chinese_char TEXT)
RETURNS SMALLINT AS $$
DECLARE
  char_length INTEGER;
BEGIN
  -- Very basic heuristic based on character complexity
  -- This is a rough estimation and should be replaced with actual stroke count data
  char_length := LENGTH(chinese_char);
  
  -- Single character estimation based on Unicode ranges (rough approximation)
  IF char_length = 1 THEN
    -- This is a simplified heuristic - in practice, you'd want a proper stroke count database
    CASE 
      WHEN chinese_char BETWEEN '一' AND '丿' THEN RETURN 1;  -- Simple strokes
      WHEN chinese_char BETWEEN '人' AND '入' THEN RETURN 2;  -- Two strokes
      WHEN chinese_char BETWEEN '八' AND '力' THEN RETURN 3;  -- Three strokes
      ELSE RETURN NULL; -- Unknown, would need proper lookup
    END CASE;
  END IF;
  
  RETURN NULL; -- For multi-character strings or unknown cases
END;
$$ LANGUAGE plpgsql;

-- Function to update stroke counts (placeholder for when you have stroke data)
CREATE OR REPLACE FUNCTION update_stroke_counts()
RETURNS INTEGER AS $$
DECLARE
  updated_count INTEGER := 0;
  temp_count INTEGER;
BEGIN
  -- This is a placeholder function
  -- In practice, you would either:
  -- 1. Import stroke count data from an external source
  -- 2. Use a Chinese character analysis library
  -- 3. Manually assign stroke counts for common radicals
  
  -- Example manual assignments for some common radicals
  UPDATE radicals_poem SET stroke_count = 1 WHERE chinese IN ('一', '丨', '丿', '丶', '乙') AND stroke_count IS NULL;
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  UPDATE radicals_poem SET stroke_count = 2 WHERE chinese IN ('二', '亅', '人', '儿', '入', '八') AND stroke_count IS NULL;
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  UPDATE radicals_poem SET stroke_count = 3 WHERE chinese IN ('三', '口', '土', '夕', '大', '女', '子', '寸', '小', '山', '川', '工', '己', '巾', '干', '么', '广', '门', '氵', '犭', '王', '木') AND stroke_count IS NULL;
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  -- Add more common radicals as needed...
  
  RETURN updated_count;
END;
$$ LANGUAGE plpgsql;

-- Function to categorize radicals based on common patterns
CREATE OR REPLACE FUNCTION auto_categorize_radicals()
RETURNS INTEGER AS $$
DECLARE
  updated_count INTEGER := 0;
  temp_count INTEGER;
BEGIN
  -- Basic radical classification (Kangxi radicals and common patterns)
  
  -- Basic strokes and simple forms
  UPDATE radicals_poem SET category = 'basic_radical' 
  WHERE chinese IN ('一', '丨', '丿', '丶', '乙', '亅', '二', '人', '儿', '入', '八', '冂', '冖', '冫', '几', '凵', '刀', '力', '勹', '匕', '匚', '匸', '十', '卜', '卩', '厂', '厶', '又')
  AND category = 'other';
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  -- Nature and pictographic elements
  UPDATE radicals_poem SET category = 'pictograph'
  WHERE chinese IN ('日', '月', '木', '水', '火', '土', '山', '川', '雨', '云', '风', '雷', '电', '虫', '鱼', '鸟', '马', '牛', '羊', '猪', '狗', '猫', '虎', '龙', '象', '鹿')
  AND category = 'other';
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  -- Body parts and human-related
  UPDATE radicals_poem SET category = 'pictograph'
  WHERE chinese IN ('人', '口', '手', '足', '目', '耳', '心', '头', '面', '身', '手', '指', '眼', '鼻', '舌', '牙', '发', '须')
  AND category = 'other';
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  -- Numbers and counting
  UPDATE radicals_poem SET category = 'ideograph'
  WHERE chinese IN ('一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '百', '千', '万')
  AND category = 'other';
  GET DIAGNOSTICS temp_count = ROW_COUNT;
  updated_count := updated_count + temp_count;
  
  RETURN updated_count;
END;
$$ LANGUAGE plpgsql;

-- Function to validate imported data
CREATE OR REPLACE FUNCTION validate_radicals_data()
RETURNS TABLE (
  validation_type TEXT,
  issue_count BIGINT,
  details TEXT
) AS $$
BEGIN
  -- Check for empty descriptions
  RETURN QUERY
  SELECT 
    'empty_descriptions'::TEXT,
    COUNT(*),
    'Characters with empty or whitespace-only descriptions'::TEXT
  FROM radicals_poem 
  WHERE TRIM(poem_description) = '';
  
  -- Check for very short descriptions (might be incomplete)
  RETURN QUERY
  SELECT 
    'short_descriptions'::TEXT,
    COUNT(*),
    'Descriptions shorter than 10 characters'::TEXT
  FROM radicals_poem 
  WHERE LENGTH(TRIM(poem_description)) < 10;
  
  -- Check for very long descriptions (might need review)
  RETURN QUERY
  SELECT 
    'long_descriptions'::TEXT,
    COUNT(*),
    'Descriptions longer than 200 characters'::TEXT
  FROM radicals_poem 
  WHERE LENGTH(poem_description) > 200;
  
  -- Check for duplicate descriptions
  RETURN QUERY
  SELECT 
    'duplicate_descriptions'::TEXT,
    COUNT(*) - COUNT(DISTINCT poem_description),
    'Non-unique poem descriptions'::TEXT
  FROM radicals_poem;
  
  -- Check for missing stroke counts
  RETURN QUERY
  SELECT 
    'missing_stroke_counts'::TEXT,
    COUNT(*),
    'Characters without stroke count data'::TEXT
  FROM radicals_poem 
  WHERE stroke_count IS NULL;
  
END;
$$ LANGUAGE plpgsql;

-- Function to get import statistics
CREATE OR REPLACE FUNCTION get_import_statistics()
RETURNS TABLE (
  metric TEXT,
  value INTEGER,
  description TEXT
) AS $$
BEGIN
  -- Total radicals count
  RETURN QUERY
  SELECT 
    'total_radicals'::TEXT,
    COUNT(*)::INTEGER,
    'Total number of radicals imported'::TEXT
  FROM radicals_poem;
  
  -- Count by category
  RETURN QUERY
  SELECT 
    'category_' || category::TEXT,
    COUNT(*)::INTEGER,
    'Count for category: ' || category::TEXT
  FROM radicals_poem 
  GROUP BY category;
  
  -- Average description length
  RETURN QUERY
  SELECT 
    'avg_description_length'::TEXT,
    AVG(LENGTH(poem_description))::INTEGER,
    'Average length of poem descriptions'::TEXT
  FROM radicals_poem;
  
  -- Radicals with stroke count data
  RETURN QUERY
  SELECT 
    'with_stroke_count'::TEXT,
    COUNT(*)::INTEGER,
    'Radicals with stroke count information'::TEXT
  FROM radicals_poem 
  WHERE stroke_count IS NOT NULL;
  
END;
$$ LANGUAGE plpgsql;

-- Function to find potential dictionary relationships
CREATE OR REPLACE FUNCTION analyze_dictionary_relationships()
RETURNS TABLE (
  radical_char VARCHAR(10),
  radical_poem TEXT,
  related_words_count BIGINT,
  sample_words VARCHAR(100)[]
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese,
    r.poem_description,
    COUNT(d.chinese) as related_count,
    ARRAY(
      SELECT d2.chinese 
      FROM dictionary d2 
      WHERE d2.chinese LIKE '%' || r.chinese || '%'
      ORDER BY d2.chinese 
      LIMIT 5
    ) as sample_words
  FROM radicals_poem r
  LEFT JOIN dictionary d ON d.chinese LIKE '%' || r.chinese || '%'
  GROUP BY r.chinese, r.poem_description
  HAVING COUNT(d.chinese) > 0
  ORDER BY COUNT(d.chinese) DESC, r.chinese;
END;
$$ LANGUAGE plpgsql;

-- Comments
COMMENT ON FUNCTION import_radicals_from_json(JSONB) IS 'Imports radical poem data from JSON structure like {"黄": "description", ...}';
COMMENT ON FUNCTION auto_categorize_radicals() IS 'Automatically categorizes radicals based on common patterns and Kangxi radical classification';
COMMENT ON FUNCTION validate_radicals_data() IS 'Validates imported radical data for quality issues';
COMMENT ON FUNCTION analyze_dictionary_relationships() IS 'Analyzes relationships between radicals and dictionary words';
