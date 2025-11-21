import { processAttraction } from './attraction-generator.js';

/**
 * Test the attraction content generator with a sample
 */
async function testGenerator() {
  console.log('🧪 Testing Attraction Content Generator\n');
  
  // Example: Yulong Snow Mountain (玉龙雪山)
  const testDescription = `玉龙雪山位于云南省丽江市玉龙纳西族自治县，是中国最南的雪山，也是横断山脉的沙鲁里山南段的名山。玉龙雪山最高海拔5596米，山顶终年积雪，由13座雪峰组成，主峰扇子陡最高海拔5596米，山体南北长35公里，东西宽13公里。玉龙雪山在纳西语中被称为"欧鲁"，意为"天山"。其十三峰由北向南纵向排列，如矫健的玉龙横卧山巅，故名"玉龙雪山"。玉龙雪山以其壮丽的自然风光和独特的民族文化闻名于世，是纳西族及丽江各民族心目中的神山，主神"三朵"就是玉龙雪山的化身。玉龙雪山景区包括甘海子、云杉坪、牦牛坪、冰川公园等，拥有北半球纬度最低的现代海洋性冰川。山上植被垂直分布明显，从山脚到山顶依次为亚热带、温带、寒温带和冰雪带，景观丰富多彩。春季山花烂漫，夏季绿草如茵，秋季色彩斑斓，冬季雪山巍峨，四季景色各异，美不胜收。游客可以乘坐大索道到达海拔4506米的冰川公园，近距离观赏千年冰川，体验高原风光。玉龙雪山不仅是自然奇观，也承载着丰富的纳西族文化和传说，是探索云南多元文化和壮丽自然的绝佳目的地。`;

  try {
    const result = await processAttraction(testDescription);
    
    console.log('\n✅ Test completed successfully!\n');
    console.log('📋 Full Result:');
    console.log(JSON.stringify(result, null, 2));
    
  } catch (error) {
    console.error('\n❌ Test failed:', error.message);
    process.exit(1);
  }
}

// Run test
testGenerator();
