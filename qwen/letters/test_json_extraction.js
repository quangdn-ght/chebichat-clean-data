import fs from "fs/promises";

// Function to extract JSON from markdown code blocks
function extractJsonFromResponse(responseContent) {
    // Check if response is wrapped in markdown code blocks
    const jsonBlockMatch = responseContent.match(/```json\s*([\s\S]*?)\s*```/);
    if (jsonBlockMatch) {
        return jsonBlockMatch[1].trim();
    }
    
    // Check for generic code blocks
    const codeBlockMatch = responseContent.match(/```\s*([\s\S]*?)\s*```/);
    if (codeBlockMatch) {
        return codeBlockMatch[1].trim();
    }
    
    // Try to extract just the JSON object from the response
    // Look for content between the first { and the last } that forms valid JSON
    const content = responseContent.trim();
    if (content.startsWith('{')) {
        try {
            // Find the main JSON object by counting braces
            let braceCount = 0;
            let jsonEnd = 0;
            
            for (let i = 0; i < content.length; i++) {
                if (content[i] === '{') {
                    braceCount++;
                } else if (content[i] === '}') {
                    braceCount--;
                    if (braceCount === 0) {
                        jsonEnd = i + 1;
                        break;
                    }
                }
            }
            
            if (jsonEnd > 0) {
                return content.substring(0, jsonEnd);
            }
        } catch (e) {
            // Fall through to return original content
        }
    }
    
    // Return as-is if no processing worked
    return content;
}

async function testExtraction() {
    try {
        // Read the failed batch file
        const batch5 = JSON.parse(await fs.readFile('./output/radical_suggest_batch_5_of_28.json', 'utf8'));
        
        if (batch5.error && batch5.rawResponse) {
            console.log('Testing JSON extraction on batch 5 raw response...');
            
            const extractedJson = extractJsonFromResponse(batch5.rawResponse);
            console.log('Extracted JSON length:', extractedJson.length);
            console.log('First 200 chars:', extractedJson.substring(0, 200));
            console.log('Last 200 chars:', extractedJson.substring(extractedJson.length - 200));
            
            try {
                const parsed = JSON.parse(extractedJson);
                console.log('✅ Successfully parsed JSON!');
                console.log('Number of entries:', Object.keys(parsed).length);
                
                // Save the corrected result
                await fs.writeFile('./output/radical_suggest_batch_5_of_28_corrected.json', JSON.stringify(parsed, null, 2), 'utf8');
                console.log('✅ Saved corrected result to radical_suggest_batch_5_of_28_corrected.json');
                
            } catch (parseError) {
                console.log('❌ Still failed to parse:', parseError.message);
            }
        }
        
    } catch (error) {
        console.error('Error:', error);
    }
}

testExtraction();
