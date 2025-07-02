const convert = () => {
  const inputFilePath = './complete-hsk-vocabulary/complete.json';
  const outputFilePath = 'hsk_vocab_simplified_levels.json';

  // Step 1: Read the JSON data
  const rawData = fs.readFileSync(inputFilePath, 'utf-8');
  const data = JSON.parse(rawData);

  // Step 2: Map to new format { chinese: simplified, level }
  const result = data.map(item => ({
    chinese: item.simplified,
    level: item.level
  }));

  // Step 3: Write structured result to JSON file
  fs.writeFileSync(outputFilePath, JSON.stringify(result, null, 2), 'utf-8');

  console.log(`✅ Successfully processed ${result.length} entries and saved to ${outputFilePath}`);
};

// convert();