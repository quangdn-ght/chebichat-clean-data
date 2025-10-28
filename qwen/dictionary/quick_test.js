import OpenAI from "openai";
import fs from "fs/promises";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

// Quick test with first 2 items
async function quickTest() {
    console.log('🧪 Quick test with first 2 items from DICTIONARY.json');
    
    try {
        const inputData = JSON.parse(await fs.readFile('./input/DICTIONARY.json', 'utf8'));
        const testData = inputData.slice(0, 2);
        
        console.log('Test items:', testData.map(item => item.word));
        
        const openai = new OpenAI({
            apiKey: process.env.DASHSCOPE_API_KEY,
            baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
        });
        
        const wordsOnly = testData.map(item => item.word);
        
        const completion = await openai.chat.completions.create({
            model: "qwen-max",
            messages: [
                {
                    "role": "system",
                    "content": `Bạn là chuyên gia từ điển tiếng Trung-Việt. Trả về JSON array với format:
[
  {
    "chinese": "từ tiếng Trung",
    "pinyin": "phiên âm",
    "type": "từ loại",
    "meaning_vi": "nghĩa tiếng Việt",
    "meaning_en": "English meaning",
    "example_cn": "ví dụ tiếng Trung",
    "example_vi": "dịch tiếng Việt",
    "example_en": "English translation",
    "grammar": "ghi chú ngữ pháp"
  }
]

Chỉ trả về JSON array, không có text khác.`
                },
                {
                    "role": "user",
                    "content": JSON.stringify(wordsOnly)
                }
            ],
            temperature: 0.7,
            top_p: 0.8
        });

        const response = completion.choices[0].message.content;
        console.log('Raw response:', response);
        
        // Try to parse JSON
        const jsonMatch = response.match(/\[[\s\S]*\]/);
        if (jsonMatch) {
            const parsed = JSON.parse(jsonMatch[0]);
            console.log('✅ Parsed successfully:', parsed.length, 'items');
            console.log('First item:', JSON.stringify(parsed[0], null, 2));
            
            await fs.writeFile('./output/quick_test_result.json', JSON.stringify(parsed, null, 2));
            console.log('💾 Test result saved to output/quick_test_result.json');
        } else {
            console.log('❌ Could not extract JSON from response');
        }
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
    }
}

quickTest();
