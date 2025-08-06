import OpenAI from "openai";
import dotenv from "dotenv";

dotenv.config();

const openai = new OpenAI({
    apiKey: process.env.DASHSCOPE_API_KEY,
    baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// Test with just one word
const testWords = ["圫"];

console.log('Testing API with single word:', testWords);

try {
    const completion = await openai.chat.completions.create({
        model: "qwen-max",
        messages: [
            {"role":"system","content":"You are a Chinese-Vietnamese dictionary expert. Translate the given Chinese word to Vietnamese. Return ONLY a simple JSON object with this format: {\"chinese\": \"圫\", \"meaning_vi\": \"Vietnamese meaning here\"}. Do not add any other text or formatting."},
            {
                "role": "user", 
                "content": JSON.stringify(testWords)
            }
        ],
        top_p: 0.8,
        temperature: 0.3,
        max_tokens: 500
    });

    console.log('\n=== RAW API RESPONSE ===');
    console.log('Response content:');
    console.log(JSON.stringify(completion.choices[0].message.content, null, 2));
    console.log('\n=== END RESPONSE ===');
    
} catch (error) {
    console.error('API Error:', error.message);
    console.error('Full error:', error);
}
