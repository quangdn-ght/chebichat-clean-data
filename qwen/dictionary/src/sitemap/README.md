# CheBiChat Dictionary Sitemap Generator

This tool generates SEO-optimized sitemap files for the CheBiChat dictionary website.

## Features

- Generates gzipped XML sitemap files in batches of 10,000 entries each
- Creates a sitemap index file for search engines
- Properly URL-encodes Chinese characters
- Optimized for SEO performance

## Usage

### Generate All Sitemaps
```bash
npm run generate
# or
node sitemap.js
```

### Preview Sample Sitemap
```bash
npm run preview
# or
node sitemap.js --preview
```

### Generate Test Sitemap (100 entries, uncompressed)
```bash
npm run test
# or
node sitemap.js --test
```

## Output

The generator creates the following files in `../../output-sitemap/`:

- `sitemap-dict-1.xml.gz` to `sitemap-dict-N.xml.gz` (where N is the number of batches needed)
- `sitemap-index.xml` (index file listing all sitemap files)

## Sitemap Structure

Each sitemap file follows this format:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<url><loc>https://www.chebichat.com.vn/dict/恨</loc></url>
<url><loc>https://www.chebichat.com.vn/dict/爱</loc></url>
...
</urlset>
```

## SEO Benefits

- Helps search engines discover all dictionary entries
- Improves indexing of Chinese character URLs
- Follows Google's sitemap best practices
- Gzipped files reduce bandwidth usage

## Configuration

Edit the `SitemapGenerator` class in `sitemap.js` to modify:
- `baseUrl`: Base URL for dictionary entries
- `batchSize`: Number of entries per sitemap file (default: 10,000)
- File paths and output directory

## Statistics

Based on the current dictionary:
- Total entries: ~98,053
- Number of sitemap files: ~10
- Average file size: ~500KB (compressed)
