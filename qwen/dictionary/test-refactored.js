import fs from "fs/promises";

// Test the refactored logic with sample data
async function testRefactoredLogic() {
    // Sample input data matching the new schema
    const sampleBatch = [
        {
            "word": "咊",
            "meaning": "①调和；调治；调适。［合］和味(调和食物的滋味)；和羹(五味调和的羹汤)；和弱(调和抑制)；和通(调和；和畅)。*②和解；息争而归和平。",
            "word_count": 15
        },
        {
            "word": "差",
            "meaning": "①错误：话说差了。*②不相当，不相合：差不多。*③缺欠：还差十元钱。*④不好，不够标准：差等。成绩差。",
            "word_count": 13
        }
    ];

    // Extract only the "word" values for API processing (simulating what we send to API)
    const wordsToProcess = sampleBatch.map(item => item.word);
    console.log("Words to process (sent to API):", wordsToProcess);

    // Simulated API response (what we expect back from Qwen)
    const mockApiResponse = [
        {
            "chinese": "咊",
            "pinyin": "hé",
            "type": "động từ",
            "meaning_vi": "Hòa hợp, điều hòa",
            "meaning_en": "To harmonize, to reconcile",
            "example_cn": "咊和万邦",
            "example_vi": "Hòa hợp với các nước",
            "example_en": "Harmonize with all nations",
            "grammar": "Động từ cổ, thường dùng trong văn ngôn",
            "hsk_level": "other"
        },
        {
            "chinese": "差",
            "pinyin": "chà",
            "type": "tính từ",
            "meaning_vi": "Tệ, kém",
            "meaning_en": "Poor, bad",
            "example_cn": "成绩很差",
            "example_vi": "Thành tích rất tệ",
            "example_en": "Very poor performance",
            "grammar": "Tính từ, có thể làm vị ngữ hoặc định ngữ",
            "hsk_level": 3
        }
    ];

    // Merge original meaning as meaning_cn (simulating the refactored logic)
    const finalResult = mockApiResponse.map((item, index) => {
        if (sampleBatch[index] && sampleBatch[index].meaning) {
            return {
                ...item,
                meaning_cn: sampleBatch[index].meaning
            };
        }
        return item;
    });

    console.log("\nFinal merged result:");
    console.log(JSON.stringify(finalResult, null, 2));

    // Save test result
    await fs.writeFile('./test-output.json', JSON.stringify(finalResult, null, 2));
    console.log("\nTest result saved to test-output.json");
}

testRefactoredLogic().catch(console.error);
