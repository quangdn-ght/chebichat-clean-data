# Failed Attractions Analysis

**Date:** 2025-11-13  
**Total Failed:** 11 out of 17,129 attractions (0.064%)

## Summary of Issues

### Root Causes:

1. **Political/Sensitive Content (6 items)** - Qwen AI content filter blocking historical/political references
   - Keywords triggering filters: 惨案 (massacre), 屠杀 (slaughter), 军队 (military), 开枪 (shooting), 帝国主义 (imperialism), 罢工 (strike), 示威 (demonstration), 抗议 (protest), 革命 (revolution)

2. **HTML Entities (9 items)** - Unencoded HTML in descriptions
   - Characters: `&ldquo;`, `&rdquo;`, `&`

3. **Very Long Descriptions (1 item)** - Over 3000 characters
   - Code 113598: 4268 characters

---

## Failed Items Details

### 1. Code: 103360 - 沙基惨案纪念碑 (Shakee Massacre Monument)
**Issue:** ⚠️ **HIGHLY SENSITIVE** - Historical massacre memorial  
**Keywords:** 惨案, 屠杀, 军队, 开枪, 死, 帝国主义, 杀, 运动, 罢工, 示威, 抗议  
**Length:** 361 chars  
**Reason:** Content describes 1925 massacre by British/French forces - triggers Qwen's political content filter  
**Action Required:** Manual content sanitization or skip processing

---

### 2. Code: 104421 - 融水老子山
**Issue:** HTML entities  
**Keywords:** `&ldquo;`, `&rdquo;`  
**Length:** 1241 chars  
**Reason:** Description contains HTML quotation marks  
**Action Required:** Clean HTML entities before retry

---

### 3. Code: 106766 - 武汉外语外事职业学院
**Issue:** HTML entities  
**Keywords:** `&ldquo;`, `&rdquo;`  
**Length:** 981 chars  
**Reason:** Description contains HTML quotation marks  
**Action Required:** Clean HTML entities before retry

---

### 4. Code: 107111 - 湖南大学
**Issue:** Mildly sensitive keywords + special characters  
**Keywords:** 革命 (revolution), 运动 (movement), special quotes  
**Length:** 2600 chars  
**Reason:** Historical references to revolution may trigger filter  
**Action Required:** Clean HTML + sanitize political terms

---

### 5. Code: 111797 - 东周殉马坑
**Issue:** HTML entities + death references  
**Keywords:** 死 (death), HTML entities  
**Length:** 1199 chars  
**Reason:** Archaeological site with death/burial references  
**Action Required:** Clean HTML entities before retry

---

### 6. Code: 113598 - 康定金刚寺
**Issue:** HTML entities + very long + mildly sensitive  
**Keywords:** 运动, HTML entities  
**Length:** 4268 chars (VERY LONG)  
**Reason:** Combination of length, HTML entities, and political term  
**Action Required:** Clean HTML + possibly summarize/truncate content

---

### 7. Code: 114164 - 哲蚌寺 (Drepung Monastery)
**Issue:** HTML entities  
**Length:** 980 chars  
**Reason:** Description contains HTML quotation marks  
**Action Required:** Clean HTML entities before retry

---

### 8. Code: 114165 - 罗布林卡 (Norbulingka)
**Issue:** HTML entities  
**Keywords:** `&ldquo;`, `&rdquo;`  
**Length:** 982 chars  
**Reason:** Description contains HTML quotation marks  
**Action Required:** Clean HTML entities before retry

---

### 9. Code: 114427 - 拉母拉错湖
**Issue:** HTML entities + mildly sensitive  
**Keywords:** 运动, HTML entities  
**Length:** 935 chars  
**Reason:** Religious references + HTML encoding  
**Action Required:** Clean HTML entities before retry

---

### 10. Code: 116175 - 永宁禅寺
**Issue:** HTML entities  
**Keywords:** `&ldquo;`, `&rdquo;`  
**Length:** 512 chars  
**Reason:** Description contains HTML quotation marks  
**Action Required:** Clean HTML entities before retry

---

### 11. Code: 116655 - 西天寺
**Issue:** HTML entities + mildly sensitive  
**Keywords:** 革命, HTML entities  
**Length:** 1404 chars  
**Reason:** Historical reference + HTML encoding  
**Action Required:** Clean HTML entities before retry

---

## Recommended Actions

### Immediate Fix (9 items)
**Clean HTML entities and retry:**
- 104421, 106766, 111797, 113598, 114164, 114165, 114427, 116175, 116655

### Requires Manual Review (2 items)
**Highly sensitive content - may require content modification:**
- 103360 (Shakee Massacre Monument) - ⚠️ Historical massacre
- 107111 (Hunan University) - Mentions revolution/political movements

### Next Steps

1. Create a preprocessing script to clean HTML entities
2. Retry the 9 items with cleaned content
3. For sensitive items (103360, 107111), either:
   - Skip processing (mark as excluded)
   - Manually create sanitized descriptions
   - Use alternative AI model without content filters

---

## Statistics

| Category | Count | Percentage |
|----------|-------|------------|
| Total Processed | 17,118 | 99.94% |
| Failed | 11 | 0.064% |
| HTML Entity Issues | 9 | 81.8% |
| Sensitive Content | 6 | 54.5% |
| Very Long | 1 | 9.1% |

**Success Rate: 99.94%** ✅
