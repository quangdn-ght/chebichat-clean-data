const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

class SitemapGenerator {
    constructor() {
        this.baseUrl = 'https://www.chebichat.com.vn/dict/';
        this.batchSize = 10000;
        this.inputFile = path.join(__dirname, '../../input/DICTIONARY.json');
        this.outputDir = path.join(__dirname, '../../output-sitemap');
    }

    async generateSitemaps() {
        try {
            console.log('Reading dictionary file...');
            const dictionaryData = JSON.parse(fs.readFileSync(this.inputFile, 'utf8'));
            console.log(`Found ${dictionaryData.length} dictionary entries`);

            // Create output directory if it doesn't exist
            if (!fs.existsSync(this.outputDir)) {
                fs.mkdirSync(this.outputDir, { recursive: true });
            }

            const totalBatches = Math.ceil(dictionaryData.length / this.batchSize);
            console.log(`Generating ${totalBatches} sitemap files...`);

            for (let i = 0; i < totalBatches; i++) {
                const startIndex = i * this.batchSize;
                const endIndex = Math.min(startIndex + this.batchSize, dictionaryData.length);
                const batch = dictionaryData.slice(startIndex, endIndex);
                
                await this.createSitemapFile(batch, i + 1);
                console.log(`Generated sitemap-dict-${i + 1}.xml.gz (${batch.length} entries)`);
            }

            // Generate sitemap index file
            await this.createSitemapIndex(totalBatches);
            console.log('Generated sitemap index file');

            console.log(`\nSitemap generation completed!`);
            console.log(`Total files generated: ${totalBatches} + 1 index file`);
            console.log(`Total entries processed: ${dictionaryData.length}`);

        } catch (error) {
            console.error('Error generating sitemaps:', error);
            throw error;
        }
    }

    async createSitemapFile(entries, fileNum) {
        const xmlContent = this.generateXMLContent(entries);
        const fileName = `sitemap-dict-${fileNum}.xml`;
        const gzFileName = `${fileName}.gz`;
        const filePath = path.join(this.outputDir, gzFileName);

        return new Promise((resolve, reject) => {
            const gzip = zlib.createGzip();
            const writeStream = fs.createWriteStream(filePath);

            gzip.pipe(writeStream);
            gzip.write(xmlContent);
            gzip.end();

            writeStream.on('close', resolve);
            writeStream.on('error', reject);
        });
    }

    generateXMLContent(entries) {
        const header = '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n';
        const footer = '</urlset>';
        
        const urls = entries.map(entry => {
            // URL encode the Chinese character properly
            const encodedWord = encodeURIComponent(entry.word);
            return `<url><loc>${this.baseUrl}${encodedWord}</loc></url>`;
        }).join('\n');

        return header + urls + '\n' + footer;
    }

    async createSitemapIndex(totalBatches) {
        const header = '<?xml version="1.0" encoding="UTF-8"?>\n<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n';
        const footer = '</sitemapindex>';
        
        const sitemaps = [];
        for (let i = 1; i <= totalBatches; i++) {
            sitemaps.push(`<sitemap><loc>${this.baseUrl.replace('/dict/', '/')}sitemap-dict-${i}.xml.gz</loc></sitemap>`);
        }

        const xmlContent = header + sitemaps.join('\n') + '\n' + footer;
        const indexPath = path.join(this.outputDir, 'sitemap-index.xml');
        
        fs.writeFileSync(indexPath, xmlContent, 'utf8');
    }

    // Method to generate uncompressed XML files for testing
    async generateUncompressedSitemap(entries, fileNum) {
        const xmlContent = this.generateXMLContent(entries);
        const fileName = `sitemap-dict-${fileNum}.xml`;
        const filePath = path.join(this.outputDir, fileName);
        
        fs.writeFileSync(filePath, xmlContent, 'utf8');
    }

    // Method to preview the first few entries
    previewSitemap(count = 5) {
        try {
            const dictionaryData = JSON.parse(fs.readFileSync(this.inputFile, 'utf8'));
            const preview = dictionaryData.slice(0, count);
            const xmlContent = this.generateXMLContent(preview);
            
            console.log('Preview of sitemap XML:');
            console.log(xmlContent);
            return xmlContent;
        } catch (error) {
            console.error('Error generating preview:', error);
            throw error;
        }
    }
}

// Main execution
if (require.main === module) {
    const generator = new SitemapGenerator();
    
    // Check command line arguments
    const args = process.argv.slice(2);
    
    if (args.includes('--preview')) {
        generator.previewSitemap(10);
    } else if (args.includes('--test')) {
        // Generate a test version with uncompressed files
        console.log('Generating test sitemaps (uncompressed)...');
        const dictionaryData = JSON.parse(fs.readFileSync(generator.inputFile, 'utf8'));
        const testBatch = dictionaryData.slice(0, 100); // First 100 entries for testing
        
        if (!fs.existsSync(generator.outputDir)) {
            fs.mkdirSync(generator.outputDir, { recursive: true });
        }
        
        generator.generateUncompressedSitemap(testBatch, 'test');
        console.log('Test sitemap generated: sitemap-dict-test.xml');
    } else {
        generator.generateSitemaps().catch(console.error);
    }
}

module.exports = SitemapGenerator;
