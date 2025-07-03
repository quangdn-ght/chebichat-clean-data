import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Get __dirname equivalent in ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Parse XML data from file qwen/input/dict/zh-vi.txt and append output to json file.
 * 🔠 Schema Tag Definitions (in English):
 * Tag	Meaning	Description
 * <d-meta>	Metadata	Contains meta information about the entry — usually the Sino-Vietnamese reading (Hán Việt).
 * <d-def>	Definition	Holds the Vietnamese definition, sometimes followed by Chinese notes or explanations.
 * <d-eg>	Example (Chinese)	A sentence or phrase in Chinese that uses the word in context.
 * <d-eg-tsl>	Example Translation (Vietnamese)	The Vietnamese translation of the preceding <d-eg> example.
 */

function parseXmlContent(xmlContent) {
    const entries = [];
    
    // Debug: Log first 1000 characters to see the structure
    console.log('File content preview:');
    console.log(xmlContent.substring(0, 1000));
    console.log('---');
    
    // Try multiple patterns to find entries
    let entryPattern = /<d-meta>[\s\S]*?(?=<d-meta>|$)/g;
    let matches = xmlContent.match(entryPattern);
    
    // If no matches, try alternative patterns
    if (!matches) {
        console.log('No matches with d-meta pattern, trying alternative patterns...');
        
        // Try looking for entries that start with Chinese characters followed by tags
        entryPattern = /[一-龯\u3400-\u4DBF]+[\s\S]*?(?=[一-龯\u3400-\u4DBF]+<|$)/g;
        matches = xmlContent.match(entryPattern);
    }
    
    if (!matches) {
        // Try splitting by newlines and processing line by line
        console.log('Trying line-by-line parsing...');
        const lines = xmlContent.split('\n');
        let currentEntry = '';
        
        for (const line of lines) {
            if (line.includes('<d-meta>') && currentEntry) {
                // Process previous entry
                const entry = parseEntry(currentEntry);
                if (entry) entries.push(entry);
                currentEntry = line;
            } else if (line.trim()) {
                currentEntry += '\n' + line;
            }
        }
        
        // Process last entry
        if (currentEntry) {
            const entry = parseEntry(currentEntry);
            if (entry) entries.push(entry);
        }
        
        return entries;
    }
    
    console.log(`Found ${matches.length} potential entries`);
    
    matches.forEach((entryText, index) => {
        try {
            console.log(`Processing entry ${index + 1}:`);
            console.log(entryText.substring(0, 200) + '...');
            
            const entry = parseEntry(entryText);
            if (entry) {
                entries.push(entry);
                console.log(`✓ Successfully parsed: ${entry.word}`);
            } else {
                console.log('✗ Failed to parse entry');
            }
        } catch (error) {
            console.error(`Error parsing entry ${index + 1}:`, error);
        }
    });
    
    return entries;
}

function parseEntry(entryText) {
    console.log('Parsing entry text:', entryText.substring(0, 300));
    
    const entry = {
        word: "",
        hanviet: "",
        definition: {
            vietnamese: "",
            chinese_note: ""
        },
        examples: []
    };
    
    // Extract word - try multiple approaches
    let wordMatch = entryText.match(/^([一-龯\u3400-\u4DBF]+)/);
    if (!wordMatch) {
        // Try finding word before first tag
        wordMatch = entryText.match(/^([^\s<\n]+)/);
    }
    if (!wordMatch) {
        // Try finding Chinese characters anywhere at the beginning
        wordMatch = entryText.match(/([一-龯\u3400-\u4DBF〇]+)/);
    }
    
    if (wordMatch) {
        entry.word = wordMatch[1].trim();
        console.log(`Found word: ${entry.word}`);
    }
    
    // Extract Han Viet reading from d-meta
    const metaMatch = entryText.match(/<d-meta[^>]*>(.*?)<\/d-meta>/s);
    if (metaMatch) {
        entry.hanviet = metaMatch[1].trim().toUpperCase();
        console.log(`Found hanviet: ${entry.hanviet}`);
    }
    
    // Extract definition from d-def
    const defMatch = entryText.match(/<d-def[^>]*>(.*?)<\/d-def>/s);
    if (defMatch) {
        const defContent = defMatch[1].trim();
        console.log(`Found definition: ${defContent.substring(0, 100)}`);
        
        // Check if there's a Chinese note (usually in parentheses or after certain patterns)
        const chineseNoteMatch = defContent.match(/([^。]+[。])\s*(.+)/);
        if (chineseNoteMatch) {
            entry.definition.vietnamese = chineseNoteMatch[1].trim();
            entry.definition.chinese_note = chineseNoteMatch[2].trim();
        } else {
            entry.definition.vietnamese = defContent;
        }
    }
    
    // Extract examples
    const egMatches = entryText.match(/<d-eg[^>]*>(.*?)<\/d-eg>/gs);
    const egTslMatches = entryText.match(/<d-eg-tsl[^>]*>(.*?)<\/d-eg-tsl>/gs);
    
    if (egMatches && egTslMatches) {
        const minLength = Math.min(egMatches.length, egTslMatches.length);
        console.log(`Found ${minLength} example pairs`);
        
        for (let i = 0; i < minLength; i++) {
            const zhExample = egMatches[i].replace(/<\/?d-eg[^>]*>/g, '').trim();
            const viExample = egTslMatches[i].replace(/<\/?d-eg-tsl[^>]*>/g, '').trim();
            
            if (zhExample && viExample) {
                entry.examples.push({
                    zh: zhExample,
                    vi: viExample
                });
            }
        }
    }
    
    // Only return entry if it has at least a word and definition
    if (entry.word && entry.definition.vietnamese) {
        return entry;
    }
    
    console.log('Entry rejected - missing required fields');
    return null;
}

// ...existing code...
function appendToJsonFile(entries, outputFile) {
    try {
        let existingData = [];
        
        // Read existing JSON file if it exists
        if (fs.existsSync(outputFile)) {
            const existingContent = fs.readFileSync(outputFile, 'utf8');
            if (existingContent.trim()) {
                existingData = JSON.parse(existingContent);
            }
        }
        
        // Append new entries
        existingData.push(...entries);
        
        // Write back to file
        fs.writeFileSync(outputFile, JSON.stringify(existingData, null, 2), 'utf8');
        console.log(`Successfully appended ${entries.length} entries to ${outputFile}`);
        
    } catch (error) {
        console.error('Error writing to JSON file:', error);
    }
}

function main() {
    const inputFile = path.join(__dirname, 'input', 'dict', 'zh-vi.html');
    const outputFile = path.join(__dirname, 'output', 'zh-vi-dictionary.json');
    
    try {
        // Ensure output directory exists
        const outputDir = path.dirname(outputFile);
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }
        
        // Read input file
        if (!fs.existsSync(inputFile)) {
            console.error(`Input file not found: ${inputFile}`);
            return;
        }
        
        const xmlContent = fs.readFileSync(inputFile, 'utf8');
        console.log(`Reading from: ${inputFile}`);
        console.log(`File size: ${xmlContent.length} characters`);
        
        // Parse XML content
        const entries = parseXmlContent(xmlContent);
        console.log(`Parsed ${entries.length} entries`);
        
        if (entries.length > 0) {
            // Append to JSON file
            appendToJsonFile(entries, outputFile);
            console.log(`Output written to: ${outputFile}`);
        } else {
            console.log('No valid entries found to process');
        }
        
    } catch (error) {
        console.error('Error processing file:', error);
    }
}

// Run the script
main();

export { parseXmlContent, parseEntry, appendToJsonFile };