INSERT INTO categories (name, description) VALUES ('life', 'life related content') ON CONFLICT (name) DO NOTHING;

INSERT INTO sources (name, description) VALUES ('999 letters to yourself', 'Source: 999 letters to yourself') ON CONFLICT (name) DO NOTHING;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多',
  'bié rén zài áo yè de shí hòu ， nǐ zài shuì jiào ； bié rén yǐ jīng qǐ chuáng ， nǐ hái zài zhēng zhá zài duō shuì jǐ fēn zhōng 。 nǐ yǒu hěn duō xiǎng fǎ ， dàn nǎo dài rè le jiù guò le ， bié rén què yí jiàn shì jiān chí dào dǐ 。 nǐ lián yì běn shū dōu yào kàn hěn jiǔ ， gāi gōng zuò de shí hòu jiù shuā qǐ shǒu jī ， kěn dìng yě bù néng zǎo chén qǐ lái bèi dān cí ， wǎn shàng jiā bān dào shēn yè 。 hěn duō shí hòu bú shì nǐ píng fán ， lù lù wú wéi ， ér shì nǐ méi yǒu bié rén fù chū dé duō',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多'),
  1,
  ARRAY['在','的','时候','你','在睡觉','起床','再','多','睡','几分','钟','你有','很多','想法','脑袋','热','了','一件事','一本书','都','很久','工作的','起手','机','能','起来','不是','没有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多'),
  2,
  ARRAY['别人','已经','还','但','就','过','要看','也不','早晨','晚上','到','得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多'),
  3,
  ARRAY['该','刷','单词','加班','平凡','而是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多'),
  4,
  ARRAY['却','坚持到底','连','肯定','深夜','付出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多'),
  5,
  ARRAY['熬夜','挣扎','背']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多'),
  6,
  ARRAY['碌碌无为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运',
  'dāng yí gè rén hū lüè nǐ shí ， bú yào shāng xīn ， měi gè rén dōu yǒu zì jǐ de shēng huó ， shuí dōu bù kě néng yì zhí péi nǐ 。 zuì gān gà de mò guò yú gāo gū zì jǐ zài bié rén xīn lǐ de wèi zhì ， qí shí nǐ míng míng zhī dào ， zuì bēi jiàn bú guò gǎn qíng ， zuì liáng bú guò rén xīn 。 shì nǐ de ， jiù shì nǐ de 。 yǒu de dōng xī jiù xiàng shǒu zhōng shā ， yuè shì jǐn wò ， jiù huì liú shī dé yuè kuài 。 nǔ lì le ， zhēn xī le ， wèn xīn wú kuì 。 qí tā de ， jiāo gěi mìng yùn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运'),
  1,
  ARRAY['一个人','你','时','不要','都','有','生活','谁','不可能','一直','高估','在','的','明明','不过','人心','是','你的','有的','东西','会','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运'),
  2,
  ARRAY['每个人','最','别人','知道','就是','就像','手中','就','得','快','问心无愧']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运'),
  3,
  ARRAY['当','自己的','自己','心里','位置','其实','感情','越是','越','努力','其他的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运'),
  4,
  ARRAY['伤心','陪','凉','沙','紧握','流失','交给','命运']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运'),
  5,
  ARRAY['忽略','珍惜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当一个人忽略你时，不要伤心，每个人都有自己的生活，谁都不可能一直陪你。最尴尬的莫过于高估自己在别人心里的位置，其实你明明知道，最卑贱不过感情，最凉不过人心。是你的，就是你的。有的东西就像手中沙，越是紧握，就会流失得越快。努力了，珍惜了，问心无愧。其他的，交给命运'),
  6,
  ARRAY['尴尬的','莫过于','卑贱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足',
  'shì shàng méi yǒu yí jiàn gōng zuò bù xīn kǔ ， méi yǒu yí chù rén shì bú fù zá 。 bú yào suí yì fā pí qi ， shuí dōu bú qiàn nǐ de 。 xué huì dī diào ， qǔ shě jiān bì yǒu dé shī ， bú yòng tài jì jiào 。 xué zhe tà shí ér wù shí ， yuè nǔ lì yuè xìng yùn 。 dāng yí gè rén yǒu le zú gòu de nèi hán hé wù zhì zuò hòu dùn ， rén shēng jiù huì biàn de dǐ qì shí zú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足'),
  1,
  ARRAY['没有','一件工作','不','一','人事','不复','不要','谁','都','你的','学会','有','不用','太','学','一个人','有了','和','做','后盾','人生','会','十足']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足'),
  2,
  ARRAY['间','得失','着','务实','足够的','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足'),
  3,
  ARRAY['世上','发脾气','必','而','越','努力','当','物质','变得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足'),
  4,
  ARRAY['辛苦','处','杂','随意','低调','取舍','计较','幸运','内涵','底气']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足'),
  5,
  ARRAY['欠']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上没有一件工作不辛苦，没有一处人事不复杂。不要随意发脾气，谁都不欠你的。学会低调，取舍间必有得失，不用太计较。学着踏实而务实，越努力越幸运。当一个人有了足够的内涵和物质做后盾，人生就会变得底气十足'),
  6,
  ARRAY['踏实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你今天的努力，是幸运的伏笔。当下的付出，是明日的花开',
  'nǐ jīn tiān de nǔ lì ， shì xìng yùn de fú bǐ 。 dāng xià de fù chū ， shì míng rì de huā kāi',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你今天的努力，是幸运的伏笔。当下的付出，是明日的花开'),
  1,
  ARRAY['你','今天','的','是','明日','开']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你今天的努力，是幸运的伏笔。当下的付出，是明日的花开'),
  3,
  ARRAY['努力','当下','花']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你今天的努力，是幸运的伏笔。当下的付出，是明日的花开'),
  4,
  ARRAY['幸运的','付出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你今天的努力，是幸运的伏笔。当下的付出，是明日的花开'),
  6,
  ARRAY['伏笔']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去',
  'bù guǎn zuó yè jīng lì le zěn yàng de qì bù chéng shēng ， zǎo chén xǐng lái zhè gè chéng shì yī rán chē shuǐ mǎ lóng 。 kāi xīn huò zhě bù kāi xīn ， chéng shì dōu méi yǒu gōng fū děng ， nǐ zhǐ néng míng jì huò zhě yí wàng 。 nà yí zhàn nǐ ài guò huò zhě hèn guò de lǚ chéng ， nà yí duàn nǐ pīn mìng nǔ lì què gǎn jué bú dào xī wàng de rì zi ， dōu huì guò qù',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去'),
  1,
  ARRAY['不管','昨夜','了','怎样','的','这个','车水马龙','开心','不开心','都','没有','工夫','你','那','一','爱','一段','不到','都会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去'),
  2,
  ARRAY['经历','早晨','等','站','过','旅程','希望的','日子','过去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去'),
  3,
  ARRAY['城市','或者','只能','努力','感觉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去'),
  4,
  ARRAY['醒来','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去'),
  5,
  ARRAY['依然','遗忘','恨','拼命']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管昨夜经历了怎样的泣不成声，早晨醒来这个城市依然车水马龙。开心或者不开心，城市都没有工夫等，你只能铭记或者遗忘。那一站你爱过或者恨过的旅程，那一段你拼命努力却感觉不到希望的日子，都会过去'),
  6,
  ARRAY['泣不成声','铭记']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '我不敢休息，因为我没有存款；我不敢说累，因为我没有成就；我不敢偷懒，因为我还要生活；我能放弃选择，但是我不能选择放弃。所以，坚强、拼搏、努力是我唯一的选择',
  'wǒ bù gǎn xiū xi ， yīn wèi wǒ méi yǒu cún kuǎn ； wǒ bù gǎn shuō lèi ， yīn wèi wǒ méi yǒu chéng jiù ； wǒ bù gǎn tōu lǎn ， yīn wèi wǒ hái yào shēng huó ； wǒ néng fàng qì xuǎn zé ， dàn shì wǒ bù néng xuǎn zé fàng qì 。 suǒ yǐ ， jiān qiáng 、 pīn bó 、 nǔ lì shì wǒ wéi yī de xuǎn zé',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我不敢休息，因为我没有存款；我不敢说累，因为我没有成就；我不敢偷懒，因为我还要生活；我能放弃选择，但是我不能选择放弃。所以，坚强、拼搏、努力是我唯一的选择'),
  1,
  ARRAY['我','不敢','没有','说','生活','我能','我不能','是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我不敢休息，因为我没有存款；我不敢说累，因为我没有成就；我不敢偷懒，因为我还要生活；我能放弃选择，但是我不能选择放弃。所以，坚强、拼搏、努力是我唯一的选择'),
  2,
  ARRAY['休息','因为','累','还要','但是','所以']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我不敢休息，因为我没有存款；我不敢说累，因为我没有成就；我不敢偷懒，因为我还要生活；我能放弃选择，但是我不能选择放弃。所以，坚强、拼搏、努力是我唯一的选择'),
  3,
  ARRAY['成就','放弃','选择','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我不敢休息，因为我没有存款；我不敢说累，因为我没有成就；我不敢偷懒，因为我还要生活；我能放弃选择，但是我不能选择放弃。所以，坚强、拼搏、努力是我唯一的选择'),
  4,
  ARRAY['存款','坚强']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我不敢休息，因为我没有存款；我不敢说累，因为我没有成就；我不敢偷懒，因为我还要生活；我能放弃选择，但是我不能选择放弃。所以，坚强、拼搏、努力是我唯一的选择'),
  5,
  ARRAY['偷懒','拼搏','唯一的选择']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每一个优秀的人，都有一段苦逼的时光。或许是因为一份学业，一份工作，一段爱情，离开了爸爸妈妈，去了一座别的城市。当你倦了厌了时，想想你的父母正在为你打拼，这就是你必须坚强的理由',
  'měi yí gè yōu xiù de rén ， dōu yǒu yí duàn kǔ bī de shí guāng 。 huò xǔ shì yīn wèi yí fèn xué yè ， yí fèn gōng zuò ， yí duàn ài qíng ， lí kāi le bà ba mā ma ， qù le yí zuò bié de chéng shì 。 dāng nǐ juàn le yàn le shí ， xiǎng xiǎng nǐ de fù mǔ zhèng zài wèi nǐ dǎ pīn ， zhè jiù shì nǐ bì xū jiān qiáng de lǐ yóu',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都有一段苦逼的时光。或许是因为一份学业，一份工作，一段爱情，离开了爸爸妈妈，去了一座别的城市。当你倦了厌了时，想想你的父母正在为你打拼，这就是你必须坚强的理由'),
  1,
  ARRAY['人','都','有','一段','的','时光','是因为','一份','学业','工作','爱情','了','爸爸','妈妈','去了','一','你','时','想想','你的','打拼','这']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都有一段苦逼的时光。或许是因为一份学业，一份工作，一段爱情，离开了爸爸妈妈，去了一座别的城市。当你倦了厌了时，想想你的父母正在为你打拼，这就是你必须坚强的理由'),
  2,
  ARRAY['每一个','离开','别的','正在','为','就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都有一段苦逼的时光。或许是因为一份学业，一份工作，一段爱情，离开了爸爸妈妈，去了一座别的城市。当你倦了厌了时，想想你的父母正在为你打拼，这就是你必须坚强的理由'),
  3,
  ARRAY['或许','城市','当','必须','理由']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都有一段苦逼的时光。或许是因为一份学业，一份工作，一段爱情，离开了爸爸妈妈，去了一座别的城市。当你倦了厌了时，想想你的父母正在为你打拼，这就是你必须坚强的理由'),
  4,
  ARRAY['优秀的','苦','座','厌','父母','坚强的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都有一段苦逼的时光。或许是因为一份学业，一份工作，一段爱情，离开了爸爸妈妈，去了一座别的城市。当你倦了厌了时，想想你的父母正在为你打拼，这就是你必须坚强的理由'),
  6,
  ARRAY['逼','倦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '这个社会是现实的，你没有实力的时候，人家首先看你外表。所以，当你没有外表的时候，努力增强实力，当你既没外表又没实力的时候，人家只会跟你说：拜拜',
  'zhè gè shè huì shì xiàn shí de ， nǐ méi yǒu shí lì de shí hòu ， rén jiā shǒu xiān kàn nǐ wài biǎo 。 suǒ yǐ ， dāng nǐ méi yǒu wài biǎo de shí hòu ， nǔ lì zēng qiáng shí lì ， dāng nǐ jì méi wài biǎo yòu méi shí lì de shí hòu ， rén jiā zhī huì gēn nǐ shuō ： bài bài',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个社会是现实的，你没有实力的时候，人家首先看你外表。所以，当你没有外表的时候，努力增强实力，当你既没外表又没实力的时候，人家只会跟你说：拜拜'),
  1,
  ARRAY['这个','是','现实的','你','没有','的','时候','人家','看','没','会','说']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个社会是现实的，你没有实力的时候，人家首先看你外表。所以，当你没有外表的时候，努力增强实力，当你既没外表又没实力的时候，人家只会跟你说：拜拜'),
  2,
  ARRAY['外表','所以','外表的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个社会是现实的，你没有实力的时候，人家首先看你外表。所以，当你没有外表的时候，努力增强实力，当你既没外表又没实力的时候，人家只会跟你说：拜拜'),
  3,
  ARRAY['实力','当','努力','又','只','跟']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个社会是现实的，你没有实力的时候，人家首先看你外表。所以，当你没有外表的时候，努力增强实力，当你既没外表又没实力的时候，人家只会跟你说：拜拜'),
  4,
  ARRAY['社会','首先','增强','既','拜拜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '买得起自己喜欢的东西，去得了自己想去的地方，不会因为身边人的来或走损失生活的质量，反而会因为花自己的钱，来得更有底气一些，这就是应该努力的原因',
  'mǎi de qǐ zì jǐ xǐ huan de dōng xī ， qù dé le zì jǐ xiǎng qù de dì fāng ， bú huì yīn wèi shēn biān rén de lái huò zǒu sǔn shī shēng huó de zhì liàng ， fǎn ér huì yīn wèi huā zì jǐ de qián ， lái de gèng yǒu dǐ qì yì xiē ， zhè jiù shì yīng gāi nǔ lì de yuán yīn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '买得起自己喜欢的东西，去得了自己想去的地方，不会因为身边人的来或走损失生活的质量，反而会因为花自己的钱，来得更有底气一些，这就是应该努力的原因'),
  1,
  ARRAY['买得起','喜欢的','东西','去得','了','想去','的','不会','人的','来','生活的','会','钱','来得','有底','气','一些','这']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '买得起自己喜欢的东西，去得了自己想去的地方，不会因为身边人的来或走损失生活的质量，反而会因为花自己的钱，来得更有底气一些，这就是应该努力的原因'),
  2,
  ARRAY['因为','身边','走','就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '买得起自己喜欢的东西，去得了自己想去的地方，不会因为身边人的来或走损失生活的质量，反而会因为花自己的钱，来得更有底气一些，这就是应该努力的原因'),
  3,
  ARRAY['自己','地方','或','花','自己的','更','应该','努力的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '买得起自己喜欢的东西，去得了自己想去的地方，不会因为身边人的来或走损失生活的质量，反而会因为花自己的钱，来得更有底气一些，这就是应该努力的原因'),
  4,
  ARRAY['质量','反而','原因']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '买得起自己喜欢的东西，去得了自己想去的地方，不会因为身边人的来或走损失生活的质量，反而会因为花自己的钱，来得更有底气一些，这就是应该努力的原因'),
  5,
  ARRAY['损失']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '没有人陪你走一辈子，所以你要适应孤独；没有人会帮你一辈子，所以你要一直奋斗',
  'méi yǒu rén péi nǐ zǒu yí bèi zi ， suǒ yǐ nǐ yào shì yìng gū dú ； méi yǒu rén huì bāng nǐ yí bèi zi ， suǒ yǐ nǐ yào yì zhí fèn dòu',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人陪你走一辈子，所以你要适应孤独；没有人会帮你一辈子，所以你要一直奋斗'),
  1,
  ARRAY['没有人','你','一辈子','会','一直']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人陪你走一辈子，所以你要适应孤独；没有人会帮你一辈子，所以你要一直奋斗'),
  2,
  ARRAY['走','所以','要','帮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人陪你走一辈子，所以你要适应孤独；没有人会帮你一辈子，所以你要一直奋斗'),
  4,
  ARRAY['陪','适应','奋斗']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人陪你走一辈子，所以你要适应孤独；没有人会帮你一辈子，所以你要一直奋斗'),
  6,
  ARRAY['孤独']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '早上醒来时，给自己定个目标：今天一定要比昨天好！每天坚持，一定会大有收获',
  'zǎo shàng xǐng lái shí ， gěi zì jǐ dìng gè mù biāo ： jīn tiān yí dìng yào bǐ zuó tiān hǎo ！ měi tiān jiān chí ， yí dìng huì dà yǒu shōu huò',
  'Khi thức dậy vào buổi sáng, hãy đặt cho mình một mục tiêu: Hôm nay nhất định phải tốt hơn hôm qua! Kiên trì mỗi ngày, chắc chắn bạn sẽ gặt hái được nhiều thành quả.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '早上醒来时，给自己定个目标：今天一定要比昨天好！每天坚持，一定会大有收获'),
  1,
  ARRAY['时','个','今天','一定要','昨天','好','一定','会','大有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '早上醒来时，给自己定个目标：今天一定要比昨天好！每天坚持，一定会大有收获'),
  2,
  ARRAY['早上','给','比','每天']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '早上醒来时，给自己定个目标：今天一定要比昨天好！每天坚持，一定会大有收获'),
  3,
  ARRAY['自己','定','目标']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '早上醒来时，给自己定个目标：今天一定要比昨天好！每天坚持，一定会大有收获'),
  4,
  ARRAY['醒来','坚持','收获']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '静下心来好好做你该做的事，该好好努力了！有时候真的努力后，你会发现自己要比想象得优秀很多',
  'jìng xià xīn lái hǎo hǎo zuò nǐ gāi zuò de shì ， gāi hǎo hǎo nǔ lì le ！ yǒu shí hòu zhēn de nǔ lì hòu ， nǐ huì fā xiàn zì jǐ yào bǐ xiǎng xiàng dé yōu xiù hěn duō',
  'Hãy bình tĩnh và làm tốt những việc bạn cần làm, đã đến lúc phải nỗ lực thật sự rồi! Đôi khi sau khi cố gắng hết mình, bạn sẽ nhận ra mình xuất sắc hơn nhiều so với tưởng tượng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '静下心来好好做你该做的事，该好好努力了！有时候真的努力后，你会发现自己要比想象得优秀很多'),
  1,
  ARRAY['下','来','好好','做','你','的','了','有时候','后','会','想象','很多']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '静下心来好好做你该做的事，该好好努力了！有时候真的努力后，你会发现自己要比想象得优秀很多'),
  2,
  ARRAY['事','真的','要','比','得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '静下心来好好做你该做的事，该好好努力了！有时候真的努力后，你会发现自己要比想象得优秀很多'),
  3,
  ARRAY['静','心','该','努力','发现','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '静下心来好好做你该做的事，该好好努力了！有时候真的努力后，你会发现自己要比想象得优秀很多'),
  4,
  ARRAY['优秀']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事',
  'qiāo qiāo dì qù nǔ lì ， děng biàn lì hài zhī hòu ， bèng chū lái bǎ céng jīng kàn bù qǐ zì jǐ de rén xià yí dà tiào ， cái shì nǐ xiàn zài xū yào dàng zuò mù biāo dì shì',
  'Cố gắng trong im lặng, khi bạn đã trở nên giỏi giang, hãy xuất hiện và khiến những người từng coi thường bạn phải ngạc nhiên. Đó mới chính là mục tiêu bạn nên hướng đến.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事'),
  1,
  ARRAY['去','出来','看不起','人','一大','你','现在','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事'),
  2,
  ARRAY['等','跳','事']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事'),
  3,
  ARRAY['努力','变','把','自己的','才是','需要','当作','目标']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事'),
  4,
  ARRAY['厉害','之后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事'),
  5,
  ARRAY['悄悄地','曾经','吓']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '悄悄地去努力，等变厉害之后，蹦出来把曾经看不起自己的人吓一大跳，才是你现在需要当作目标的事'),
  6,
  ARRAY['蹦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你的努力，也许有人会讥讽；你的执着，也许不会有人读懂。在别人眼里你也许是小丑，但在自己心中你就是女王',
  'nǐ de nǔ lì ， yě xǔ yǒu rén huì jī fěng ； nǐ de zhí zhuó ， yě xǔ bú huì yǒu rén dú dǒng 。 zài bié rén yǎn lǐ nǐ yě xǔ shì xiǎo chǒu ， dàn zài zì jǐ xīn zhōng nǐ jiù shì nǚ wáng',
  'Sự nỗ lực của bạn có thể bị người khác chế giễu; sự kiên trì của bạn có thể không ai hiểu. Trong mắt người khác, bạn có thể là chú hề, nhưng trong lòng mình, bạn chính là nữ hoàng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的努力，也许有人会讥讽；你的执着，也许不会有人读懂。在别人眼里你也许是小丑，但在自己心中你就是女王'),
  1,
  ARRAY['你的','有人','会','不会','读懂','在','你','是','小丑','女王']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的努力，也许有人会讥讽；你的执着，也许不会有人读懂。在别人眼里你也许是小丑，但在自己心中你就是女王'),
  2,
  ARRAY['也许','别人','眼里','但','就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的努力，也许有人会讥讽；你的执着，也许不会有人读懂。在别人眼里你也许是小丑，但在自己心中你就是女王'),
  3,
  ARRAY['努力','自己','心中']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的努力，也许有人会讥讽；你的执着，也许不会有人读懂。在别人眼里你也许是小丑，但在自己心中你就是女王'),
  5,
  ARRAY['执着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的努力，也许有人会讥讽；你的执着，也许不会有人读懂。在别人眼里你也许是小丑，但在自己心中你就是女王'),
  6,
  ARRAY['讥讽']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能',
  'zòng rán wǒ méi yǒu jīng shì cái huá ， zòng rán wǒ méi yǒu fēng hòu cái fù ， dàn shì wǒ yǒu mǎn qiāng de jī qíng ， wǒ yǒu lè guān de tài dù ， yīn wèi wǒ xiāng xìn ： zhǐ yào nǔ lì ， yí qiè jiē yǒu kě néng',
  'Dù tôi không có tài năng xuất chúng, dù tôi không có của cải dồi dào, nhưng tôi có lòng nhiệt huyết và thái độ lạc quan, bởi vì tôi tin rằng: chỉ cần cố gắng, mọi thứ đều có thể.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能'),
  1,
  ARRAY['我','没有','我有','的','一切','有可能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能'),
  2,
  ARRAY['但是','乐观的','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能'),
  3,
  ARRAY['世','才华','满腔','相信','只要','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能'),
  4,
  ARRAY['惊','丰厚','激情','态度']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能'),
  5,
  ARRAY['财富']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵然我没有惊世才华，纵然我没有丰厚财富，但是我有满腔的激情，我有乐观的态度，因为我相信：只要努力，一切皆有可能'),
  6,
  ARRAY['纵然','皆']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有时候，努力一点，是为让自己有资格，不去做不喜欢的事；为了能让自己，遇见一个喜欢的人时，不会因为，自己不够好而没能留住对方；为了避免，与朋友拉开差距未来也能看到同一个世界；为了看清自己最后能走到哪里',
  'yǒu shí hòu ， nǔ lì yì diǎn ， shì wèi ràng zì jǐ yǒu zī gé ， bú qù zuò bù xǐ huan de shì ； wèi le néng ràng zì jǐ ， yù jiàn yí gè xǐ huan de rén shí ， bú huì yīn wèi ， zì jǐ bú gòu hǎo ér méi néng liú zhù duì fāng ； wèi le bì miǎn ， yǔ péng yǒu lā kāi chā jù wèi lái yě néng kàn dào tóng yí gè shì jiè ； wèi le kàn qīng zì jǐ zuì hòu néng zǒu dào nǎ lǐ',
  'Đôi khi, cố gắng thêm một chút là để mình có đủ tư cách không phải làm những điều mình không thích; để khi gặp người mình yêu quý, mình không đánh mất họ chỉ vì bản thân chưa đủ tốt; để không bị tụt hậu so với bạn bè và cùng nhau nhìn về một thế giới; để xem mình cuối cùng có thể đi đến đâu.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候，努力一点，是为让自己有资格，不去做不喜欢的事；为了能让自己，遇见一个喜欢的人时，不会因为，自己不够好而没能留住对方；为了避免，与朋友拉开差距未来也能看到同一个世界；为了看清自己最后能走到哪里'),
  1,
  ARRAY['有时候','一点','是','有资格','不去','做','不喜欢','的','能','一个','喜欢的','人时','不会','不够好','没','对方','朋友','看到','同一个','看清','哪里']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候，努力一点，是为让自己有资格，不去做不喜欢的事；为了能让自己，遇见一个喜欢的人时，不会因为，自己不够好而没能留住对方；为了避免，与朋友拉开差距未来也能看到同一个世界；为了看清自己最后能走到哪里'),
  2,
  ARRAY['为','让','事','为了','因为','也','最后','走到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候，努力一点，是为让自己有资格，不去做不喜欢的事；为了能让自己，遇见一个喜欢的人时，不会因为，自己不够好而没能留住对方；为了避免，与朋友拉开差距未来也能看到同一个世界；为了看清自己最后能走到哪里'),
  3,
  ARRAY['努力','自己','遇见','而','留住','差距','世界']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候，努力一点，是为让自己有资格，不去做不喜欢的事；为了能让自己，遇见一个喜欢的人时，不会因为，自己不够好而没能留住对方；为了避免，与朋友拉开差距未来也能看到同一个世界；为了看清自己最后能走到哪里'),
  4,
  ARRAY['与','拉开']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候，努力一点，是为让自己有资格，不去做不喜欢的事；为了能让自己，遇见一个喜欢的人时，不会因为，自己不够好而没能留住对方；为了避免，与朋友拉开差距未来也能看到同一个世界；为了看清自己最后能走到哪里'),
  5,
  ARRAY['避免','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义',
  'chéng gōng yùn niàng yú hǎo de pǐn zhì ， bú yào sōng xiè jīng shén shàng de zhuī qiú ； yǎn hǎo zì jǐ de jué sè ， zuò hǎo zhí zé nèi de shì qíng ， fáng zhǐ qīng yì yuè wèi ； yí dàn què dìng mù biāo ， jiù sǐ sǐ dì dīng zhe tā ； bú yào hài pà jìng zhēng ， méi yǒu jìng zhēng ， shēng cún jiù shī qù le yì yì',
  'Thành công được nuôi dưỡng từ những phẩm chất tốt, đừng lơi lỏng việc theo đuổi tinh thần; hãy diễn tốt vai trò của mình, hoàn thành tốt nhiệm vụ được giao, tránh vượt quá giới hạn; một khi đã xác định mục tiêu, hãy tập trung vào đó; đừng sợ cạnh tranh, không có cạnh tranh, cuộc sống sẽ mất đi ý nghĩa.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义'),
  1,
  ARRAY['好的品质','不要','好','做好','一旦','没有','生存','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义'),
  2,
  ARRAY['事情','就','它','意义']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义'),
  3,
  ARRAY['成功','于','自己的','角色','轻易','越位','目标','害怕']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义'),
  4,
  ARRAY['松懈','精神上的','演','职责','内的','确定','死死地','竞争','失去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义'),
  5,
  ARRAY['追求','防止']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功酝酿于好的品质，不要松懈精神上的追求；演好自己的角色，做好职责内的事情，防止轻易越位；一旦确定目标，就死死地盯着它；不要害怕竞争，没有竞争，生存就失去了意义'),
  6,
  ARRAY['酝酿','盯着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸',
  'bù zhī dào shén me jiān nán kùn kǔ ， zhī zhī dào fēng yǔ wú zǔ ； bù zhī dào shén me bēi shāng wú zhù ， zhī zhī dào tiān wú jué lù ； bù zhī dào shén me shī bài cǎn chǔ ， zhī zhī dào áng shǒu kuò bù ； bù zhī dào shén me jīng jí mì bù ， zhī zhī dào yì rán zǒu qù - - chéng gōng ， jiù zài bǐ àn',
  'Không biết thế nào là gian nan khổ cực, chỉ biết bất kể mưa gió vẫn tiến bước; không biết thế nào là buồn bã tuyệt vọng, chỉ biết trời không bao giờ tuyệt đường; không biết thế nào là thất bại đau đớn, chỉ biết ngẩng cao đầu bước tới; không biết thế nào là gai góc đầy rẫy, chỉ biết quyết tâm bước đi -- thành công, đang chờ ở phía trước.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  1,
  ARRAY['不知道','什么','天','在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  2,
  ARRAY['知道','走去','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  3,
  ARRAY['只','风雨无阻','楚','成功']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  4,
  ARRAY['无助','无','绝路','失败','密布']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  5,
  ARRAY['艰难困苦','悲伤','彼岸']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  6,
  ARRAY['惨','昂首阔步','毅然']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道什么艰难困苦，只知道风雨无阻；不知道什么悲伤无助，只知道天无绝路；不知道什么失败惨楚，只知道昂首阔步；不知道什么荆棘密布，只知道毅然走去--成功，就在彼岸'),
  ARRAY['荆','棘']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样',
  'měi gè rén dōu yǒu jué de zì jǐ bú gòu hǎo ， xiàn mù bié rén shǎn shǎn fā guāng de shí hòu ， dàn qí shí dà duō rén dōu shì pǔ tōng de 。 bú yào jǔ sàng ， bú bì jīng huāng ， zuò nǔ lì pá de wō niú huò jiān chí fēi de bèn niǎo ， zài zuì píng fán de shēng huó lǐ ， qiān bēi hé nǔ lì 。 zǒng yǒu yì tiān ， nǐ huì zhàn zài zuì liàng de dì fāng ， huó chéng zì jǐ céng jīng kě wàng de mú yàng',
  'Mỗi người đều có lúc cảm thấy mình không đủ tốt, ngưỡng mộ sự tỏa sáng của người khác, nhưng thực tế hầu hết mọi người đều bình thường. Đừng nản lòng, đừng hoảng sợ, hãy là chú ốc sên kiên trì bò lên hoặc là chú chim vụng về nhưng không ngừng bay, trong cuộc sống bình dị nhất, hãy khiêm tốn và nỗ lực. Một ngày nào đó, bạn sẽ đứng ở nơi rực rỡ nhất, sống thành phiên bản mà mình từng khao khát.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样'),
  1,
  ARRAY['都','有','觉得','不够好','时候','大多','人','都是','不要','不必','做','的','飞的','在','生活','里','和','你','会','亮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样'),
  2,
  ARRAY['每个人','别人','但','蜗牛','最','站']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样'),
  3,
  ARRAY['自己','其实','努力','爬','或','鸟','平凡的','总有一天','地方','成','渴望的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样'),
  4,
  ARRAY['羡慕','普通的','惊慌','坚持','笨','活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样'),
  5,
  ARRAY['闪闪发光的','谦卑','曾经','模样']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有觉得自己不够好，羡慕别人闪闪发光的时候，但其实大多人都是普通的。不要沮丧，不必惊慌，做努力爬的蜗牛或坚持飞的笨鸟，在最平凡的生活里，谦卑和努力。总有一天，你会站在最亮的地方，活成自己曾经渴望的模样'),
  6,
  ARRAY['沮丧']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '后来才明白，要赚到足够令自己安心的钱，才能过上简单、安逸、自由的生活，才能让自己活得更有底气。所以，多花时间努力，少点工夫矫情',
  'hòu lái cái míng bái ， yào zhuàn dào zú gòu lìng zì jǐ ān xīn de qián ， cái néng guò shàng jiǎn dān 、 ān yì 、 zì yóu de shēng huó ， cái néng ràng zì jǐ huó dé gèng yǒu dǐ qì 。 suǒ yǐ ， duō huā shí jiān nǔ lì ， shǎo diǎn gōng fū jiǎo qíng',
  'Sau này mới hiểu, phải kiếm được đủ tiền để bản thân an tâm thì mới có thể sống một cuộc sống đơn giản, an nhàn và tự do, để mình sống có tự tin hơn. Vì vậy, hãy dành nhiều thời gian để nỗ lực và bớt đi những phút giây yếu đuối.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '后来才明白，要赚到足够令自己安心的钱，才能过上简单、安逸、自由的生活，才能让自己活得更有底气。所以，多花时间努力，少点工夫矫情'),
  1,
  ARRAY['后来','明白','钱','生活','有底','气','多花','时间','少','点','工夫']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '后来才明白，要赚到足够令自己安心的钱，才能过上简单、安逸、自由的生活，才能让自己活得更有底气。所以，多花时间努力，少点工夫矫情'),
  2,
  ARRAY['要','足够','过上','让','得','所以','矫情']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '后来才明白，要赚到足够令自己安心的钱，才能过上简单、安逸、自由的生活，才能让自己活得更有底气。所以，多花时间努力，少点工夫矫情'),
  3,
  ARRAY['才','自己','安心的','才能','简单','安逸','自由的','更','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '后来才明白，要赚到足够令自己安心的钱，才能过上简单、安逸、自由的生活，才能让自己活得更有底气。所以，多花时间努力，少点工夫矫情'),
  4,
  ARRAY['赚到','活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '后来才明白，要赚到足够令自己安心的钱，才能过上简单、安逸、自由的生活，才能让自己活得更有底气。所以，多花时间努力，少点工夫矫情'),
  5,
  ARRAY['令']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '一个不努力的人，别人想拉你一把，都找不到你的手在哪里',
  'yí gè bù nǔ lì de rén ， bié rén xiǎng lā nǐ yì bǎ ， dōu zhǎo bú dào nǐ de shǒu zài nǎ lǐ',
  'Một người không nỗ lực, người khác muốn giúp cũng chẳng biết tay bạn ở đâu mà kéo.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个不努力的人，别人想拉你一把，都找不到你的手在哪里'),
  1,
  ARRAY['一个','不','人','想','你','一把','都','你的','在哪里']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个不努力的人，别人想拉你一把，都找不到你的手在哪里'),
  2,
  ARRAY['别人','找不到','手']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个不努力的人，别人想拉你一把，都找不到你的手在哪里'),
  3,
  ARRAY['努力的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个不努力的人，别人想拉你一把，都找不到你的手在哪里'),
  4,
  ARRAY['拉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你',
  'jí yī ： ràng nǔ lì pèi dé shàng nǐ de mèng xiǎng rú guǒ yǒu yì tiān ， dāng nǐ de nǔ lì pèi dé shàng nǐ de mèng xiǎng ， nà me ， nǐ de mèng xiǎng yě jué duì bú huì gū fù nǐ de nǔ lì 。 ràng zì jǐ jǐn kě néng biàn de yōu xiù ， dāng nǐ duì yí jiàn shì qíng pīn mìng nǔ lì de shí hòu ， quán shì jiè dōu huì bāng nǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你'),
  1,
  ARRAY['一','你的','有一天','那么','不会','你','对','一件事','时候','都会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你'),
  2,
  ARRAY['让','也','情','帮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你'),
  3,
  ARRAY['努力','如果','当','自己','变得','努力的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你'),
  4,
  ARRAY['梦想','绝对','尽可能','优秀','全世界']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你'),
  5,
  ARRAY['辑','配得上','拼命']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '辑一：让努力配得上你的梦想如果有一天，当你的努力配得上你的梦想，那么，你的梦想也绝对不会辜负你的努力。让自己尽可能变得优秀，当你对一件事情拼命努力的时候，全世界都会帮你'),
  6,
  ARRAY['辜负']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第一封信: 从今天开始，每天微笑吧，世上除了生死，都是小事。不管遇到了多么烦心事，都不要自己为难自己；无论今天发生什么糟糕的事，都不应该感到悲伤。今天是你往后日子里最年轻的一天了，因为有明天今天永远只是起跑线',
  'xiě gěi zì jǐ de dì yī fēng xìn :   cóng jīn tiān kāi shǐ ， měi tiān wēi xiào ba ， shì shàng chú le shēng sǐ ， dōu shì xiǎo shì 。 bù guǎn yù dào le duō me fán xīn shì ， dōu bú yào zì jǐ wéi nán zì jǐ ； wú lùn jīn tiān fā shēng shén me zāo gāo de shì ， dōu bú yīng gāi gǎn dào bēi shāng 。 jīn tiān shì nǐ wǎng hòu rì zi lǐ zuì nián qīng de yì tiān le ， yīn wèi yǒu míng tiān jīn tiān yǒng yuǎn zhǐ shì qǐ pǎo xiàn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第一封信: 从今天开始，每天微笑吧，世上除了生死，都是小事。不管遇到了多么烦心事，都不要自己为难自己；无论今天发生什么糟糕的事，都不应该感到悲伤。今天是你往后日子里最年轻的一天了，因为有明天今天永远只是起跑线'),
  1,
  ARRAY['写给','天开','生死','都是','小事','不管','了','多么','都','不要','今天','什么','不','是','你','一天','有','明天','起跑线']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第一封信: 从今天开始，每天微笑吧，世上除了生死，都是小事。不管遇到了多么烦心事，都不要自己为难自己；无论今天发生什么糟糕的事，都不应该感到悲伤。今天是你往后日子里最年轻的一天了，因为有明天今天永远只是起跑线'),
  2,
  ARRAY['第一封','从今','始','每天','吧','事','为难','往后','日子里','最年轻的','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第一封信: 从今天开始，每天微笑吧，世上除了生死，都是小事。不管遇到了多么烦心事，都不要自己为难自己；无论今天发生什么糟糕的事，都不应该感到悲伤。今天是你往后日子里最年轻的一天了，因为有明天今天永远只是起跑线'),
  3,
  ARRAY['自己的','信','世上','除了','遇到','自己','发生','应该','感到','只是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第一封信: 从今天开始，每天微笑吧，世上除了生死，都是小事。不管遇到了多么烦心事，都不要自己为难自己；无论今天发生什么糟糕的事，都不应该感到悲伤。今天是你往后日子里最年轻的一天了，因为有明天今天永远只是起跑线'),
  4,
  ARRAY['微笑','烦心','无论','永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第一封信: 从今天开始，每天微笑吧，世上除了生死，都是小事。不管遇到了多么烦心事，都不要自己为难自己；无论今天发生什么糟糕的事，都不应该感到悲伤。今天是你往后日子里最年轻的一天了，因为有明天今天永远只是起跑线'),
  5,
  ARRAY['糟糕的','悲伤']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第二封信:  人生，总会有不期而遇的温暖，和生生不息的希望。不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福',
  'xiě gěi zì jǐ de dì èr fēng xìn :     rén shēng ， zǒng huì yǒu bù qī ér yù de wēn nuǎn ， hé shēng shēng bù xī de xī wàng 。 bù guǎn qián fāng de lù yǒu duō kǔ ， zhǐ yào zǒu de fāng xiàng zhèng què ， bù guǎn duō me qí qū bù píng ， dōu bǐ zhàn zài yuán dì gèng jiē jìn xìng fú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第二封信:  人生，总会有不期而遇的温暖，和生生不息的希望。不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福'),
  1,
  ARRAY['写给','人生','有','不期而遇','的','和','生生不息','不管','前方','多','多么','崎岖不平','都','在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第二封信:  人生，总会有不期而遇的温暖，和生生不息的希望。不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福'),
  2,
  ARRAY['第二','希望','路','走','正确','比','站']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第二封信:  人生，总会有不期而遇的温暖，和生生不息的希望。不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福'),
  3,
  ARRAY['自己的','总会','只要','方向','更接近']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第二封信:  人生，总会有不期而遇的温暖，和生生不息的希望。不管前方的路有多苦，只要走的方向正确，不管多么崎岖不平，都比站在原地更接近幸福'),
  4,
  ARRAY['封信','温暖','苦','原地','幸福']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现',
  'xiě gěi zì jǐ de dì sān fēng xìn :   nǐ shì gè yào qiáng de rén ， shí shí kè kè yāo qiú zì jǐ zuò dào bǎi fēn zhī bǎi de chāo chū qī wàng zhí 。 dàn shì kē qiú bìng bú shì gè hǎo xiàn xiàng ， nǐ bìng bú shì tiān cái ， qǐng yǔn xǔ zì jǐ fàn cuò 。 bú yào tài zháo jí ， nǐ de nǔ lì ， shí jiān dōu huì bāng nǐ duì xiàn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现'),
  1,
  ARRAY['写给','你','是','个','的','人','时时刻刻','期望值','好','现象','天才','请允许','不要','太','你的','时间','都会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现'),
  2,
  ARRAY['第三','要强','要求','到','百分之百的','但是','着急','帮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现'),
  3,
  ARRAY['自己的','自己做','超出','苛求','自己','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现'),
  4,
  ARRAY['封信','并不是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现'),
  5,
  ARRAY['兑现']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第三封信: 你是个要强的人，时时刻刻要求自己做到百分之百的超出期望值。但是苛求并不是个好现象，你并不是天才，请允许自己犯错。不要太着急，你的努力，时间都会帮你兑现'),
  6,
  ARRAY['犯错']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第四封信:  时间在变，人也在变。生活是一场无法回放的绝版电影，有些事不管你如何努力，回不去就是回不去了。世界上最远的距离，不是爱，不是恨，而是熟悉的人，渐渐变得陌生',
  'xiě gěi zì jǐ de dì sì fēng xìn :     shí jiān zài biàn ， rén yě zài biàn 。 shēng huó shì yì chǎng wú fǎ huí fàng de jué bǎn diàn yǐng ， yǒu xiē shì bù guǎn nǐ rú hé nǔ lì ， huí bú qù jiù shì huí bú qù le 。 shì jiè shàng zuì yuǎn de jù lí ， bú shì ài ， bú shì hèn ， ér shì shú xī de rén ， jiàn jiàn biàn de mò shēng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第四封信:  时间在变，人也在变。生活是一场无法回放的绝版电影，有些事不管你如何努力，回不去就是回不去了。世界上最远的距离，不是爱，不是恨，而是熟悉的人，渐渐变得陌生'),
  1,
  ARRAY['写给','时间','在','人','生活','是','一场','回放','的','电影','有些','不管','你','回','不去','了','不是','爱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第四封信:  时间在变，人也在变。生活是一场无法回放的绝版电影，有些事不管你如何努力，回不去就是回不去了。世界上最远的距离，不是爱，不是恨，而是熟悉的人，渐渐变得陌生'),
  2,
  ARRAY['第四','也在','事','就是','最远的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第四封信:  时间在变，人也在变。生活是一场无法回放的绝版电影，有些事不管你如何努力，回不去就是回不去了。世界上最远的距离，不是爱，不是恨，而是熟悉的人，渐渐变得陌生'),
  3,
  ARRAY['自己的','变','如何','努力','世界上','而是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第四封信:  时间在变，人也在变。生活是一场无法回放的绝版电影，有些事不管你如何努力，回不去就是回不去了。世界上最远的距离，不是爱，不是恨，而是熟悉的人，渐渐变得陌生'),
  4,
  ARRAY['封信','无法','绝版','距离','熟悉的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第四封信:  时间在变，人也在变。生活是一场无法回放的绝版电影，有些事不管你如何努力，回不去就是回不去了。世界上最远的距离，不是爱，不是恨，而是熟悉的人，渐渐变得陌生'),
  5,
  ARRAY['恨','渐渐变得','陌生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第五封信:  很多时候你在奋力拼搏后未能获得你想要的，并不是因为你不配，而只是时机未到，你要做的，只是咬紧牙关，将如此努力的自己继续保持下去，仅此而已',
  'xiě gěi zì jǐ de dì wǔ fēng xìn :     hěn duō shí hòu nǐ zài fèn lì pīn bó hòu wèi néng huò dé nǐ xiǎng yào de ， bìng bú shì yīn wèi nǐ bú pèi ， ér zhǐ shì shí jī wèi dào ， nǐ yào zuò de ， zhī shì yǎo jǐn yá guān ， jiāng rú cǐ nǔ lì de zì jǐ jì xù bǎo chí xià qù ， jǐn cǐ ér yǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第五封信:  很多时候你在奋力拼搏后未能获得你想要的，并不是因为你不配，而只是时机未到，你要做的，只是咬紧牙关，将如此努力的自己继续保持下去，仅此而已'),
  1,
  ARRAY['写给','很多','时候','你','在','后','想要','的','不配','时机','做','下去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第五封信:  很多时候你在奋力拼搏后未能获得你想要的，并不是因为你不配，而只是时机未到，你要做的，只是咬紧牙关，将如此努力的自己继续保持下去，仅此而已'),
  2,
  ARRAY['第五','因为','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第五封信:  很多时候你在奋力拼搏后未能获得你想要的，并不是因为你不配，而只是时机未到，你要做的，只是咬紧牙关，将如此努力的自己继续保持下去，仅此而已'),
  3,
  ARRAY['自己的','而','只是','如此','努力的','自己','而已']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第五封信:  很多时候你在奋力拼搏后未能获得你想要的，并不是因为你不配，而只是时机未到，你要做的，只是咬紧牙关，将如此努力的自己继续保持下去，仅此而已'),
  4,
  ARRAY['封信','奋力','获得','并不是','将','继续','保持','仅','此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第五封信:  很多时候你在奋力拼搏后未能获得你想要的，并不是因为你不配，而只是时机未到，你要做的，只是咬紧牙关，将如此努力的自己继续保持下去，仅此而已'),
  5,
  ARRAY['拼搏','未能','未到','咬紧牙关']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席',
  'xiě gěi zì jǐ de dì liù fēng xìn :   suǒ wèi qí jì ， dà gài dōu shì zhè yàng ba   - - - - -   qí jì bìng fēi shì shàng tiān cì yǔ mǒu rén yuán běn bú yìng huò dé de dōng xī ， ér shì duì yú qín fèn zhě shān shān lái chí de bāo jiǎng ， tā zhī huì chí dào ， què cóng bù quē xí',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席'),
  1,
  ARRAY['写给','大概','都是','这样','是','上天','不','的','东西','对于','姗姗来迟','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席'),
  2,
  ARRAY['第六','所谓','吧','它','从不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席'),
  3,
  ARRAY['自己的','奇迹','应','而是','者','只','迟到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席'),
  4,
  ARRAY['封信','并非','原本','获得','褒奖','却','缺席']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席'),
  5,
  ARRAY['某人','勤奋']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第六封信: 所谓奇迹，大概都是这样吧 ----- 奇迹并非是上天赐予某人原本不应获得的东西，而是对于勤奋者姗姗来迟的褒奖，它只会迟到，却从不缺席'),
  6,
  ARRAY['赐予']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活',
  'xiě gěi zì jǐ de dì qī fēng xìn :   gōng qí jùn zài tā de diàn yǐng lǐ shuō ： " wǒ shǐ zhōng xiāng xìn ， zài zhè ge shì jiè shàng ， yí dìng yǒu lìng yí gè zì jǐ ， zài zuò zhe wǒ bù gǎn zuò de shì ， zài guò zhe wǒ bù gǎn guò de shēng huó 。 " qí shí wǒ men měi gè rén dōu shì lìng yí gè zì jǐ ， zhǐ yào wǒ men yuàn yì ， jiù měi yǒu wǒ men bù gǎn zuò de shì ， méi yǒu wǒ men guò bú shàng de shēng huó',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活'),
  1,
  ARRAY['写给','在','他的','电影','里','说','我','这个','一定','有','做','不敢','的','生活','我们','都是','没有','不','上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活'),
  2,
  ARRAY['第七','始终','着','事','过着','过','每个人','就','每']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活'),
  3,
  ARRAY['自己的','相信','世界上','自己','其实','只要','愿意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活'),
  4,
  ARRAY['封信','另一个']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活'),
  6,
  ARRAY['宫崎']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第七封信: 宫崎骏在他的电影里说："我始终相信，在这个世界上，一定有另一个自己，在做着我不敢做的事，在过着我不敢过的生活。"其实我们每个人都是另一个自己，只要我们愿意，就每有我们不敢做的事，没有我们过不上的生活'),
  ARRAY['骏']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的',
  'xiě gěi zì jǐ de dì bā fēng xìn :   huò xǔ nǐ gǎn jué zì jǐ yì wú suǒ yǒu ， huò xǔ nǐ huì xiàn mù shàng sī de fáng zi ， chē zi ， xué jiě men de zuàn shí ěr dīng 。 qí shí nǐ bú yòng xiàn mù zhè xiē ， zhǐ yào nǔ lì ， suǒ yǒu de yí qiè ， suì yuè dōu huì dài gěi nǐ 。 ér nǐ de nián qīng suì yuè ， què shì tā men zài yě wú fǎ yōng yǒu de',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的'),
  1,
  ARRAY['写给','你','一无所有','会','上司','的','车子','学','姐','们','不用','这些','一切','岁月','都会','你的','年轻','是','他们','再也']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的'),
  2,
  ARRAY['第八','房子','所有的','给你']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的'),
  3,
  ARRAY['自己的','或许','感觉','自己','耳','其实','只要','努力','带','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的'),
  4,
  ARRAY['封信','羡慕','却','无法']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的'),
  5,
  ARRAY['拥有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第八封信: 或许你感觉自己一无所有，或许你会羡慕上司的房子，车子，学姐们的钻石耳钉。其实你不用羡慕这些，只要努力，所有的一切，岁月都会带给你。而你的年轻岁月，却是他们再也无法拥有的'),
  6,
  ARRAY['钻石','钉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第九封信:  你现在的结果，都是你以前的种种行为造成的。如果你讨厌自己的现在，更应该反思一下自己。因为每一个你不满意的现在，都有一个不努力的曾经',
  'xiě gěi zì jǐ de dì jiǔ fēng xìn :     nǐ xiàn zài de jié guǒ ， dōu shì nǐ yǐ qián de zhǒng zhǒng xíng wèi zào chéng de 。 rú guǒ nǐ tǎo yàn zì jǐ de xiàn zài ， gèng yīng gāi fǎn sī yí xià zì jǐ 。 yīn wèi měi yí gè nǐ bù mǎn yì de xiàn zài ， dōu yǒu yí gè bù nǔ lì de céng jīng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第九封信:  你现在的结果，都是你以前的种种行为造成的。如果你讨厌自己的现在，更应该反思一下自己。因为每一个你不满意的现在，都有一个不努力的曾经'),
  1,
  ARRAY['写给','你','现在的','都是','的','现在','一下','不满','都','有','一个','不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第九封信:  你现在的结果，都是你以前的种种行为造成的。如果你讨厌自己的现在，更应该反思一下自己。因为每一个你不满意的现在，都有一个不努力的曾经'),
  2,
  ARRAY['第九','以前的','因为','每一个','意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第九封信:  你现在的结果，都是你以前的种种行为造成的。如果你讨厌自己的现在，更应该反思一下自己。因为每一个你不满意的现在，都有一个不努力的曾经'),
  3,
  ARRAY['自己的','结果','种种','行为','如果','更','应该','自己','努力的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第九封信:  你现在的结果，都是你以前的种种行为造成的。如果你讨厌自己的现在，更应该反思一下自己。因为每一个你不满意的现在，都有一个不努力的曾经'),
  4,
  ARRAY['封信','讨厌','反思']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第九封信:  你现在的结果，都是你以前的种种行为造成的。如果你讨厌自己的现在，更应该反思一下自己。因为每一个你不满意的现在，都有一个不努力的曾经'),
  5,
  ARRAY['造成','曾经']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第十封信: 年轻正是吃苦的时候，正是发奋努力的时候。你一定要相信，每一个发奋努力的背后，必有加倍的奖赏。今天的生活是由三年前确定的，但是如果你今天还过着和三年前一样的生活，那么三年后的你仍将如此',
  'xiě gěi zì jǐ de dì shí fēng xìn :   nián qīng zhèng shì chī kǔ de shí hòu ， zhèng shì fā fèn nǔ lì de shí hòu 。 nǐ yí dìng yào xiāng xìn ， měi yí gè fā fèn nǔ lì de bèi hòu ， bì yǒu jiā bèi de jiǎng shǎng 。 jīn tiān de shēng huó shì yóu sān nián qián què dìng de ， dàn shì rú guǒ nǐ jīn tiān hái guò zhe hé sān nián qián yí yàng de shēng huó ， nà me sān nián hòu de nǐ réng jiāng rú cǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十封信: 年轻正是吃苦的时候，正是发奋努力的时候。你一定要相信，每一个发奋努力的背后，必有加倍的奖赏。今天的生活是由三年前确定的，但是如果你今天还过着和三年前一样的生活，那么三年后的你仍将如此'),
  1,
  ARRAY['写给','年轻','吃苦','的','时候','你','一定要','有加','今天','生活','是','三年','前','和','前一','样','那么','后的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十封信: 年轻正是吃苦的时候，正是发奋努力的时候。你一定要相信，每一个发奋努力的背后，必有加倍的奖赏。今天的生活是由三年前确定的，但是如果你今天还过着和三年前一样的生活，那么三年后的你仍将如此'),
  2,
  ARRAY['第十','正是','每一个','但是','还','过着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十封信: 年轻正是吃苦的时候，正是发奋努力的时候。你一定要相信，每一个发奋努力的背后，必有加倍的奖赏。今天的生活是由三年前确定的，但是如果你今天还过着和三年前一样的生活，那么三年后的你仍将如此'),
  3,
  ARRAY['自己的','发奋','努力的','相信','必','如果','如此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十封信: 年轻正是吃苦的时候，正是发奋努力的时候。你一定要相信，每一个发奋努力的背后，必有加倍的奖赏。今天的生活是由三年前确定的，但是如果你今天还过着和三年前一样的生活，那么三年后的你仍将如此'),
  4,
  ARRAY['封信','倍','奖赏','由','确定的','仍','将']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十封信: 年轻正是吃苦的时候，正是发奋努力的时候。你一定要相信，每一个发奋努力的背后，必有加倍的奖赏。今天的生活是由三年前确定的，但是如果你今天还过着和三年前一样的生活，那么三年后的你仍将如此'),
  5,
  ARRAY['背后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去',
  'xiě gěi zì jǐ de dì shí yī fēng xìn :     qí shí fèn dòu jiù shì měi tiān tā tā shi shí dì guò hǎo rì zi ， zuò hǎo shǒu tóu de měi jiàn xiǎo shì ， bù tuō lā ， bú bào yuàn ， bù tuī xiè ， bù tōu lǎn 。 měi yì tiān yì diǎn yì dī de nǔ lì ， cái néng huì jí qǐ qiān wàn yǒng qì ， dài zhe nǐ de jiān chí ， yǐn lǐng nǐ dào nǐ xiǎng yào dào de dì fāng qù',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去'),
  1,
  ARRAY['写给','好日子','做好','的','小事','不','一点一滴','起','你的','你','想要','去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去'),
  2,
  ARRAY['第十一','就是','每天','过','手头','每件','每一天','千万','着','到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去'),
  3,
  ARRAY['自己的','其实','地','努力','才能','带','地方']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去'),
  4,
  ARRAY['封信','奋斗','抱怨','推卸','勇气','坚持','引领']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去'),
  5,
  ARRAY['偷懒','汇集']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '写给自己的第十一封信:  其实奋斗就是每天踏踏实实地过好日子，做好手头的每件小事，不拖拉，不抱怨，不推卸，不偷懒。每一天一点一滴的努力，才能汇集起千万勇气，带着你的坚持，引领你到你想要到的地方去'),
  6,
  ARRAY['踏踏实实','拖拉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来',
  'měi yí gè nǔ lì de rén dōu néng zài suì yuè zhōng pò jiǎn chéng dié ， nǐ yào xiāng xìn ， yǒu yì tiān nǐ jiāng pò yǒng ér chū ， chéng zhǎng dé bǐ rén men qī dài de hái yào měi lì ， dàn zhè ge guò chéng huì hěn tòng ， huì hěn xīn kǔ ， yǒu shí hòu hái huì jué de huī xīn 。 miàn duì zhe xiōng yǒng ér lái de xiàn shí ， jué de zì jǐ miǎo xiǎo wú lì ， dàn zhè yě shì shēng mìng de yí bù fen 。 zuò hǎo xiàn zài nǐ néng zuò de ， rán hòu ， yí qiè dōu huì hǎo qǐ lái',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  1,
  ARRAY['人','都','能','在','岁月','中','你','有一天','你将','出','人们','期待的','这个','会','很','有时候','觉得','面对着','来','的','现实','这','生命的','一部分','做好','现在','做','一切都','好起来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  2,
  ARRAY['每一个','要','得','比','还要','但','过程','还','也是','然后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  3,
  ARRAY['努力的','成','相信','而','成长','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  4,
  ARRAY['破','破蛹','美丽','辛苦','无力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  5,
  ARRAY['蝶','痛','灰心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  6,
  ARRAY['汹涌','渺小']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个努力的人都能在岁月中破茧成蝶，你要相信，有一天你将破蛹而出，成长得比人们期待的还要美丽，但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力，但这也是生命的一部分。做好现在你能做的，然后，一切都会好起来'),
  ARRAY['茧']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己',
  'měi gè chéng gōng de rén zài chéng gōng zhī qián ， nán miǎn dōu huì yǒu yí duàn àn dàn de shí guāng 。 cǐ shí ， nǐ wú xū hài pà ， yě wú xū dǎn qiè ， zhī xū nǔ lì cháo zhe zì jǐ de mù biāo dà bù mài jìn ， rán hòu zài fù chū qiáng yú yǐ wǎng sān bèi de nǔ lì ， ruò gān nián hòu ， nǐ yí dìng huì chāo yuè xiàn zài de zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己'),
  1,
  ARRAY['人','在','都会','有','一段','的','时光','你','大步','再','三倍的','年','后','一定','会','现在的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己'),
  2,
  ARRAY['每个','也','然后','以往']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己'),
  3,
  ARRAY['成功的','成功','难免','害怕','只需','努力','自己的','目标','超越','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己'),
  4,
  ARRAY['之前','此时','无须','付出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己'),
  5,
  ARRAY['黯淡','胆怯','朝着','强于']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个成功的人在成功之前，难免都会有一段黯淡的时光。此时，你无须害怕，也无须胆怯，只需努力朝着自己的目标大步迈进，然后再付出强于以往三倍的努力，若干年后，你一定会超越现在的自己'),
  6,
  ARRAY['迈进','若干']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花',
  'měi yí gè yōu xiù de rén ， dōu huì yǒu yí duàn chén mò de shí guāng ， bú bào yuàn 、 bù zé nàn ， bú duàn nǔ lì ， rěn shòu zhe hēi yè de gū dú yǔ jì mò ， jiān xìn zài hēi àn zhōng yě néng shèng kāi chū zuì hǎo de huā',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花'),
  1,
  ARRAY['人','都会','有','一段','时光','不','不断','的','在黑暗中','能','出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花'),
  2,
  ARRAY['每一个','着','黑夜','也','最好的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花'),
  3,
  ARRAY['努力','花']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花'),
  4,
  ARRAY['优秀的','抱怨','责难','与','坚信']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花'),
  5,
  ARRAY['沉默的','忍受','寂寞']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一个优秀的人，都会有一段沉默的时光，不抱怨、不责难，不断努力，忍受着黑夜的孤独与寂寞，坚信在黑暗中也能盛开出最好的花'),
  6,
  ARRAY['孤独','盛开']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你现在还很年轻，完全没有必要因为你的衣服不如别人，包不是名牌，或者存款还不到五位数而觉得不安。因为每一个人都是这样过来的，你自己才是一切的根源，要想改变人生，首先要改变自己',
  'nǐ xiàn zài hái hěn nián qīng ， wán quán méi yǒu bì yào yīn wèi nǐ de yī fu bù rú bié rén ， bāo bú shì míng pái ， huò zhě cún kuǎn hái bú dào wǔ wèi shù ér jué de bù ān 。 yīn wèi měi yí gè rén dōu shì zhè yàng guò lái de ， nǐ zì jǐ cái shì yí qiè de gēn yuán ， yào xiǎng gǎi biàn rén shēng ， shǒu xiān yào gǎi biàn zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你现在还很年轻，完全没有必要因为你的衣服不如别人，包不是名牌，或者存款还不到五位数而觉得不安。因为每一个人都是这样过来的，你自己才是一切的根源，要想改变人生，首先要改变自己'),
  1,
  ARRAY['你','现在还','很','年轻','没有必要','你的','衣服','不如','不是','名牌','不到','五','觉得','不安','都是','这样','的','你自己','一切的','想','人生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你现在还很年轻，完全没有必要因为你的衣服不如别人，包不是名牌，或者存款还不到五位数而觉得不安。因为每一个人都是这样过来的，你自己才是一切的根源，要想改变人生，首先要改变自己'),
  2,
  ARRAY['完全','因为','别人','还','每一个人','过来','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你现在还很年轻，完全没有必要因为你的衣服不如别人，包不是名牌，或者存款还不到五位数而觉得不安。因为每一个人都是这样过来的，你自己才是一切的根源，要想改变人生，首先要改变自己'),
  3,
  ARRAY['包','或者','位数','而','才是','根源','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你现在还很年轻，完全没有必要因为你的衣服不如别人，包不是名牌，或者存款还不到五位数而觉得不安。因为每一个人都是这样过来的，你自己才是一切的根源，要想改变人生，首先要改变自己'),
  4,
  ARRAY['存款','改变','首先']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取',
  'zòng shǐ nǐ tiān shēng jiù ná dào yí fù hǎo pái ， yě bù néng bǎo zhèng nǐ rén shēng de qí jú huì bù bù shùn chàng ， yě wèi bì néng bǎo zhèng nǐ zài shēng huó de bó yì zhōng wěn cāo shèng quàn 。 hǎo de rén shēng qí jú ， yào kào zì jǐ bù bù wéi yíng ， nǔ lì qù zhēng qǔ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取'),
  1,
  ARRAY['你','天生','一副','好','能','人生','的','会','在','生活的','中','好的','去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取'),
  2,
  ARRAY['就','也不','步步','也','要','步步为营']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取'),
  3,
  ARRAY['拿到','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取'),
  4,
  ARRAY['牌','保证','顺畅','博弈','争取']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取'),
  5,
  ARRAY['棋局','未必','稳操胜券','靠自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '纵使你天生就拿到一副好牌，也不能保证你人生的棋局会步步顺畅，也未必能保证你在生活的博弈中稳操胜券。好的人生棋局，要靠自己步步为营，努力去争取'),
  6,
  ARRAY['纵使']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '所有的成功，都来自于不倦的努力和奔跑；所有幸福，都来自平凡的奋斗和坚持，你无法找到捷径',
  'suǒ yǒu de chéng gōng ， dōu lái zì yú bú juàn de nǔ lì hé bēn pǎo ； suǒ yǒu xìng fú ， dōu lái zì píng fán de fèn dòu hé jiān chí ， nǐ wú fǎ zhǎo dào jié jìng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有的成功，都来自于不倦的努力和奔跑；所有幸福，都来自平凡的奋斗和坚持，你无法找到捷径'),
  1,
  ARRAY['都','来自','不倦','的','和','你']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有的成功，都来自于不倦的努力和奔跑；所有幸福，都来自平凡的奋斗和坚持，你无法找到捷径'),
  2,
  ARRAY['所有的','所有','找到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有的成功，都来自于不倦的努力和奔跑；所有幸福，都来自平凡的奋斗和坚持，你无法找到捷径'),
  3,
  ARRAY['成功','于','努力','平凡的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有的成功，都来自于不倦的努力和奔跑；所有幸福，都来自平凡的奋斗和坚持，你无法找到捷径'),
  4,
  ARRAY['幸福','奋斗','坚持','无法']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有的成功，都来自于不倦的努力和奔跑；所有幸福，都来自平凡的奋斗和坚持，你无法找到捷径'),
  6,
  ARRAY['奔跑','捷径']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行',
  'rén shēng lù shang huì yǒu měi lì de fēng jǐng děng dài wǒ men qù xīn shǎng ， gāi lái de bú yào duǒ shǎn ， gāi qù de bú yào jiū chán ， gāi zuò de yǒng yú dān dāng ； bǎ gāi fàng qì de ràng tā suí fēng ér qù ， bú yào zhuā zhù bú fàng ； bǎ gāi liú xià de cáng zài jì yì shēn chù ， chén fēng qǐ lái ； bǎ céng jīng de kǎn kě hé mó nàn chén diàn chéng zhēn guì de cái fù ， biān cè wǒ men qián xíng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  1,
  ARRAY['人生路','上','会','有','我们','去','来','的','不要','做','不','在','起来','和','前行']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  2,
  ARRAY['等待','让','它']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  3,
  ARRAY['风景','该','担当','把','放弃的','而','放','留下','记忆','成']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  4,
  ARRAY['美丽的','勇于','随风','深处']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  5,
  ARRAY['欣赏','躲闪','抓住','藏','尘封','曾经','沉淀','珍贵的','财富','鞭策']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  6,
  ARRAY['纠缠','磨难']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生路上会有美丽的风景等待我们去欣赏，该来的不要躲闪，该去的不要纠缠，该做的勇于担当；把该放弃的让它随风而去，不要抓住不放；把该留下的藏在记忆深处，尘封起来；把曾经的坎坷和磨难沉淀成珍贵的财富，鞭策我们前行'),
  ARRAY['坎','坷']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '如果黑暗和光明让你去选择，你最好选择相信光明，因为光明会让你看见希望，而黑暗里永远只有绝望。即便你从未看见过光明，你也要选择相信，在信仰里活着不会让你的生活处处只是一潭死水',
  'rú guǒ hēi àn hé guāng míng ràng nǐ qù xuǎn zé ， nǐ zuì hǎo xuǎn zé xiāng xìn guāng míng ， yīn wèi guāng míng huì ràng nǐ kàn jiàn xī wàng ， ér hēi àn lǐ yǒng yuǎn zhǐ yǒu jué wàng 。 jí biàn nǐ cóng wèi kàn jiàn guò guāng míng ， nǐ yě yào xuǎn zé xiāng xìn ， zài xìn yǎng lǐ huó zhe bú huì ràng nǐ de shēng huó chù chù zhǐ shì yì tán sǐ shuǐ',
  'Nếu phải chọn giữa bóng tối và ánh sáng, bạn nên chọn tin vào ánh sáng, vì ánh sáng sẽ giúp bạn nhìn thấy hy vọng, còn trong bóng tối chỉ có tuyệt vọng. Dù bạn chưa từng thấy ánh sáng, bạn vẫn phải chọn tin tưởng. Sống trong niềm tin sẽ không để cuộc sống của bạn trở nên tù túng và nhàm chán.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果黑暗和光明让你去选择，你最好选择相信光明，因为光明会让你看见希望，而黑暗里永远只有绝望。即便你从未看见过光明，你也要选择相信，在信仰里活着不会让你的生活处处只是一潭死水'),
  1,
  ARRAY['和','你','去','会','你看','见','里','看见','在','不会','你的','生活','一潭死水']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果黑暗和光明让你去选择，你最好选择相信光明，因为光明会让你看见希望，而黑暗里永远只有绝望。即便你从未看见过光明，你也要选择相信，在信仰里活着不会让你的生活处处只是一潭死水'),
  2,
  ARRAY['黑暗','让','最好','因为','希望','从未','过','也','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果黑暗和光明让你去选择，你最好选择相信光明，因为光明会让你看见希望，而黑暗里永远只有绝望。即便你从未看见过光明，你也要选择相信，在信仰里活着不会让你的生活处处只是一潭死水'),
  3,
  ARRAY['如果','选择','相信','而','只有','信仰','只是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果黑暗和光明让你去选择，你最好选择相信光明，因为光明会让你看见希望，而黑暗里永远只有绝望。即便你从未看见过光明，你也要选择相信，在信仰里活着不会让你的生活处处只是一潭死水'),
  4,
  ARRAY['光明','永远','绝望','即便','活着','处处']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '永不要羡慕那些生而富贵的人。物质世界无穷尽，最重要的不是拥有什么，而是努力改善，使生活充满希望，使生命每天向上。不要求你有钱，但是要答应我，明年，下个月，明天，都比现在多一点',
  'yǒng bú yào xiàn mù nà xiē shēng ér fù guì de rén 。 wù zhì shì jiè wú qióng jìn ， zuì zhòng yào de bú shì yōng yǒu shén me ， ér shì nǔ lì gǎi shàn ， shǐ shēng huó chōng mǎn xī wàng ， shǐ shēng mìng měi tiān xiàng shàng 。 bú yāo qiú nǐ yǒu qián ， dàn shì yào dā ying wǒ ， míng nián ， xià gè yuè ， míng tiān ， dōu bǐ xiàn zài duō yì diǎn',
  'Đừng bao giờ ghen tị với những người sinh ra đã giàu có. Thế giới vật chất là vô tận, điều quan trọng không phải là bạn có gì, mà là nỗ lực cải thiện để cuộc sống luôn tràn đầy hy vọng và ngày càng tiến bộ. Không cần bạn phải giàu có, nhưng hãy hứa với tôi rằng năm tới, tháng tới, hay ngày mai, bạn sẽ tốt hơn hiện tại dù chỉ một chút.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '永不要羡慕那些生而富贵的人。物质世界无穷尽，最重要的不是拥有什么，而是努力改善，使生活充满希望，使生命每天向上。不要求你有钱，但是要答应我，明年，下个月，明天，都比现在多一点'),
  1,
  ARRAY['那些','生','的','人','不是','什么','生活','生命','不要','你有','钱','我','明年','下','个','月','明天','都','现在','多','一点']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '永不要羡慕那些生而富贵的人。物质世界无穷尽，最重要的不是拥有什么，而是努力改善，使生活充满希望，使生命每天向上。不要求你有钱，但是要答应我，明年，下个月，明天，都比现在多一点'),
  2,
  ARRAY['要','最重要的','希望','每天','但是','比']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '永不要羡慕那些生而富贵的人。物质世界无穷尽，最重要的不是拥有什么，而是努力改善，使生活充满希望，使生命每天向上。不要求你有钱，但是要答应我，明年，下个月，明天，都比现在多一点'),
  3,
  ARRAY['而','物质','世界','而是','努力','向上','求','答应']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '永不要羡慕那些生而富贵的人。物质世界无穷尽，最重要的不是拥有什么，而是努力改善，使生活充满希望，使生命每天向上。不要求你有钱，但是要答应我，明年，下个月，明天，都比现在多一点'),
  4,
  ARRAY['永不','羡慕','富贵','无穷尽','改善','使']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '永不要羡慕那些生而富贵的人。物质世界无穷尽，最重要的不是拥有什么，而是努力改善，使生活充满希望，使生命每天向上。不要求你有钱，但是要答应我，明年，下个月，明天，都比现在多一点'),
  5,
  ARRAY['拥有','充满']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责',
  'rén shēng jiù shì yì chǎng wèi zhī de mào xiǎn ， méi yǒu rén huì shì xiān zhī dào jié jú 。 bié rén zhī huì zūn zhòng nǐ de xuǎn zé ， ér bú huì zài yì nǐ de xī shēng 。 suǒ yǐ ， bú yào yuàn tiān yóu rén ， ér yīng dāng lěng jìng dì miàn duì mù qián de zhuàng kuàng ， yòng xīn bìng qiě fù zé dì qù jiě jué xiàn zài de wèn tí 。 zhǐ yào néng duì zì jǐ de xiàn zài fù zé ， nà me wèi lái yě huì wèi nǐ fù zé',
  'Cuộc đời là một cuộc phiêu lưu đầy những điều chưa biết, không ai có thể đoán trước kết quả. Người khác chỉ tôn trọng sự lựa chọn của bạn, chứ không quan tâm đến những hy sinh bạn đã làm. Vì vậy, đừng trách trời trách người, hãy bình tĩnh đối mặt với hiện tại, và giải quyết vấn đề bằng cả trái tim và trách nhiệm. Chỉ cần bạn chịu trách nhiệm với hiện tại, tương lai sẽ không phụ bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责'),
  1,
  ARRAY['人生','一场','没有人','会','你的','不会','在意','不要','冷静地','面对','去','现在的','能','对','现在','那么','你']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责'),
  2,
  ARRAY['就是','事先','知道','别人','所以','问题','也','为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责'),
  3,
  ARRAY['冒险','结局','只','选择','而','应当','目前的','用心','解决','只要','自己的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责'),
  4,
  ARRAY['尊重','并且','负责地','负责']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责'),
  5,
  ARRAY['未知的','怨天尤人','状况','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场未知的冒险，没有人会事先知道结局。别人只会尊重你的选择，而不会在意你的牺牲。所以，不要怨天尤人，而应当冷静地面对目前的状况，用心并且负责地去解决现在的问题。只要能对自己的现在负责，那么未来也会为你负责'),
  6,
  ARRAY['牺牲']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '十年前你是谁，一年前你是谁，甚至昨天你是谁，都不重要。重要的是，今天你是谁，以及明天你将成为谁',
  'shí nián qián nǐ shì shuí ， yì nián qián nǐ shì shuí ， shèn zhì zuó tiān nǐ shì shuí ， dōu bú zhòng yào 。 zhòng yào de shì ， jīn tiān nǐ shì shuí ， yǐ jí míng tiān nǐ jiāng chéng wéi shuí',
  'Bạn là ai mười năm trước, một năm trước, hay thậm chí là hôm qua, đều không quan trọng. Điều quan trọng là hôm nay bạn là ai, và ngày mai bạn sẽ trở thành ai.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '十年前你是谁，一年前你是谁，甚至昨天你是谁，都不重要。重要的是，今天你是谁，以及明天你将成为谁'),
  1,
  ARRAY['十年','前','你是谁','一年','昨天','都','不重要','是','今天','明天','你将','谁']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '十年前你是谁，一年前你是谁，甚至昨天你是谁，都不重要。重要的是，今天你是谁，以及明天你将成为谁'),
  2,
  ARRAY['以及']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '十年前你是谁，一年前你是谁，甚至昨天你是谁，都不重要。重要的是，今天你是谁，以及明天你将成为谁'),
  3,
  ARRAY['重要的','成为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '十年前你是谁，一年前你是谁，甚至昨天你是谁，都不重要。重要的是，今天你是谁，以及明天你将成为谁'),
  4,
  ARRAY['甚至']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功',
  'rén shēng chù chù yǒu fēng jǐng ， hé bú shì shí tíng yi tíng ？ bù qǐ qiú yǔ shān diān guān rì yuè ， zhǐ shì yīn fēng wài hái yǒu fēng 。 rén shēng zhī lù shang méi yǒu shén me jiān nán de ， bǎ kùn nán dàng zuò yí zhèn fēng jiù hǎo le 。 wǒ jiān xìn ， zhǐ yào kěn nǔ lì ， wèi lái dìng huì chéng gōng',
  'Cuộc sống luôn có những cảnh đẹp ở khắp nơi, vậy tại sao không dừng lại một chút để thưởng thức? Không cần phải đứng trên đỉnh núi để ngắm mặt trời hay mặt trăng, vì ngoài đỉnh này vẫn còn những đỉnh khác. Trên con đường đời, không có gì là quá khó khăn, chỉ cần coi khó khăn như một cơn gió thoáng qua. Tôi tin rằng, chỉ cần bạn nỗ lực, tương lai chắc chắn sẽ thành công.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功'),
  1,
  ARRAY['人生','有','一','不','没有','什么','一阵风','好了','我','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功'),
  2,
  ARRAY['日月','因','外','还有','路上','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功'),
  3,
  ARRAY['风景','山巅','只是','把','当作','只要','努力','定','成功']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功'),
  4,
  ARRAY['处处','何不','适时','停','与','观','之','困难','坚信','肯']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功'),
  5,
  ARRAY['企求','艰难的','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生处处有风景，何不适时停一停？不企求与山巅观日月，只是因峰外还有峰。人生之路上没有什么艰难的，把困难当作一阵风就好了。我坚信，只要肯努力，未来定会成功'),
  6,
  ARRAY['峰']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动',
  'shí jiān de bù fá yǒu sān zhǒng ： wèi lái shān shān lái chí ， xiàn zài xiàng jiàn yì bān fēi shì ， guò qù yǒng yuǎn jìng lì bú dòng',
  'Thời gian có ba bước đi: Tương lai thì chậm chạp, hiện tại vụt qua như tên bay, còn quá khứ thì đứng yên vĩnh viễn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动'),
  1,
  ARRAY['时间的','有','三','姗姗来迟','现在','一般','飞逝','不动']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动'),
  2,
  ARRAY['步伐','过去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动'),
  3,
  ARRAY['种','像','静']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动'),
  4,
  ARRAY['永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动'),
  5,
  ARRAY['未来','立']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间的步伐有三种：未来姗姗来迟，现在像箭一般飞逝，过去永远静立不动'),
  6,
  ARRAY['箭']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '现在的你要是多学一样本事，以后的你就能少说一句求人的话',
  'xiàn zài de nǐ yào shi duō xué yí yàng běn shì ， yǐ hòu de nǐ jiù néng shǎo shuō yí jù qiú rén de huà',
  'Nếu bây giờ bạn học thêm một kỹ năng, thì trong tương lai, bạn sẽ ít phải nhờ vả người khác hơn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你要是多学一样本事，以后的你就能少说一句求人的话'),
  1,
  ARRAY['现在的','你','多','学','一样','本事','能','少说','一句','的话']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你要是多学一样本事，以后的你就能少说一句求人的话'),
  2,
  ARRAY['要是','以后的','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你要是多学一样本事，以后的你就能少说一句求人的话'),
  3,
  ARRAY['求人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来',
  'chuàng zào míng tiān de shì jīn tiān ， chuàng zào jiāng lái de shì yǎn qián ， dāng nǐ chī chī dì zuò děng jiāng lái de shí hòu ， jiāng lái jiù cóng nǐ lǎn duò de shuāng shǒu zhōng jī xíng chǒu lòu dì zǒu chū lái',
  'Hôm nay tạo nên ngày mai, và hiện tại tạo nên tương lai. Khi bạn ngồi chờ đợi tương lai một cách mơ màng, thì tương lai sẽ bị bóp méo và xấu xí từ đôi tay lười biếng của bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来'),
  1,
  ARRAY['明天','的是','今天','是','你','坐等','时候','中']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来'),
  2,
  ARRAY['眼前','就','从','走出来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来'),
  3,
  ARRAY['当','地','双手']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来'),
  4,
  ARRAY['将来的','将来','懒惰的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来'),
  5,
  ARRAY['创造','畸形','丑陋地']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '创造明天的是今天，创造将来的是眼前，当你痴痴地坐等将来的时候，将来就从你懒惰的双手中畸形丑陋地走出来'),
  ARRAY['痴']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动',
  'wú lùn hé shí ， xiàn zài zhǐ shì yí gè jiāo diǎn ， wèi guò qù yǔ wèi lái xiāng yù zhī chù ， wǒ men duì yú èr zhě dōu bù néng yǒu shén me jià dǎ 。 bù néng yǒu shì jiè ér wú chuán tǒng ， yì bù néng yǒu shēng mìng ér wú huó dòng',
  'Dù ở thời điểm nào, hiện tại chỉ là điểm giao nhau giữa quá khứ và tương lai, chúng ta không thể nào phủ nhận một trong hai. Không thể có thế giới mà thiếu truyền thống, cũng như không thể có sự sống mà không có hoạt động.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动'),
  1,
  ARRAY['现在','一个','我们','对于','二者','都','不能','有','什么','打','生命']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动'),
  2,
  ARRAY['为','过去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动'),
  3,
  ARRAY['只是','相遇','世界','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动'),
  4,
  ARRAY['无论何时','交点','与','之处','无','传统','无活动']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动'),
  5,
  ARRAY['未来','架']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '无论何时，现在只是一个交点，为过去与未来相遇之处，我们对于二者都不能有什么架打。不能有世界而无传统，亦不能有生命而无活动'),
  6,
  ARRAY['亦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守',
  'dāng nǐ lǎo le ， jiù zhù zài yí gè rén bù duō de xiǎo zhèn shàng 。 fáng qián zǎi huā wū hòu zhòng cài 。 méi yǒu wǎng luò 。 zì jǐ dòng shǒu zuò fàn 。 yǎng yì tiáo dà gǒu 。 měi tiān qí zì xíng chē ， sàn bù 。 jī hū bú yòng shǒu jī 。 bù dǎ rǎo bié rén ， yě bù xī wàng bèi dǎ rǎo 。 suǒ wèi de tiān huāng dì lǎo jiù shì zhè yàng le 。 yì chá ， yí fàn ， yì zhōu ， yí cài ， yǔ yì rén xiāng shǒu',
  'Khi bạn già đi, hãy sống ở một thị trấn nhỏ không đông đúc. Trồng hoa trước nhà và rau sau vườn. Không có mạng internet. Tự tay nấu ăn. Nuôi một chú chó lớn. Mỗi ngày đạp xe, đi dạo. Hầu như không dùng điện thoại. Không làm phiền người khác, và cũng không muốn bị làm phiền. Cái gọi là “trời đất già cỗi” chính là như vậy. Một tách trà, một bữa cơm, một bát cháo, một món ăn, và sống bên cạnh người bạn đời của mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守'),
  1,
  ARRAY['你','老了','住在','一个人','不多的','小镇','上','没有','做饭','一条','大','狗','几乎不','机','不','打扰','天荒地老','这样','了','一','茶','饭','菜','人相']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守'),
  2,
  ARRAY['就','房前','动手','每天','别人','也不','希望','所谓的','就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守'),
  3,
  ARRAY['当','花','种菜','网络','自己','骑自行车','用手','被']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守'),
  4,
  ARRAY['养','散步','与']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守'),
  5,
  ARRAY['载','屋后','守']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你老了，就住在一个人不多的小镇上。房前载花屋后种菜。没有网络。自己动手做饭。养一条大狗。每天骑自行车，散步。几乎不用手机。不打扰别人，也不希望被打扰。所谓的天荒地老就是这样了。一茶，一饭，一粥，一菜，与一人相守'),
  6,
  ARRAY['粥']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情',
  'yǒu xiē gū niáng ， dú shū yě hǎo ， gōng zuò yě hǎo ， zhěng róng yě hǎo ， mù biāo zhǐ yǒu yí gè ， nà jiù shì wèi le jià gè hǎo nán rén 。 ér lìng yì xiē gū niáng ， zuò de suǒ yǒu shì qíng dōu zhǐ shì wèi le ràng zì jǐ biàn de gèng qiáng 。 yě xǔ qián zhě zài gāng kāi shǐ huì huó dé hěn hǎo ， dàn rén shēng hěn cháng ， màn màn jiù huì fā xiàn ， yī kào bié rén ， shǐ zhōng shì chǎng dǔ zhù 。 ér ràng zì jǐ biàn gēng hǎo ， nà cái shì yí bèi zi de shì qíng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情'),
  1,
  ARRAY['有些','读书','工作','一个','那就','是','个','好','些','做','的','都','前者','在','开始','会','人生','很','那','一辈子']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情'),
  2,
  ARRAY['也好','为了','男人','所有','事情','让','也许','得很','但','长','慢慢','就','别人','始终','场']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情'),
  3,
  ARRAY['目标','只有','而','只是','自己','变得','更','刚','发现','变更','才是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情'),
  4,
  ARRAY['整容','另一','活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情'),
  5,
  ARRAY['姑娘','嫁','强','依靠']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有些姑娘，读书也好，工作也好，整容也好，目标只有一个，那就是为了嫁个好男人。而另一些姑娘，做的所有事情都只是为了让自己变得更强。也许前者在刚开始会活得很好，但人生很长，慢慢就会发现，依靠别人，始终是场赌注。而让自己变更好，那才是一辈子的事情'),
  6,
  ARRAY['赌注']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当别人认定了你是错的，就算你冷静地解释了也会越描越黑，还会被认为是在狡辩。当别人对你万般的误会，你只能暂且默默忍受。只要做好自己的本分，用实力证明自己，时间会为你说话',
  'dāng bié rén rèn dìng le nǐ shì cuò de ， jiù suàn nǐ lěng jìng dì jiě shì le yě huì yuè miáo yuè hēi ， hái huì bèi rèn wèi shì zài jiǎo biàn 。 dāng bié rén duì nǐ wàn bān de wù huì ， nǐ zhǐ néng zàn qiě mò mò rěn shòu 。 zhǐ yào zuò hǎo zì jǐ de běn fèn ， yòng shí lì zhèng míng zì jǐ ， shí jiān huì wèi nǐ shuō huà',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当别人认定了你是错的，就算你冷静地解释了也会越描越黑，还会被认为是在狡辩。当别人对你万般的误会，你只能暂且默默忍受。只要做好自己的本分，用实力证明自己，时间会为你说话'),
  1,
  ARRAY['认定','了','你','是','的','冷静地','会','在','对','做好','本分','时间','说话']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当别人认定了你是错的，就算你冷静地解释了也会越描越黑，还会被认为是在狡辩。当别人对你万般的误会，你只能暂且默默忍受。只要做好自己的本分，用实力证明自己，时间会为你说话'),
  2,
  ARRAY['别人','错','就算','也','还','为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当别人认定了你是错的，就算你冷静地解释了也会越描越黑，还会被认为是在狡辩。当别人对你万般的误会，你只能暂且默默忍受。只要做好自己的本分，用实力证明自己，时间会为你说话'),
  3,
  ARRAY['当','解释','越描越黑','被认为是','万般','只能','只要','自己的','用','实力','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当别人认定了你是错的，就算你冷静地解释了也会越描越黑，还会被认为是在狡辩。当别人对你万般的误会，你只能暂且默默忍受。只要做好自己的本分，用实力证明自己，时间会为你说话'),
  4,
  ARRAY['误会','暂且','默默忍受','证明']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当别人认定了你是错的，就算你冷静地解释了也会越描越黑，还会被认为是在狡辩。当别人对你万般的误会，你只能暂且默默忍受。只要做好自己的本分，用实力证明自己，时间会为你说话'),
  5,
  ARRAY['狡辩']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '所有你曾经哭过的事，多少年之后，你一定会笑着说出来，然后骂自己一句：当初真的好傻，其实人生没有那么多的烦恼，时间会解决一切，好好爱自己',
  'suǒ yǒu nǐ céng jīng kū guò de shì ， duō shào nián zhī hòu ， nǐ yí dìng huì xiào zhe shuō chū lái ， rán hòu mà zì jǐ yí jù ： dāng chū zhēn de hǎo shǎ ， qí shí rén shēng méi yǒu nà me duō de fán nǎo ， shí jiān huì jiě jué yí qiè ， hǎo hǎo ài zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有你曾经哭过的事，多少年之后，你一定会笑着说出来，然后骂自己一句：当初真的好傻，其实人生没有那么多的烦恼，时间会解决一切，好好爱自己'),
  1,
  ARRAY['你','的','多少','年','一定','会','说出来','一句','好','人生','没有','那么多的','时间','一切','好好','爱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有你曾经哭过的事，多少年之后，你一定会笑着说出来，然后骂自己一句：当初真的好傻，其实人生没有那么多的烦恼，时间会解决一切，好好爱自己'),
  2,
  ARRAY['所有','过','事','笑着','然后','真的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有你曾经哭过的事，多少年之后，你一定会笑着说出来，然后骂自己一句：当初真的好傻，其实人生没有那么多的烦恼，时间会解决一切，好好爱自己'),
  3,
  ARRAY['哭','自己','当初','其实','解决']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有你曾经哭过的事，多少年之后，你一定会笑着说出来，然后骂自己一句：当初真的好傻，其实人生没有那么多的烦恼，时间会解决一切，好好爱自己'),
  4,
  ARRAY['之后','烦恼']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '所有你曾经哭过的事，多少年之后，你一定会笑着说出来，然后骂自己一句：当初真的好傻，其实人生没有那么多的烦恼，时间会解决一切，好好爱自己'),
  5,
  ARRAY['曾经','骂','傻']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详',
  'wǔ nián hòu de nǐ huì shì shén me yàng zi ， shuō chuān le jiù qǔ jué yú liǎng xiàng zuì zhòng yào de yīn sù ： yí gè shì nǐ yǔ nǎ xiē rén wéi wǔ ， lìng yí gè jiù shì nǐ dú nǎ xiē shū 。 wǒ men yīng gāi yāo qiú zì jǐ zhī shuō gāi shuō de huà ， shǎo shuō fèi huà shěng diǎn bǎo guì de nǎo lì ； yǒu jié zhì zhī jiǎng zhòng diǎn ， biǎo shì nǐ nǎo dài hěn qīng chǔ ， xīn líng hěn ān xiáng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详'),
  1,
  ARRAY['五','年','后的','你','会','是','什么样','子','说穿','了','一个','哪些','人为','读','书','我们','说','的话','少说','点','脑力','有节','脑袋','很']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详'),
  2,
  ARRAY['就','两','最重要的','因素','就是','要求','表示']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详'),
  3,
  ARRAY['应该','自己','只','该','只讲','重点','清楚','心灵','安详']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详'),
  4,
  ARRAY['取决于','与','另一个','省']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详'),
  5,
  ARRAY['项','废话','宝贵的','制']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '五年后的你会是什么样子，说穿了就取决于两项最重要的因素：一个是你与哪些人为伍，另一个就是你读哪些书。我们应该要求自己只说该说的话，少说废话省点宝贵的脑力；有节制只讲重点，表示你脑袋很清楚，心灵很安详'),
  6,
  ARRAY['伍']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持',
  'dāng nǐ hěn lèi hěn lèi de shí hòu ， nǐ yīng gāi bì shàng yǎn jīng zuò shēn hū xī ， gào sù zì jǐ nǐ yīng gāi jiān chí dé zhù ， bú yào shén me qīng yì dì fǒu dìng zì jǐ ， shuí shuō nǐ méi yǒu hǎo de wèi lái ， guān yú míng tiān de shì hòu tiān cái zhī dào ， zài yí qiē biàn hǎo zhī qián ， wǒ men zǒng yào jīng lì yì xiē bù kāi xīn de rì zi ， bú yào yīn wèi yì diǎn xiá cī ér fàng qì yí duàn jiān chí',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持'),
  1,
  ARRAY['你','很累很累','的','时候','坐','住','不要','什么','谁','说','没有','好的','关于','明天','天才','在','一切','我们','一些','不开心','一点','一段']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持'),
  2,
  ARRAY['眼睛','告诉','得','事后','知道','要','经历','日子','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持'),
  3,
  ARRAY['当','应该','自己','轻易地','变好','总','而','放弃']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持'),
  4,
  ARRAY['深呼吸','坚持','否定','之前']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持'),
  5,
  ARRAY['闭上','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛坐深呼吸，告诉自己你应该坚持得住，不要什么轻易地否定自己，谁说你没有好的未来，关于明天的事后天才知道，在一切变好之前，我们总要经历一些不开心的日子，不要因为一点暇疵而放弃一段坚持'),
  ARRAY['暇','疵']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '一辈子活下来，常常是，在最有意思的时候，没有有意思地过；在最没意思的时候，想要有意思地过结果，却再也过不出意思。或者，换一种表述就是，在看不透的时候，好看的人生过得不好看；看透了，想过得好看，可是人生已经没法看了',
  'yí bèi zi huó xià lái ， cháng cháng shì ， zài zuì yǒu yì sī de shí hòu ， méi yǒu yǒu yì sī dì guò ； zài zuì méi yì si de shí hòu ， xiǎng yào yǒu yì sī dì guò jié guǒ ， què zài yě guò bù chū yì sī 。 huò zhě ， huàn yì zhǒng biǎo shù jiù shì ， zài kàn bú tòu de shí hòu ， hǎo kàn de rén shēng guò dé bù hǎo kàn ； kàn tòu le ， xiǎng guò dé hǎo kàn ， kě shì rén shēng yǐ jīng méi fǎ kàn le',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一辈子活下来，常常是，在最有意思的时候，没有有意思地过；在最没意思的时候，想要有意思地过结果，却再也过不出意思。或者，换一种表述就是，在看不透的时候，好看的人生过得不好看；看透了，想过得好看，可是人生已经没法看了'),
  1,
  ARRAY['一辈子','是','在','有意思','的','时候','没有','有意思地','没意思','想要','再也','不','出','一种','看','好看的','人生','不好看','看透','了','想','没法']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一辈子活下来，常常是，在最有意思的时候，没有有意思地过；在最没意思的时候，想要有意思地过结果，却再也过不出意思。或者，换一种表述就是，在看不透的时候，好看的人生过得不好看；看透了，想过得好看，可是人生已经没法看了'),
  2,
  ARRAY['常常','最','过','意思','表述','就是','得','过得好','可是','已经']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一辈子活下来，常常是，在最有意思的时候，没有有意思地过；在最没意思的时候，想要有意思地过结果，却再也过不出意思。或者，换一种表述就是，在看不透的时候，好看的人生过得不好看；看透了，想过得好看，可是人生已经没法看了'),
  3,
  ARRAY['结果','或者','换']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一辈子活下来，常常是，在最有意思的时候，没有有意思地过；在最没意思的时候，想要有意思地过结果，却再也过不出意思。或者，换一种表述就是，在看不透的时候，好看的人生过得不好看；看透了，想过得好看，可是人生已经没法看了'),
  4,
  ARRAY['活下来','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一辈子活下来，常常是，在最有意思的时候，没有有意思地过；在最没意思的时候，想要有意思地过结果，却再也过不出意思。或者，换一种表述就是，在看不透的时候，好看的人生过得不好看；看透了，想过得好看，可是人生已经没法看了'),
  5,
  ARRAY['透']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '希望明天的我，能和今天之前的一切好好说声再见，未来的好坏，即便是丝毫不期待也照样会到来，我深深相信我不再需要从别人那里得到前进的勇气和力量，哪怕对我来说有多难，我知道我也一样可以，为什么要头也不回地向前跑，因为没有未来的人，没资格聊从前',
  'xī wàng míng tiān de wǒ ， néng hé jīn tiān zhī qián de yí qiè hǎo hǎo shuō shēng zài jiàn ， wèi lái de hǎo huài ， jí biàn shì sī háo bù qī dài yě zhào yàng huì dào lái ， wǒ shēn shēn xiāng xìn wǒ bú zài xū yào cóng bié rén nà lǐ dé dào qián jìn de yǒng qì hé lì liáng ， nǎ pà duì wǒ lái shuō yǒu duō nán ， wǒ zhī dào wǒ yě yí yàng kě yǐ ， wèi shén me yào tóu yě bù huí dì xiàng qián pǎo ， yīn wèi méi yǒu wèi lái de rén ， méi zī gé liáo cóng qián',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望明天的我，能和今天之前的一切好好说声再见，未来的好坏，即便是丝毫不期待也照样会到来，我深深相信我不再需要从别人那里得到前进的勇气和力量，哪怕对我来说有多难，我知道我也一样可以，为什么要头也不回地向前跑，因为没有未来的人，没资格聊从前'),
  1,
  ARRAY['明天','的','我','能','和','今天','一切','好好','说','再见','好坏','是','期待','会','不再','那里得','前进的','哪怕','对','我来','有','多难','我知道','我也','一样','回','人','没']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望明天的我，能和今天之前的一切好好说声再见，未来的好坏，即便是丝毫不期待也照样会到来，我深深相信我不再需要从别人那里得到前进的勇气和力量，哪怕对我来说有多难，我知道我也一样可以，为什么要头也不回地向前跑，因为没有未来的人，没资格聊从前'),
  2,
  ARRAY['希望','也','到来','从','别人','到','可以','为什么','要','也不','跑','因为没有','从前']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望明天的我，能和今天之前的一切好好说声再见，未来的好坏，即便是丝毫不期待也照样会到来，我深深相信我不再需要从别人那里得到前进的勇气和力量，哪怕对我来说有多难，我知道我也一样可以，为什么要头也不回地向前跑，因为没有未来的人，没资格聊从前'),
  3,
  ARRAY['声','照样','相信','需要','力量','头','地','向前','聊']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望明天的我，能和今天之前的一切好好说声再见，未来的好坏，即便是丝毫不期待也照样会到来，我深深相信我不再需要从别人那里得到前进的勇气和力量，哪怕对我来说有多难，我知道我也一样可以，为什么要头也不回地向前跑，因为没有未来的人，没资格聊从前'),
  4,
  ARRAY['之前','即便','深深','勇气','资格']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望明天的我，能和今天之前的一切好好说声再见，未来的好坏，即便是丝毫不期待也照样会到来，我深深相信我不再需要从别人那里得到前进的勇气和力量，哪怕对我来说有多难，我知道我也一样可以，为什么要头也不回地向前跑，因为没有未来的人，没资格聊从前'),
  5,
  ARRAY['未来的','丝毫不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有时候你会特别渴望找个人谈一谈，但是到最后你会发现，往往都谈不出个所以然，慢慢地你领悟到，有些事情是不能告诉别人的，有些事情不必告诉别人的，有些事情是根本没办法用言语告诉别人的，有些事情是即使告诉了别人，别人也理解不了的。所以，有些话，只能放在心里，让时间告诉你一切',
  'yǒu shí hòu nǐ huì tè bié kě wàng zhǎo gè rén tán yi tán ， dàn shì dào zuì hòu nǐ huì fā xiàn ， wǎng wǎng dōu tán bù chū gè suǒ yǐ rán ， màn màn dì nǐ lǐng wù dào ， yǒu xiē shì qíng shì bù néng gào sù bié rén de ， yǒu xiē shì qíng bú bì gào sù bié rén de ， yǒu xiē shì qíng shì gēn běn méi bàn fǎ yòng yán yǔ gào sù bié rén de ， yǒu xiē shì qíng shì jí shǐ gào sù le bié rén ， bié rén yě lǐ jiě bù le de 。 suǒ yǐ ， yǒu xiē huà ， zhǐ néng fàng zài xīn lǐ ， ràng shí jiān gào sù nǐ yí qiè',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候你会特别渴望找个人谈一谈，但是到最后你会发现，往往都谈不出个所以然，慢慢地你领悟到，有些事情是不能告诉别人的，有些事情不必告诉别人的，有些事情是根本没办法用言语告诉别人的，有些事情是即使告诉了别人，别人也理解不了的。所以，有些话，只能放在心里，让时间告诉你一切'),
  1,
  ARRAY['有时候','你','会','个人','都','不','出','个','有些','是','不能','的','不必','没','了','不了','话','时间','一切']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候你会特别渴望找个人谈一谈，但是到最后你会发现，往往都谈不出个所以然，慢慢地你领悟到，有些事情是不能告诉别人的，有些事情不必告诉别人的，有些事情是根本没办法用言语告诉别人的，有些事情是即使告诉了别人，别人也理解不了的。所以，有些话，只能放在心里，让时间告诉你一切'),
  2,
  ARRAY['找','但是','到','最后','往往','所以然','慢慢地','事情','告诉','别人','也','所以','让']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候你会特别渴望找个人谈一谈，但是到最后你会发现，往往都谈不出个所以然，慢慢地你领悟到，有些事情是不能告诉别人的，有些事情不必告诉别人的，有些事情是根本没办法用言语告诉别人的，有些事情是即使告诉了别人，别人也理解不了的。所以，有些话，只能放在心里，让时间告诉你一切'),
  3,
  ARRAY['特别','渴望','发现','根本','办法','用','理解','只能','放在','心里']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候你会特别渴望找个人谈一谈，但是到最后你会发现，往往都谈不出个所以然，慢慢地你领悟到，有些事情是不能告诉别人的，有些事情不必告诉别人的，有些事情是根本没办法用言语告诉别人的，有些事情是即使告诉了别人，别人也理解不了的。所以，有些话，只能放在心里，让时间告诉你一切'),
  4,
  ARRAY['谈一','谈','言语','即使']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候你会特别渴望找个人谈一谈，但是到最后你会发现，往往都谈不出个所以然，慢慢地你领悟到，有些事情是不能告诉别人的，有些事情不必告诉别人的，有些事情是根本没办法用言语告诉别人的，有些事情是即使告诉了别人，别人也理解不了的。所以，有些话，只能放在心里，让时间告诉你一切'),
  5,
  ARRAY['领悟']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '其实千万个美丽的未来，低不上一个温暖的现在；每一个真实的现在，都是我们曾经幻想的未来',
  'qí shí qiān wàn gè měi lì de wèi lái ， dī bú shàng yí gè wēn nuǎn de xiàn zài ； měi yí gè zhēn shí de xiàn zài ， dōu shì wǒ men céng jīng huàn xiǎng de wèi lái',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '其实千万个美丽的未来，低不上一个温暖的现在；每一个真实的现在，都是我们曾经幻想的未来'),
  1,
  ARRAY['个','不','上一个','现在','都是','我们']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '其实千万个美丽的未来，低不上一个温暖的现在；每一个真实的现在，都是我们曾经幻想的未来'),
  2,
  ARRAY['千万','每一个','真实的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '其实千万个美丽的未来，低不上一个温暖的现在；每一个真实的现在，都是我们曾经幻想的未来'),
  3,
  ARRAY['其实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '其实千万个美丽的未来，低不上一个温暖的现在；每一个真实的现在，都是我们曾经幻想的未来'),
  4,
  ARRAY['美丽的','低','温暖的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '其实千万个美丽的未来，低不上一个温暖的现在；每一个真实的现在，都是我们曾经幻想的未来'),
  5,
  ARRAY['未来','曾经','幻想的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华',
  'yí gè rén zǒu tiān yá ， zhǐ yào huái chuāi wēn nuǎn de hé xī wàng ， biàn bú huì gū dān 。 zhī shì gèng kě wàng ， yǒu yì tiān yǔ wèi zhī de nǐ bìng jiān kàn shì jiān de luò mò yǔ fán huá',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华'),
  1,
  ARRAY['一个人','天涯','和','不会','有一天','你','看']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华'),
  2,
  ARRAY['走','希望','便']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华'),
  3,
  ARRAY['只要','只是','更','渴望','世间的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华'),
  4,
  ARRAY['怀揣','温暖的','与','并肩','落寞']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华'),
  5,
  ARRAY['未知的','繁华']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人走天涯，只要怀揣温暖的和希望，便不会孤单。只是更渴望，有一天与未知的你并肩看世间的落寞与繁华'),
  6,
  ARRAY['孤单']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏待你',
  'rú guǒ shì yǔ yuàn wéi ， jiù xiāng xìn shàng tiān yí dìng lìng yǒu ān pái ； suǒ yǒu shī qù de ， dōu huì yǐ lìng wài yì zhǒng fāng shì guī lái 。 xiāng xìn zì jǐ ， xiāng xìn shí jiān bú huì kuī dài nǐ',
  'Nếu mọi chuyện không như ý, hãy tin rằng ông trời luôn có sắp đặt khác; những gì đã mất sẽ trở lại theo một cách khác. Hãy tin vào chính mình, và tin rằng thời gian sẽ không phụ bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏待你'),
  1,
  ARRAY['上天','一定','都会','一种','时间','不会','你']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏待你'),
  2,
  ARRAY['事与愿违','就','所有','以']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏待你'),
  3,
  ARRAY['如果','相信','安排','方式','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏待你'),
  4,
  ARRAY['另有','失去的','另外']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏待你'),
  5,
  ARRAY['归来','亏待']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '这个世界不会总对我们保持和风细雨的态度，尤其是当你做得还不够到位时，更难免受到指摘。但那些当年让自己极其不适的人或事，其实事后看来，无一不是对自己难得的磨练',
  'zhè ge shì jiè bú huì zǒng duì wǒ men bǎo chí hé fēng xì yǔ de tài dù ， yóu qí shì dāng nǐ zuò dé hái bú gòu dào wèi shí ， gèng nán miǎn shòu dào zhǐ zhāi 。 dàn nà xiē dāng nián ràng zì jǐ jí qí bú shì de rén huò shì ， qí shí shì hòu kàn lái ， wú yí bú shì duì zì jǐ nán dé de mó liàn',
  'Thế giới này không phải lúc nào cũng nhẹ nhàng với chúng ta, đặc biệt khi bạn chưa làm tốt, khó tránh khỏi những lời chỉ trích. Nhưng những con người hay sự việc từng khiến bạn khó chịu, nhìn lại mới thấy đó đều là những rèn luyện quý giá.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个世界不会总对我们保持和风细雨的态度，尤其是当你做得还不够到位时，更难免受到指摘。但那些当年让自己极其不适的人或事，其实事后看来，无一不是对自己难得的磨练'),
  1,
  ARRAY['这个','不会','对','我们','和风细雨的','你','做','不够','时','那些','不适','的','人','看来','不是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个世界不会总对我们保持和风细雨的态度，尤其是当你做得还不够到位时，更难免受到指摘。但那些当年让自己极其不适的人或事，其实事后看来，无一不是对自己难得的磨练'),
  2,
  ARRAY['得','还','到位','但','让','事','事后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个世界不会总对我们保持和风细雨的态度，尤其是当你做得还不够到位时，更难免受到指摘。但那些当年让自己极其不适的人或事，其实事后看来，无一不是对自己难得的磨练'),
  3,
  ARRAY['世界','总','当','更','难免','当年','自己','极其','或','其实','难得的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个世界不会总对我们保持和风细雨的态度，尤其是当你做得还不够到位时，更难免受到指摘。但那些当年让自己极其不适的人或事，其实事后看来，无一不是对自己难得的磨练'),
  4,
  ARRAY['保持','态度','尤其是','受到','指摘','无一']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '这个世界不会总对我们保持和风细雨的态度，尤其是当你做得还不够到位时，更难免受到指摘。但那些当年让自己极其不适的人或事，其实事后看来，无一不是对自己难得的磨练'),
  6,
  ARRAY['磨练']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '今天不管你多富有，若无危机感，别人今天的落魄，就是你明天的影子；不管你多贫穷，若有危机感，别人今天的成功，也是你明天的影子',
  'jīn tiān bù guǎn nǐ duō fù yǒu ， ruò wú wēi jī gǎn ， bié rén jīn tiān de luò pò ， jiù shì nǐ míng tiān de yǐng zi ； bù guǎn nǐ duō pín qióng ， ruò yǒu wēi jī gǎn ， bié rén jīn tiān de chéng gōng ， yě shì nǐ míng tiān de yǐng zi',
  'Dù bạn giàu có đến đâu, nếu không có cảm giác nguy cơ, sự khốn khó của người khác hôm nay có thể là cái bóng của bạn ngày mai; và dù bạn nghèo khó ra sao, nếu có cảm giác nguy cơ, thành công của người khác hôm nay cũng có thể là hình bóng của bạn ngày mai.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '今天不管你多富有，若无危机感，别人今天的落魄，就是你明天的影子；不管你多贫穷，若有危机感，别人今天的成功，也是你明天的影子'),
  1,
  ARRAY['今天','不管','你','多','的','明天','影子','有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '今天不管你多富有，若无危机感，别人今天的落魄，就是你明天的影子；不管你多贫穷，若有危机感，别人今天的成功，也是你明天的影子'),
  2,
  ARRAY['别人','就是','也是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '今天不管你多富有，若无危机感，别人今天的落魄，就是你明天的影子；不管你多贫穷，若有危机感，别人今天的成功，也是你明天的影子'),
  3,
  ARRAY['成功']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '今天不管你多富有，若无危机感，别人今天的落魄，就是你明天的影子；不管你多贫穷，若有危机感，别人今天的成功，也是你明天的影子'),
  4,
  ARRAY['富有','危机感','落魄']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '今天不管你多富有，若无危机感，别人今天的落魄，就是你明天的影子；不管你多贫穷，若有危机感，别人今天的成功，也是你明天的影子'),
  6,
  ARRAY['若无','贫穷','若']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '意外和明天不知道哪个会先来，我们永远都不知道，好好珍惜每分每秒，珍惜当下，珍惜身边爱你和你爱着的人',
  'yì wài hé míng tiān bù zhī dào nǎ gè huì xiān lái ， wǒ men yǒng yuǎn dōu bù zhī dào ， hǎo hǎo zhēn xī měi fēn měi miǎo ， zhēn xī dāng xià ， zhēn xī shēn biān ài nǐ hé nǐ ài zhe de rén',
  'Không ai biết được điều gì sẽ đến trước – bất ngờ hay ngày mai. Chúng ta chẳng bao giờ biết trước được điều gì, hãy trân trọng từng phút giây, sống hết mình cho hiện tại và yêu thương những người bên cạnh.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '意外和明天不知道哪个会先来，我们永远都不知道，好好珍惜每分每秒，珍惜当下，珍惜身边爱你和你爱着的人'),
  1,
  ARRAY['和','明天','不知道','哪个','会','先','来','我们','都','好好','爱','你','的','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '意外和明天不知道哪个会先来，我们永远都不知道，好好珍惜每分每秒，珍惜当下，珍惜身边爱你和你爱着的人'),
  2,
  ARRAY['意外','每分每秒','身边','着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '意外和明天不知道哪个会先来，我们永远都不知道，好好珍惜每分每秒，珍惜当下，珍惜身边爱你和你爱着的人'),
  3,
  ARRAY['当下']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '意外和明天不知道哪个会先来，我们永远都不知道，好好珍惜每分每秒，珍惜当下，珍惜身边爱你和你爱着的人'),
  4,
  ARRAY['永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '意外和明天不知道哪个会先来，我们永远都不知道，好好珍惜每分每秒，珍惜当下，珍惜身边爱你和你爱着的人'),
  5,
  ARRAY['珍惜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要再追逐光明了，让自己发光吧。让未来的你，感谢今天你所付出的努力',
  'bú yào zài zhuī zhú guāng míng le ， ràng zì jǐ fā guāng ba 。 ràng wèi lái de nǐ ， gǎn xiè jīn tiān nǐ suǒ fù chū de nǔ lì',
  'Đừng mãi đuổi theo ánh sáng nữa, hãy tự mình tỏa sáng. Để rồi mai này, bạn sẽ cảm ơn những nỗ lực mà bạn đã bỏ ra hôm nay.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要再追逐光明了，让自己发光吧。让未来的你，感谢今天你所付出的努力'),
  1,
  ARRAY['不要','再','了','你','今天','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要再追逐光明了，让自己发光吧。让未来的你，感谢今天你所付出的努力'),
  2,
  ARRAY['让','吧','所']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要再追逐光明了，让自己发光吧。让未来的你，感谢今天你所付出的努力'),
  3,
  ARRAY['自己','发光','感谢','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要再追逐光明了，让自己发光吧。让未来的你，感谢今天你所付出的努力'),
  4,
  ARRAY['光明','付出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要再追逐光明了，让自己发光吧。让未来的你，感谢今天你所付出的努力'),
  5,
  ARRAY['追逐','未来的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西',
  'zài wèi lái de rì zi lǐ ， kùn nán ， gū dú ， cuò zhé yě yí dìng zài qián fāng děng dài ， shí kè zhǔn bèi zhe zài mǒu yí shùn jiān bǎ nǐ jī dǎo 。 yě xǔ nǐ huì zài mǒu gè yīn yù de rì zi lǐ wàn bān jué wàng ， jué de tài yáng zài yě bú huì shēng qǐ ， dàn shì nǐ yīng gāi zhī dào ， zhè xiē dōu bú shì zhēn de ， wēn nuǎn de dōng xī bù guāng zhǐ yǒu tài yáng ， hái yǒu bié de měi hǎo de dōng xī',
  'Trong những ngày tháng sắp tới, khó khăn, cô đơn và thất bại chắc chắn sẽ đợi bạn phía trước, sẵn sàng đánh gục bạn vào một khoảnh khắc nào đó. Có thể trong một ngày u ám, bạn sẽ cảm thấy tuyệt vọng và nghĩ rằng mặt trời sẽ không bao giờ mọc nữa. Nhưng hãy nhớ, điều đó không phải sự thật. Sự ấm áp không chỉ đến từ mặt trời, mà còn từ những điều tốt đẹp khác.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西'),
  1,
  ARRAY['在','一定','在前','时刻准备着','一瞬间','你','会','觉得','太阳','再也不会','这些','都','不是','东西','不光']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西'),
  2,
  ARRAY['日子里','也','等待','也许','阴郁的','但是','知道','真的','还有','别的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西'),
  3,
  ARRAY['方','把','万般','应该','只有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西'),
  4,
  ARRAY['困难','绝望','温暖的','美好的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西'),
  5,
  ARRAY['未来的','某','击倒','某个','升起']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在未来的日子里，困难，孤独，挫折也一定在前方等待，时刻准备着在某一瞬间把你击倒。也许你会在某个阴郁的日子里万般绝望，觉得太阳再也不会升起，但是你应该知道，这些都不是真的，温暖的东西不光只有太阳，还有别的美好的东西'),
  6,
  ARRAY['孤独','挫折']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要让未来的你，讨厌现在的自己，努力变成自己喜欢的那个自己。与其祈求生活平淡点，还不如自己强大点',
  'bú yào ràng wèi lái de nǐ ， tǎo yàn xiàn zài de zì jǐ ， nǔ lì biàn chéng zì jǐ xǐ huān de nà ge zì jǐ 。 yǔ qí qí qiú shēng huó píng dàn diǎn ， hái bù rú zì jǐ qiáng dà diǎn',
  'Đừng để bản thân trong tương lai ghét bỏ con người hiện tại của bạn. Hãy nỗ lực để trở thành phiên bản mà bạn yêu thích. Thay vì cầu mong cuộc sống bình lặng, hãy mạnh mẽ hơn để đối mặt.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要让未来的你，讨厌现在的自己，努力变成自己喜欢的那个自己。与其祈求生活平淡点，还不如自己强大点'),
  1,
  ARRAY['不要','你','现在的','喜欢的','那个','生活','点','不如']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要让未来的你，讨厌现在的自己，努力变成自己喜欢的那个自己。与其祈求生活平淡点，还不如自己强大点'),
  2,
  ARRAY['让','还']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要让未来的你，讨厌现在的自己，努力变成自己喜欢的那个自己。与其祈求生活平淡点，还不如自己强大点'),
  3,
  ARRAY['自己','努力','变成','祈求','平淡']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要让未来的你，讨厌现在的自己，努力变成自己喜欢的那个自己。与其祈求生活平淡点，还不如自己强大点'),
  4,
  ARRAY['讨厌','与其']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要让未来的你，讨厌现在的自己，努力变成自己喜欢的那个自己。与其祈求生活平淡点，还不如自己强大点'),
  5,
  ARRAY['未来的','强大']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不论今天多么困难，都要坚信：只有会不去的过网，没有到不了的明天',
  'bú lùn jīn tiān duō me kùn nán ， dōu yào jiān xìn ： zhǐ yǒu huì bú qù de guò wǎng ， méi yǒu dào bù liǎo de míng tiān',
  'Dù hôm nay có khó khăn đến đâu, hãy luôn tin rằng: không có trở ngại nào không vượt qua được, chỉ cần kiên trì, ngày mai sẽ đến.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不论今天多么困难，都要坚信：只有会不去的过网，没有到不了的明天'),
  1,
  ARRAY['不论','今天','多么','都','会','不去','的','没有','不了','明天']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不论今天多么困难，都要坚信：只有会不去的过网，没有到不了的明天'),
  2,
  ARRAY['要','过','到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不论今天多么困难，都要坚信：只有会不去的过网，没有到不了的明天'),
  3,
  ARRAY['只有','网']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不论今天多么困难，都要坚信：只有会不去的过网，没有到不了的明天'),
  4,
  ARRAY['困难','坚信']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每一步都有自己的脚印，每一步都有自己的回忆，一直努力的，不要太看重现在的结果，因为未来的路还很远很远',
  'měi yí bù dōu yǒu zì jǐ de jiǎo yìn ， měi yí bù dōu yǒu zì jǐ de huí yì ， yì zhí nǔ lì de ， bú yào tài kàn chóng xiàn zài de jié guǒ ， yīn wèi wèi lái de lù hái hěn yuǎn hěn yuǎn',
  'Mỗi bước đi đều in dấu chân của chính mình, mỗi bước đều lưu giữ kỷ niệm. Cứ nỗ lực hết mình, đừng quá đặt nặng kết quả hiện tại, bởi vì con đường phía trước còn dài lắm.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一步都有自己的脚印，每一步都有自己的回忆，一直努力的，不要太看重现在的结果，因为未来的路还很远很远'),
  1,
  ARRAY['有','回忆','一直','不要','太','看重','现在的','很远很远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一步都有自己的脚印，每一步都有自己的回忆，一直努力的，不要太看重现在的结果，因为未来的路还很远很远'),
  2,
  ARRAY['每一','步都','因为','路','还']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一步都有自己的脚印，每一步都有自己的回忆，一直努力的，不要太看重现在的结果，因为未来的路还很远很远'),
  3,
  ARRAY['自己的','脚印','努力的','结果']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一步都有自己的脚印，每一步都有自己的回忆，一直努力的，不要太看重现在的结果，因为未来的路还很远很远'),
  5,
  ARRAY['未来的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间让我们看清什么是真，什么是假。对我好的我会珍惜，对我不好的我会远离。未来的路，我会继续努力，也许你很牛，但我未必在意',
  'shí jiān ràng wǒ men kàn qīng shén me shì zhēn ， shén me shì jiǎ 。 duì wǒ hǎo de wǒ huì zhēn xī ， duì wǒ bù hǎo de wǒ huì yuǎn lí 。 wèi lái de lù ， wǒ huì jì xù nǔ lì ， yě xǔ nǐ hěn niú ， dàn wǒ wèi bì zài yì',
  'Thời gian giúp ta nhận ra đâu là thật, đâu là giả. Những gì tốt với tôi, tôi sẽ trân trọng; những gì không tốt, tôi sẽ tránh xa. Trên con đường tương lai, tôi sẽ tiếp tục cố gắng. Có thể bạn rất giỏi, nhưng chưa chắc tôi đã quan tâm.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间让我们看清什么是真，什么是假。对我好的我会珍惜，对我不好的我会远离。未来的路，我会继续努力，也许你很牛，但我未必在意'),
  1,
  ARRAY['时间','们','看清','什么是','对','我','好的','我会','不好的','你','很','在意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间让我们看清什么是真，什么是假。对我好的我会珍惜，对我不好的我会远离。未来的路，我会继续努力，也许你很牛，但我未必在意'),
  2,
  ARRAY['让我','真','远离','路','也许','牛','但']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间让我们看清什么是真，什么是假。对我好的我会珍惜，对我不好的我会远离。未来的路，我会继续努力，也许你很牛，但我未必在意'),
  3,
  ARRAY['假','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间让我们看清什么是真，什么是假。对我好的我会珍惜，对我不好的我会远离。未来的路，我会继续努力，也许你很牛，但我未必在意'),
  4,
  ARRAY['继续']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间让我们看清什么是真，什么是假。对我好的我会珍惜，对我不好的我会远离。未来的路，我会继续努力，也许你很牛，但我未必在意'),
  5,
  ARRAY['珍惜','未来的','未必']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气',
  'wèi lái ， jiù shì nǐ zhàn zài máng máng dà hǎi de zhè yì biān ， yáo wàng zhe hǎi de nà yì biān ， chōng mǎn hào qí xīn ， chōng jǐng zhe duì hǎi nà biān de xiàng wǎng 。 zhèng shì duì wèi zhī de bù liǎo jiě yǔ xiàng wǎng ， suǒ yǐ yǒu le qù zhuī zhú wèi lái de yǒng qì',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  1,
  ARRAY['你','在','大海','的','这','一边','那','好奇心','对','那边的','不了解','有了','去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  2,
  ARRAY['就是','站','着','正是','所以']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  3,
  ARRAY['向往']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  4,
  ARRAY['海的','海','与','勇气']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  5,
  ARRAY['未来','充满','未知的','追逐','未来的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  6,
  ARRAY['茫茫','遥望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来，就是你站在茫茫大海的这一边，遥望着海的那一边，充满好奇心，憧憬着对海那边的向往。正是对未知的不了解与向往，所以有了去追逐未来的勇气'),
  ARRAY['憧','憬']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要轻易把梦想寄托在某个人身上，也不要在乎身边的闲言碎语，因为未来是你自己的，不是你能不能，而是你要不要！每天给自己完美的交代，为自己而努力',
  'bú yào qīng yì bǎ mèng xiǎng jì tuō zài mǒu gè rén shēn shàng ， yě bú yào zài hū shēn biān de xián yán suì yǔ ， yīn wèi wèi lái shì nǐ zì jǐ de ， bú shì nǐ néng bu néng ， ér shì nǐ yào bu yào ！ měi tiān gěi zì jǐ wán měi de jiāo dài ， wèi zì jǐ ér nǔ lì',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要在乎身边的闲言碎语，因为未来是你自己的，不是你能不能，而是你要不要！每天给自己完美的交代，为自己而努力'),
  1,
  ARRAY['不要','在','人身','上','在乎','的','是','你自己','不是','你','能不能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要在乎身边的闲言碎语，因为未来是你自己的，不是你能不能，而是你要不要！每天给自己完美的交代，为自己而努力'),
  2,
  ARRAY['也不','要','身边','因为','要不','每天','给','完美的','为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要在乎身边的闲言碎语，因为未来是你自己的，不是你能不能，而是你要不要！每天给自己完美的交代，为自己而努力'),
  3,
  ARRAY['轻易','把','而是','自己','而','努力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要在乎身边的闲言碎语，因为未来是你自己的，不是你能不能，而是你要不要！每天给自己完美的交代，为自己而努力'),
  4,
  ARRAY['梦想','寄托','交代']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要在乎身边的闲言碎语，因为未来是你自己的，不是你能不能，而是你要不要！每天给自己完美的交代，为自己而努力'),
  5,
  ARRAY['某个','闲言碎语','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化',
  'měi gè rén shēng jiē duàn ， dōu xū yào zuò bù tóng de xuǎn zé 。 méi yǒu rén xū yào zuò yǒng yuǎn xiāng tóng de jué dìng 。 céng jīng de cuò ， huò xǔ jiāng lái shì duì de 。 céng jīng de duì ， què shì wèi lái yào fàng qì de 。 bú yào wèi cǐ ér chóu chàng ， bú shì nǐ biàn le ， ér shì nǐ tí shēng le 。 biàn hǎo ， shì rén shēng zuì hǎo de biàn huà',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化'),
  1,
  ARRAY['生','都','做','不同的','没有人','的','是','对的','对','不要','不是','你','了','人生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化'),
  2,
  ARRAY['每个人','错','要','为此','最好的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化'),
  3,
  ARRAY['需要','选择','相同的','决定','或许','放弃的','而','变','而是','提升','变好','变化']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化'),
  4,
  ARRAY['永远','将来','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化'),
  5,
  ARRAY['阶段','曾经','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人生阶段，都需要做不同的选择。没有人需要做永远相同的决定。曾经的错，或许将来是对的。曾经的对，却是未来要放弃的。不要为此而惆怅，不是你变了，而是你提升了。变好，是人生最好的变化'),
  ARRAY['惆','怅']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你所浪费的今天，是许多人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。人生最可悲的事情，莫过于胸怀大志，却又虚渡光阴',
  'nǐ suǒ làng fèi de jīn tiān ， shì xǔ duō rén shē wàng de míng tiān ； nǐ suǒ yàn wù de xiàn zài ， shì wèi lái de nǐ huí bú qù de céng jīng 。 rén shēng zuì kě bēi de shì qíng ， mò guò yú xiōng huái dà zhì ， què yòu xū dù guāng yīn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所浪费的今天，是许多人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。人生最可悲的事情，莫过于胸怀大志，却又虚渡光阴'),
  1,
  ARRAY['你','今天','是','的','明天','现在','回','不去','人生','大志']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所浪费的今天，是许多人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。人生最可悲的事情，莫过于胸怀大志，却又虚渡光阴'),
  2,
  ARRAY['所','最','可悲的','事情']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所浪费的今天，是许多人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。人生最可悲的事情，莫过于胸怀大志，却又虚渡光阴'),
  4,
  ARRAY['浪费的','许多人','厌恶的','却又','光阴']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所浪费的今天，是许多人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。人生最可悲的事情，莫过于胸怀大志，却又虚渡光阴'),
  5,
  ARRAY['未来的','曾经','胸怀','虚']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所浪费的今天，是许多人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。人生最可悲的事情，莫过于胸怀大志，却又虚渡光阴'),
  6,
  ARRAY['奢望','莫过于','渡']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己',
  'nǐ wèi lái de mìng yùn shì yǒu nǐ xiàn zài suǒ zuò de yí qiè suǒ jué dìng de ， gēn běn zhǎng wò zài zì jǐ de shǒu lǐ ， bié rén shì bù néng zuǒ yòu de 。 bié rén néng gòu jǐ yǔ wǒ men de zhī néng shì wài jiè de yì xiē bāng zhù ， zuì zhōng hái yào kào zì jǐ zhàn qǐ lái 。 yǔ qí mái yuàn mìng yùn ， bù rú fǎn sī zì jǐ ； yǔ qí yī kào bié rén ， bù rú qiáng dà zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己'),
  1,
  ARRAY['你','是','有','现在','做','的','一切','在','不能','能够','我们的','一些','不如']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己'),
  2,
  ARRAY['所','手里','别人','左右的','给予','外界的','帮助','最终','还要','站起来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己'),
  3,
  ARRAY['决定的','根本','自己的','只能','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己'),
  4,
  ARRAY['命运','与其','反思']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己'),
  5,
  ARRAY['未来的','掌握','靠自己','依靠','强大']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你未来的命运是有你现在所做的一切所决定的，根本掌握在自己的手里，别人是不能左右的。别人能够给予我们的只能是外界的一些帮助，最终还要靠自己站起来。与其埋怨命运，不如反思自己；与其依靠别人，不如强大自己'),
  6,
  ARRAY['埋怨']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生都是走着走着就开化了，现在的你，不用着急。让未来的，本就该属于你的树再长长，那些花再开开，等你遇见的时候，才是他们最美的时候',
  'rén shēng dōu shì zǒu zhe zǒu zhe jiù kāi huà le ， xiàn zài de nǐ ， bú yòng zháo jí 。 ràng wèi lái de ， běn jiù gāi shǔ yú nǐ de shù zài cháng cháng ， nà xiē huā zài kāi kāi ， děng nǐ yù jiàn de shí hòu ， cái shì tā men zuì měi de shí hòu',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生都是走着走着就开化了，现在的你，不用着急。让未来的，本就该属于你的树再长长，那些花再开开，等你遇见的时候，才是他们最美的时候'),
  1,
  ARRAY['人生','都是','开化','了','现在的','你','不用','本就','你的','再','那些','再开','开','的','时候','他们']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生都是走着走着就开化了，现在的你，不用着急。让未来的，本就该属于你的树再长长，那些花再开开，等你遇见的时候，才是他们最美的时候'),
  2,
  ARRAY['走着走着','就','着急','让','长长','等','最美']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生都是走着走着就开化了，现在的你，不用着急。让未来的，本就该属于你的树再长长，那些花再开开，等你遇见的时候，才是他们最美的时候'),
  3,
  ARRAY['该','树','花','遇见','才是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生都是走着走着就开化了，现在的你，不用着急。让未来的，本就该属于你的树再长长，那些花再开开，等你遇见的时候，才是他们最美的时候'),
  5,
  ARRAY['未来的','属于']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关',
  'zhí dào hěn duō nián hòu ， jīng lì shí guāng hé shì shì ， mǒu yí kè cái tū rán míng bái ， yuán lái ， wǒ men zhè yì shēng ， shè huì jīng lì hěn duō kǎn kě hé xuǎn zé de ， jiǎo xià zǒu de měi yí bù lù ， dōu yǔ wèi lái xī xī xiāng guān',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关'),
  1,
  ARRAY['很多','年','后','时光','和','一刻','明白','我们','这','一生','的','都']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关'),
  2,
  ARRAY['经历','走','每一','步','路','息息相关']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关'),
  3,
  ARRAY['直到','世事','才','突然','选择的','脚下']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关'),
  4,
  ARRAY['原来','社会','与']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关'),
  5,
  ARRAY['某','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '直到很多年后，经历时光和世事，某一刻才突然明白，原来，我们这一生，社会经历很多坎坷和选择的，脚下走的每一步路，都与未来息息相关'),
  ARRAY['坎','坷']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样',
  'wèi lái de mǒu yí kè ， nǐ zhōng huì yuán liàng suǒ yǒu shāng hài guò nǐ de rén 。 wú lùn duō me tòng ， duō me bù kān ， děng nǐ huó dé gèng hǎo de shí hòu ， nǐ huì fā xiàn ， shì tā men ràng nǐ cǐ kè de xìng fú gèng yǒu hòu dù ， gèng mí zú zhēn guì 。 méi yǒu chóu hèn ， zhǐ yǒu yì xiē yún dàn fēng qīng de jì yì ， yǐ jí cán cún de měi hǎo ， bú bì gǎn xiè tā men ， dàn tā men měi gè rén dōu biàn chéng nǐ rén shēng de yí gè yì yì ， zài gāi chū xiàn de dì fāng chū xiàn guò ， zào jiù le nǐ wèi lái de bù yí yàng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样'),
  1,
  ARRAY['一刻','你','会','你的','人','多么','不堪','时候','是','他们','的','有','没有','一些','不必','都','人生','一个','在','出现的','出现','了','不一样']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样'),
  2,
  ARRAY['所有','过','等','得','让','以及','但','每个人','意义']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样'),
  3,
  ARRAY['终','更好的','发现','更','只有','风','轻的','记忆','感谢','变成','该','地方']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样'),
  4,
  ARRAY['原谅','伤害','无论','活','此刻','幸福','厚度','云','美好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样'),
  5,
  ARRAY['未来的','某','痛','淡','造就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '未来的某一刻，你终会原谅所有伤害过你的人。无论多么痛，多么不堪，等你活得更好的时候，你会发现，是他们让你此刻的幸福更有厚度，更弥足珍贵。没有仇恨，只有一些云淡风轻的记忆，以及残存的美好，不必感谢他们，但他们每个人都变成你人生的一个意义，在该出现的地方出现过，造就了你未来的不一样'),
  6,
  ARRAY['弥足珍贵','仇恨','残存']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '唯一能和你媲美的，是明天到你10年前你是谁？一年前你是谁？甚至昨天你是谁？都不重要。今天你是谁，以及明天你将成为谁',
  'wéi yī néng hé nǐ pì měi de ， shì míng tiān dào nǐ 1 0 nián qián nǐ shì shuí ？ yì nián qián nǐ shì shuí ？ shèn zhì zuó tiān nǐ shì shuí ？ dōu bú zhòng yào 。 jīn tiān nǐ shì shuí ， yǐ jí míng tiān nǐ jiāng chéng wéi shuí',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '唯一能和你媲美的，是明天到你10年前你是谁？一年前你是谁？甚至昨天你是谁？都不重要。今天你是谁，以及明天你将成为谁'),
  1,
  ARRAY['能','和','你','的','是','明天','年前','你是谁','一年','前','昨天','都','不重要','今天','你将','谁']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '唯一能和你媲美的，是明天到你10年前你是谁？一年前你是谁？甚至昨天你是谁？都不重要。今天你是谁，以及明天你将成为谁'),
  2,
  ARRAY['到','以及']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '唯一能和你媲美的，是明天到你10年前你是谁？一年前你是谁？甚至昨天你是谁？都不重要。今天你是谁，以及明天你将成为谁'),
  3,
  ARRAY['成为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '唯一能和你媲美的，是明天到你10年前你是谁？一年前你是谁？甚至昨天你是谁？都不重要。今天你是谁，以及明天你将成为谁'),
  4,
  ARRAY['媲美','甚至']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '唯一能和你媲美的，是明天到你10年前你是谁？一年前你是谁？甚至昨天你是谁？都不重要。今天你是谁，以及明天你将成为谁'),
  5,
  ARRAY['唯一']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '希望是本无所谓有，无所谓 无的。这正如地上的路，其实地上本没有路，走的人多了，也便成了路。有了梦想，就要不断去追逐。这样，梦想才有可能实现',
  'xī wàng shì běn wú suǒ wèi yǒu ， wú suǒ wèi   wú de 。 zhè zhèng rú dì shàng de lù ， qí shí dì shàng běn méi yǒu lù ， zǒu de rén duō le ， yě biàn chéng le lù 。 yǒu le mèng xiǎng ， jiù yào bú duàn qù zhuī zhú 。 zhè yàng ， mèng xiǎng cái yǒu kě néng shí xiàn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望是本无所谓有，无所谓 无的。这正如地上的路，其实地上本没有路，走的人多了，也便成了路。有了梦想，就要不断去追逐。这样，梦想才有可能实现'),
  1,
  ARRAY['是','本','有','的','这','没有','人','多','了','有了','不断','去','这样','有可能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望是本无所谓有，无所谓 无的。这正如地上的路，其实地上本没有路，走的人多了，也便成了路。有了梦想，就要不断去追逐。这样，梦想才有可能实现'),
  2,
  ARRAY['希望','正如','路','走','也','便','就要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望是本无所谓有，无所谓 无的。这正如地上的路，其实地上本没有路，走的人多了，也便成了路。有了梦想，就要不断去追逐。这样，梦想才有可能实现'),
  3,
  ARRAY['地上的','其实','地上','成了','才','实现']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望是本无所谓有，无所谓 无的。这正如地上的路，其实地上本没有路，走的人多了，也便成了路。有了梦想，就要不断去追逐。这样，梦想才有可能实现'),
  4,
  ARRAY['无所谓','无','梦想']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '希望是本无所谓有，无所谓 无的。这正如地上的路，其实地上本没有路，走的人多了，也便成了路。有了梦想，就要不断去追逐。这样，梦想才有可能实现'),
  5,
  ARRAY['追逐']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚',
  'xīng kōng zhī xià ， zuò zhe xuán zhuǎn mù mǎ ， wǒ méi yǒu fàng qì ， nà ge yì shēng de mèng xiǎng ， wǒ hái zài zhuī xún ， kào zì jǐ de chì bǎng ， fēi shàng xīng kōng ； kàn dào zì jǐ de wén zì ， xiě xià xuàn làn ； kào zì jǐ de lì liàng ， shí xiàn mèng xiǎng 。 wǒ céng jīng de shì jiè zhī lí pò suì ， zuò wéi jiāo huàn ， wǒ xiàn zài de shì jiè yáng guāng míng mèi',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚'),
  1,
  ARRAY['星空','坐','我','没有','那个','一生的','在','的','飞','上星','看到','写下','作为交换','现在的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚'),
  2,
  ARRAY['着','还']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚'),
  3,
  ARRAY['放弃','空','自己的','文字','力量','实现','世界','阳光明媚']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚'),
  4,
  ARRAY['之下','梦想','支离破碎']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚'),
  5,
  ARRAY['追寻','靠自己','翅膀','绚烂','曾经']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '星空之下，坐着旋转木马，我没有放弃，那个一生的梦想，我还在追寻，靠自己的翅膀，飞上星空；看到自己的文字，写下绚烂；靠自己的力量，实现梦想。我曾经的世界支离破碎，作为交换，我现在的世界阳光明媚'),
  6,
  ARRAY['旋转木马']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在',
  'xǔ duō rén gào sù wǒ ， mèng xiǎng zhōng guī shì mèng xiǎng ， shí xiàn mèng xiǎng de rén zhōng guī shì shǎo shù ， kě wǒ bù xǐ huan zhè yàng de huà ， yīn wèi zhè yàng de huà duì wǒ hé wǒ de mèng xiǎng háo wú yì yì ， zhī huì lìng wǒ jù lí wǒ de mèng xiǎng gèng jiā yáo yuǎn 。 zuì zhōng wǒ fā xiàn ， duō shǎo dān yōu ， guī quàn ， zǔ lán ， fǒu rèn de huà dōu bù néng lìng wǒ kāi xīn ， fǎn ér huì lìng wǒ gǎn dào wěi qū ， jǔ sàng ， yōu yù hé bú kuài ， wǒ zǒng shì zhì yí nà xiē quàn wèi hé jiě shì ， yīn wèi wǒ sì hū zǒng shì lè yú xiāng xìn zhè shì jiān nà lìng yí bàn guāng míng de cún zài',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在'),
  1,
  ARRAY['我','是','人','少数','不喜欢','这样的话','对','和','我的','会','多少','话','都','不能','开心','不快','那些','和解','这','那']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在'),
  2,
  ARRAY['告诉','可我','因为','最终','乐于']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在'),
  3,
  ARRAY['终归','实现','只','更加','发现','担忧','感到委屈','总是','相信','世间']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在'),
  4,
  ARRAY['许多人','梦想','梦想的','距离','规劝','否认的','反而','质疑','释','另一半','光明的','存在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在'),
  5,
  ARRAY['毫无意义','令','阻拦','劝慰','似乎']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '许多人告诉我，梦想终归是梦想，实现梦想的人终归是少数，可我不喜欢这样的话，因为这样的话对我和我的梦想毫无意义，只会令我距离我的梦想更加遥远。最终我发现，多少担忧，规劝，阻拦，否认的话都不能令我开心，反而会令我感到委屈，沮丧，忧郁和不快，我总是质疑那些劝慰和解释，因为我似乎总是乐于相信这世间那另一半光明的存在'),
  6,
  ARRAY['遥远','沮丧','忧郁']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '梦想不抛弃苦心追求的人，只要不停止求追求，终究会沐浴在梦想的光辉之中',
  'mèng xiǎng bù pāo qì kǔ xīn zhuī qiú de rén ， zhǐ yào bù tíng zhǐ qiú zhuī qiú ， zhōng jiū huì mù yù zài mèng xiǎng de guāng huī zhī zhōng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想不抛弃苦心追求的人，只要不停止求追求，终究会沐浴在梦想的光辉之中'),
  1,
  ARRAY['不','的','人','不停','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想不抛弃苦心追求的人，只要不停止求追求，终究会沐浴在梦想的光辉之中'),
  3,
  ARRAY['只要','求','终究']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想不抛弃苦心追求的人，只要不停止求追求，终究会沐浴在梦想的光辉之中'),
  4,
  ARRAY['梦想','苦心','止','梦想的','光辉','之中']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想不抛弃苦心追求的人，只要不停止求追求，终究会沐浴在梦想的光辉之中'),
  5,
  ARRAY['追求']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想不抛弃苦心追求的人，只要不停止求追求，终究会沐浴在梦想的光辉之中'),
  6,
  ARRAY['抛弃','沐浴在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事',
  'mèng xiǎng rú chén xīng ， wǒ men yǒng bù néng chù dào ， dàn wǒ men kě xiàng háng hǎi zhě yí yàng ， jiè xīng guāng de wèi zhì ér háng xíng 。 yòng qiáng liè yù wàng zuò wéi dá chéng mèng xiǎng de hòu dùn ， shǐ yù wàng biàn de kuáng rè ， ràng tā chéng wéi nǐ nǎo zhōng zuì zhòng yào de yí jiàn shì',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事'),
  1,
  ARRAY['我们','能','一样','星光的','作为','后盾','你','脑','中','一件事']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事'),
  2,
  ARRAY['到','但','可','让','它','最重要的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事'),
  3,
  ARRAY['如','像','借','位置','而','用','变得','成为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事'),
  4,
  ARRAY['梦想','永不','航海者','航行','梦想的','使']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事'),
  5,
  ARRAY['触','强烈','达成','狂热']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想如晨星，我们永不能触到，但我们可像航海者一样，借星光的位置而航行。用强烈欲望作为达成梦想的后盾，使欲望变得狂热，让它成为你脑中最重要的一件事'),
  6,
  ARRAY['晨星','欲望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动',
  'wǒ men yào yǒu zhí zhuó zhuī qiú de mèng xiǎng ， yào ràng yuán běn bái zhǐ bān de shēng mìng kāi chū wǔ cǎi bān lán de huā duǒ ， huí shǒu yǐ wǎng ， shǐ de nèi xīn shèng mǎn chōng shí yǔ gǎn dòng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动'),
  1,
  ARRAY['我们','的','生命','开出','五彩斑斓','回首']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动'),
  2,
  ARRAY['要有','要','让','白纸','以往']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动'),
  3,
  ARRAY['般','花朵','满','感动']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动'),
  4,
  ARRAY['梦想','原本','使得','内心','与']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动'),
  5,
  ARRAY['执着','追求','充实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '我们要有执着追求的梦想，要让原本白纸般的生命开出五彩斑斓的花朵，回首以往，使得内心盛满充实与感动'),
  6,
  ARRAY['盛']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳',
  'jiǔ bù shí xiàn de yuàn wàng yě chéng le mèng xiǎng ， chéng le sù yuàn ， chéng le xīn zhōng de tòng 。 rán ér wǒ yī rán xiāng xìn ， yī rán zhí zhuó yú wǒ de mèng xiǎng 。 bǎ yǎn lèi zhǒng zài xīn shàng ， huì kāi chū yǒng gǎn de huā ， kě yǐ zài pí bèi de shí guāng ， bì shàng yǎn jīng wén dào fēn fāng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳'),
  1,
  ARRAY['不','的','我','在心','上','会','开出','在','时光']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳'),
  2,
  ARRAY['也','然而','眼泪','可以','眼睛']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳'),
  3,
  ARRAY['久','实现的','愿望','成了','夙愿','心中','相信','于我','把','种','花','闻到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳'),
  4,
  ARRAY['梦想','勇敢的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳'),
  5,
  ARRAY['痛','依然','执着','疲惫的','闭上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '久不实现的愿望也成了梦想，成了夙愿，成了心中的痛。然而我依然相信，依然执着于我的梦想。把眼泪种在心上，会开出勇敢的花，可以在疲惫的时光，闭上眼睛闻到芬芳'),
  ARRAY['芬','芳']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '在你的生命中，不要让别人来告诉你，你做不到。如果你有一个梦想，并对它满怀激情，你一定要保护它。当别人做不到一件事实，他们就会告诉你 你也做不到；但这不是事实。别人的永远都不会绝对发生在你身上',
  'zài nǐ de shēng mìng zhòng ， bú yào ràng bié rén lái gào sù nǐ ， nǐ zuò bú dào 。 rú guǒ nǐ yǒu yí gè mèng xiǎng ， bìng duì tā mǎn huái jī qíng ， nǐ yí dìng yào bǎo hù tā 。 dāng bié rén zuò bú dào yí jiàn shì shí ， tā men jiù huì gào sù nǐ   nǐ yě zuò bú dào ； dàn zhè bú shì shì shí 。 bié rén de yǒng yuǎn dōu bú huì jué duì fā shēng zài nǐ shēn shàng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你的生命中，不要让别人来告诉你，你做不到。如果你有一个梦想，并对它满怀激情，你一定要保护它。当别人做不到一件事实，他们就会告诉你 你也做不到；但这不是事实。别人的永远都不会绝对发生在你身上'),
  1,
  ARRAY['在','你的','生命','中','不要','来','你','做不到','你有','一个','对','一定要','一件事','他们','会','这','不是','的','都','不会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你的生命中，不要让别人来告诉你，你做不到。如果你有一个梦想，并对它满怀激情，你一定要保护它。当别人做不到一件事实，他们就会告诉你 你也做不到；但这不是事实。别人的永远都不会绝对发生在你身上'),
  2,
  ARRAY['让','别人','告诉','它','就','也','但','事实','身上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你的生命中，不要让别人来告诉你，你做不到。如果你有一个梦想，并对它满怀激情，你一定要保护它。当别人做不到一件事实，他们就会告诉你 你也做不到；但这不是事实。别人的永远都不会绝对发生在你身上'),
  3,
  ARRAY['如果','满怀','当','实','发生在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你的生命中，不要让别人来告诉你，你做不到。如果你有一个梦想，并对它满怀激情，你一定要保护它。当别人做不到一件事实，他们就会告诉你 你也做不到；但这不是事实。别人的永远都不会绝对发生在你身上'),
  4,
  ARRAY['梦想','并','激情','保护','永远','绝对']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意',
  'chéng gōng xū yào bā gè " cóng bù " ： cóng bú fàng qì mèng xiǎng ， cóng bú xiè dài nǔ lì ， cóng bù yí wàng yǒu qíng ， cóng bù shū hū lián xì ， cóng bú cuò guò xìn xī ， cóng bù sōng kāi jiān chí ， cóng bù mí máng mù biāo ， cóng bù sān xīn èr yì',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意'),
  1,
  ARRAY['八','个','友情','三心二意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意'),
  2,
  ARRAY['从不','错过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意'),
  3,
  ARRAY['成功','需要','放弃','努力','信息','目标']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意'),
  4,
  ARRAY['梦想','联系','松开','坚持','迷茫']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意'),
  5,
  ARRAY['遗忘']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '成功需要八个"从不"：从不放弃梦想，从不懈怠努力，从不遗忘友情，从不疏忽联系，从不错过信息，从不松开坚持，从不迷茫目标，从不三心二意'),
  6,
  ARRAY['懈怠','疏忽']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明',
  'rú guǒ nǐ yào zuò yí jiàn shì ， qǐng bú yào xuàn yào ， yě bú yào xuān yáng ， zhǐ guǎn ān ān jìng jìng dì qù zuò 。 yīn wèi nà shì nǐ zì jǐ de shì ， bié rén bù zhī dào nǐ de qíng kuàng ， yě bù kě néng bāng nǐ qù shí xiàn 。 qiān wàn bú yào yīn wèi xū róng xīn ér xuàn yào 。 yě bú yào yīn wèi bié rén de yí jù píng jià ér fàng qì zì jǐ de mèng xiǎng 。 qí shí zuì hǎo de zhuàng tài ， shì jiān chí zì jǐ de mèng xiǎng ， tīng tīng qián bèi de jiàn yì ， shǎo cuò jǐ bù 。 zhí bu zhí ， shí jiān shì zuì hǎo de zhèng míng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明'),
  1,
  ARRAY['你','做','一件事','请','不要','去','那是','你自己','的','不知道','你的','一句','是','听听','前辈','少','几','不值','时间']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明'),
  2,
  ARRAY['要','也不','因为','事','别人','情况','可能','帮','千万','最好的','错','步']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明'),
  3,
  ARRAY['如果','只管','安安静静','地','实现','而','放弃','自己的','其实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明'),
  4,
  ARRAY['评价','梦想','坚持','建议','值','证明']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明'),
  5,
  ARRAY['宣扬','虚荣心','状态']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你要做一件事，请不要炫耀，也不要宣扬，只管安安静静地去做。因为那是你自己的事，别人不知道你的情况，也不可能帮你去实现。千万不要因为虚荣心而炫耀。也不要因为别人的一句评价而放弃自己的梦想。其实最好的状态，是坚持自己的梦想，听听前辈的建议，少错几步。值不值，时间是最好的证明'),
  6,
  ARRAY['炫耀']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要轻易把梦想寄托在某个人身上，也不要太在乎身旁的耳语，因为未来是你自己的，只有你自己能给自己最大的安全感',
  'bú yào qīng yì bǎ mèng xiǎng jì tuō zài mǒu gè rén shēn shàng ， yě bú yào tài zài hū shēn páng de ěr yǔ ， yīn wèi wèi lái shì nǐ zì jǐ de ， zhǐ yǒu nǐ zì jǐ néng gěi zì jǐ zuì dà de ān quán gǎn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要太在乎身旁的耳语，因为未来是你自己的，只有你自己能给自己最大的安全感'),
  1,
  ARRAY['不要','在','人身','上','太','在乎','的','是','你自己','能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要太在乎身旁的耳语，因为未来是你自己的，只有你自己能给自己最大的安全感'),
  2,
  ARRAY['也不','要','身旁','因为','给','最大的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要太在乎身旁的耳语，因为未来是你自己的，只有你自己能给自己最大的安全感'),
  3,
  ARRAY['轻易','把','耳语','只有','自己','安全感']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要太在乎身旁的耳语，因为未来是你自己的，只有你自己能给自己最大的安全感'),
  4,
  ARRAY['梦想','寄托']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要轻易把梦想寄托在某个人身上，也不要太在乎身旁的耳语，因为未来是你自己的，只有你自己能给自己最大的安全感'),
  5,
  ARRAY['某个','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你想得越多，顾虑就越多；什么都不想的时候反而能一往直前。你害怕得越多，困难就越多；什么都不怕的时候一切反而没那么难。别害怕别顾虑，想到就去做。这世界就是这样，当你把不敢去实现梦想的时候梦想会离你越来越远，当你勇敢地去追梦的时候，全世界都会来帮你',
  'nǐ xiǎng dé yuè duō ， gù lǜ jiù yuè duō ； shén me dōu bù xiǎng de shí hòu fǎn ér néng yì wǎng zhí qián 。 nǐ hài pà dé yuè duō ， kùn nán jiù yuè duō ； shén me dōu bú pà de shí hòu yí qiè fǎn ér méi nà me nán 。 bié hài pà bié gù lǜ ， xiǎng dào jiù qù zuò 。 zhè shì jiè jiù shì zhè yàng ， dāng nǐ bǎ bù gǎn qù shí xiàn mèng xiǎng de shí hòu mèng xiǎng huì lí nǐ yuè lái yuè yuǎn ， dāng nǐ yǒng gǎn dì qù zhuī mèng de shí hòu ， quán shì jiè dōu huì lái bāng nǐ',
  'Bạn càng nghĩ nhiều, càng có nhiều lo lắng; khi không nghĩ gì cả, bạn lại có thể tiến lên phía trước. Bạn càng sợ hãi, khó khăn càng nhiều; khi không còn sợ gì nữa, mọi thứ lại không quá khó khăn. Đừng sợ hãi, đừng lo lắng, cứ nghĩ đến thì hãy làm. Thế giới này là như vậy, khi bạn không dám thực hiện ước mơ, ước mơ sẽ ngày càng xa bạn, khi bạn dũng cảm theo đuổi ước mơ, cả thế giới sẽ giúp bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你想得越多，顾虑就越多；什么都不想的时候反而能一往直前。你害怕得越多，困难就越多；什么都不怕的时候一切反而没那么难。别害怕别顾虑，想到就去做。这世界就是这样，当你把不敢去实现梦想的时候梦想会离你越来越远，当你勇敢地去追梦的时候，全世界都会来帮你'),
  1,
  ARRAY['你','想得','多','什么','都','不想','的','时候','能','一往直前','不怕','一切','没','那么','想到','去','做','这','这样','不敢','会','都会','来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你想得越多，顾虑就越多；什么都不想的时候反而能一往直前。你害怕得越多，困难就越多；什么都不怕的时候一切反而没那么难。别害怕别顾虑，想到就去做。这世界就是这样，当你把不敢去实现梦想的时候梦想会离你越来越远，当你勇敢地去追梦的时候，全世界都会来帮你'),
  2,
  ARRAY['就','得','别','就是','离','远','帮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你想得越多，顾虑就越多；什么都不想的时候反而能一往直前。你害怕得越多，困难就越多；什么都不怕的时候一切反而没那么难。别害怕别顾虑，想到就去做。这世界就是这样，当你把不敢去实现梦想的时候梦想会离你越来越远，当你勇敢地去追梦的时候，全世界都会来帮你'),
  3,
  ARRAY['越','顾虑','害怕','难','世界','当','把','实现','越来越']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你想得越多，顾虑就越多；什么都不想的时候反而能一往直前。你害怕得越多，困难就越多；什么都不怕的时候一切反而没那么难。别害怕别顾虑，想到就去做。这世界就是这样，当你把不敢去实现梦想的时候梦想会离你越来越远，当你勇敢地去追梦的时候，全世界都会来帮你'),
  4,
  ARRAY['反而','困难','梦想的','梦想','勇敢地','梦的','全世界']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你想得越多，顾虑就越多；什么都不想的时候反而能一往直前。你害怕得越多，困难就越多；什么都不怕的时候一切反而没那么难。别害怕别顾虑，想到就去做。这世界就是这样，当你把不敢去实现梦想的时候梦想会离你越来越远，当你勇敢地去追梦的时候，全世界都会来帮你'),
  5,
  ARRAY['追']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '没有钱，没有经验，没有阅历，没有社会关系，这些都不可怕。没有钱，可以通过辛勤劳动去赚；没有经验，可以通过实践操作去总结；没有阅历，可以一步一步去积累；没有社会关系，可以一点一点去编织。但是，没有梦想，没有方向才是最可怕的',
  'méi yǒu qián ， méi yǒu jīng yàn ， méi yǒu yuè lì ， méi yǒu shè huì guān xì ， zhè xiē dōu bù kě pà 。 méi yǒu qián ， kě yǐ tōng guò xīn qín láo dòng qù zhuàn ； méi yǒu jīng yàn ， kě yǐ tōng guò shí jiàn cāo zuò qù zǒng jié ； méi yǒu yuè lì ， kě yǐ yí bù yi bù qù jī lěi ； méi yǒu shè huì guān xì ， kě yǐ yì diǎn yi diǎn qù biān zhī 。 dàn shì ， méi yǒu mèng xiǎng ， méi yǒu fāng xiàng cái shì zuì kě pà de',
  'Không có tiền, không có kinh nghiệm, không có trải nghiệm, không có mối quan hệ xã hội, tất cả những điều này đều không đáng sợ. Không có tiền, có thể kiếm bằng lao động chăm chỉ; không có kinh nghiệm, có thể rút ra từ thực hành; không có trải nghiệm, có thể tích lũy từng bước; không có mối quan hệ xã hội, có thể xây dựng từng chút một. Nhưng không có ước mơ, không có phương hướng mới là điều đáng sợ nhất.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有钱，没有经验，没有阅历，没有社会关系，这些都不可怕。没有钱，可以通过辛勤劳动去赚；没有经验，可以通过实践操作去总结；没有阅历，可以一步一步去积累；没有社会关系，可以一点一点去编织。但是，没有梦想，没有方向才是最可怕的'),
  1,
  ARRAY['没有钱','没有经验','没有','这些','都','不可','去','一步','一点一','点']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有钱，没有经验，没有阅历，没有社会关系，这些都不可怕。没有钱，可以通过辛勤劳动去赚；没有经验，可以通过实践操作去总结；没有阅历，可以一步一步去积累；没有社会关系，可以一点一点去编织。但是，没有梦想，没有方向才是最可怕的'),
  2,
  ARRAY['可以','但是','最','可怕的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有钱，没有经验，没有阅历，没有社会关系，这些都不可怕。没有钱，可以通过辛勤劳动去赚；没有经验，可以通过实践操作去总结；没有阅历，可以一步一步去积累；没有社会关系，可以一点一点去编织。但是，没有梦想，没有方向才是最可怕的'),
  3,
  ARRAY['怕','实践','总结','方向','才是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有钱，没有经验，没有阅历，没有社会关系，这些都不可怕。没有钱，可以通过辛勤劳动去赚；没有经验，可以通过实践操作去总结；没有阅历，可以一步一步去积累；没有社会关系，可以一点一点去编织。但是，没有梦想，没有方向才是最可怕的'),
  4,
  ARRAY['阅历','社会关系','通过','辛勤','赚','积累','梦想']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有钱，没有经验，没有阅历，没有社会关系，这些都不可怕。没有钱，可以通过辛勤劳动去赚；没有经验，可以通过实践操作去总结；没有阅历，可以一步一步去积累；没有社会关系，可以一点一点去编织。但是，没有梦想，没有方向才是最可怕的'),
  5,
  ARRAY['劳动','操作','编织']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己',
  'dāng nǐ huí gù céng jīng zǒu guò de lù shí huì fā xiàn ， nǐ jū rán zài bù zhī bù jué zhōng ， dào dá le céng jīng mèng mèi yǐ qiú de gāo dù ， xiàn zài de zì jǐ ， zhèng shì nián qīng shí hún qiān mèng rào guò qiān bǎi huí de nà ge zì jǐ',
  'Khi bạn nhìn lại con đường đã đi qua, bạn sẽ phát hiện ra rằng, trong vô thức, bạn đã đạt được độ cao mà bạn từng mơ ước, con người hiện tại của bạn chính là hình bóng mà bạn từng khao khát hàng trăm lần khi còn trẻ.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己'),
  1,
  ARRAY['你','回顾','的','时会','在','不知不觉中','了','高度','现在的','年轻时','回','那个']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己'),
  2,
  ARRAY['走过','路','到达','正是','过','千百']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己'),
  3,
  ARRAY['当','发现','居然','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己'),
  4,
  ARRAY['梦寐以求']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己'),
  5,
  ARRAY['曾经']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你回顾曾经走过的路时会发现，你居然在不知不觉中，到达了曾经梦寐以求的高度，现在的自己，正是年轻时魂牵梦绕过千百回的那个自己'),
  6,
  ARRAY['魂牵梦绕']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不管当下的我们有没有人爱，我们也要努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路',
  'bù guǎn dāng xià de wǒ men yǒu méi yǒu rén ài ， wǒ men yě yào nǔ lì zuò yí gè kě ài de rén 。 bù mán yuàn shuí ， bù cháo xiào shuí ， yě bú xiàn mù shuí ， yáng guāng xià càn làn ， fēng yǔ zhōng bēn pǎo ， zuò zì jǐ de mèng ， zǒu zì jǐ de lù',
  'Dù hiện tại có ai yêu chúng ta hay không, chúng ta vẫn nên cố gắng để trở thành một người đáng yêu. Không oán trách ai, không chế giễu ai, không ghen tị với ai, rực rỡ dưới ánh mặt trời, chạy trong mưa gió, theo đuổi giấc mơ của mình, đi trên con đường của mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管当下的我们有没有人爱，我们也要努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路'),
  1,
  ARRAY['不管','的','我们有','没有人','爱','我们','一个','不','谁','下','中','做自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管当下的我们有没有人爱，我们也要努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路'),
  2,
  ARRAY['也','要','可爱的人','也不','走','路']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管当下的我们有没有人爱，我们也要努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路'),
  3,
  ARRAY['当下','努力做','阳光','风雨','自己的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管当下的我们有没有人爱，我们也要努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路'),
  4,
  ARRAY['羡慕','梦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管当下的我们有没有人爱，我们也要努力做一个可爱的人。不埋怨谁，不嘲笑谁，也不羡慕谁，阳光下灿烂，风雨中奔跑，做自己的梦，走自己的路'),
  6,
  ARRAY['埋怨','嘲笑','灿烂','奔跑']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪',
  'mèng xiǎng shì yí gè " shuāng miàn rén " ： zài nián shào de shí hòu ， tā lí rén men nà me yuǎn ， nà me miǎo máng ， nà me bù zhēn shí ； ér zài zhuàng nián shí ， tā lí rén men nà me jìn ， nà me qīng xī ， nà me lìng rén zhèn fèn 。 yīn wèi ， zhuàng nián shí de rén men qǔ dé le chéng jiù ， yǐ jīng chāo yuè le zì wǒ ， ér zài nà chéng gōng de bèi hòu ， sǎ xià de shì shù bú jìn de hàn dī yǔ xuè lèi',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪'),
  1,
  ARRAY['是','一个','人','在','年少的','时候','人们','那么','不','在壮年','时','的','了','那','下的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪'),
  2,
  ARRAY['它','离','远','真实','近','因为','已经']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪'),
  3,
  ARRAY['双面','而','清晰','成就','超越','自我','成功的','数不尽的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪'),
  4,
  ARRAY['梦想','取得','汗','与']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪'),
  5,
  ARRAY['令人振奋','背后','洒','滴','血泪']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '梦想是一个"双面人"：在年少的时候，它离人们那么远，那么渺茫，那么不真实；而在壮年时，它离人们那么近，那么清晰，那么令人振奋。因为，壮年时的人们取得了成就，已经超越了自我，而在那成功的背后，洒下的是数不尽的汗滴与血泪'),
  6,
  ARRAY['渺茫','壮年']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '只有无所期待，无所事事的人才会觉得人生之苦，因为他的格局就那么大，能体验到的感觉就那么少，他的人生是由"苦"和"不苦"来定义，而怀揣梦想的人的人生却是由"不苦"和"乐"来定义的',
  'zhǐ yǒu wú suǒ qī dài ， wú suǒ shì shì de rén cái huì jué de rén shēng zhī kǔ ， yīn wèi tā de gé jú jiù nà me dà ， néng tǐ yàn dào de gǎn jué jiù nà me shǎo ， tā de rén shēng shì yóu " kǔ " hé " bù kǔ " lái dìng yì ， ér huái chuāi mèng xiǎng de rén de rén shēng què shì yóu " bù kǔ " hé " lè " lái dìng yì de',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有无所期待，无所事事的人才会觉得人生之苦，因为他的格局就那么大，能体验到的感觉就那么少，他的人生是由"苦"和"不苦"来定义，而怀揣梦想的人的人生却是由"不苦"和"乐"来定义的'),
  1,
  ARRAY['期待','人才','会','觉得','人生','他的','那么','大','能','的','少','是','和','不','来','人的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有无所期待，无所事事的人才会觉得人生之苦，因为他的格局就那么大，能体验到的感觉就那么少，他的人生是由"苦"和"不苦"来定义，而怀揣梦想的人的人生却是由"不苦"和"乐"来定义的'),
  2,
  ARRAY['所','因为','就','体验','到','乐']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有无所期待，无所事事的人才会觉得人生之苦，因为他的格局就那么大，能体验到的感觉就那么少，他的人生是由"苦"和"不苦"来定义，而怀揣梦想的人的人生却是由"不苦"和"乐"来定义的'),
  3,
  ARRAY['只有','感觉','定义','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有无所期待，无所事事的人才会觉得人生之苦，因为他的格局就那么大，能体验到的感觉就那么少，他的人生是由"苦"和"不苦"来定义，而怀揣梦想的人的人生却是由"不苦"和"乐"来定义的'),
  4,
  ARRAY['无','无所事事的','之','苦','格局','由','怀揣','梦想的','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想',
  'nǐ de míng zì xiě xià lái bú guò jǐ lí mǐ cháng ， què guàn chuān le wǒ zhè me cháng shí guāng 。 qí shí nǐ bù zhī dào ， nǐ yì zhí shì wǒ de mèng xiǎng',
  'Tên của bạn viết ra chỉ dài vài centimet, nhưng lại xuyên suốt thời gian dài của tôi. Thực ra bạn không biết, bạn luôn là giấc mơ của tôi.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想'),
  1,
  ARRAY['你的','名字','写下来','不过','几','了','我','这么','你','不知道','一直','是','我的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想'),
  2,
  ARRAY['长','长时']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想'),
  3,
  ARRAY['其实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想'),
  4,
  ARRAY['却','光','梦想']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想'),
  5,
  ARRAY['厘米']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你的名字写下来不过几厘米长，却贯穿了我这么长时光。其实你不知道，你一直是我的梦想'),
  6,
  ARRAY['贯穿']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不管你有多大的梦想，有多牛的想法，有再多的兴趣爱好，但，一懒毁终生。别让懒惰吞噬了你的梦想',
  'bù guǎn nǐ yǒu duō dà de mèng xiǎng ， yǒu duō niú de xiǎng fǎ ， yǒu zài duō de xìng qù ài hào ， dàn ， yì lǎn huǐ zhōng shēng 。 bié ràng lǎn duò tūn shì le nǐ de mèng xiǎng',
  'Dù bạn có ước mơ lớn đến đâu, có những ý tưởng tuyệt vời thế nào, có nhiều sở thích ra sao, nhưng, chỉ một chút lười biếng cũng có thể hủy hoại cả đời. Đừng để sự lười biếng nuốt chửng giấc mơ của bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管你有多大的梦想，有多牛的想法，有再多的兴趣爱好，但，一懒毁终生。别让懒惰吞噬了你的梦想'),
  1,
  ARRAY['不管','你有','多大','的','有','多','想法','再','多的','兴趣','爱好','一','了','你的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管你有多大的梦想，有多牛的想法，有再多的兴趣爱好，但，一懒毁终生。别让懒惰吞噬了你的梦想'),
  2,
  ARRAY['牛的','但','别让']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管你有多大的梦想，有多牛的想法，有再多的兴趣爱好，但，一懒毁终生。别让懒惰吞噬了你的梦想'),
  3,
  ARRAY['终生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管你有多大的梦想，有多牛的想法，有再多的兴趣爱好，但，一懒毁终生。别让懒惰吞噬了你的梦想'),
  4,
  ARRAY['梦想','懒','懒惰']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管你有多大的梦想，有多牛的想法，有再多的兴趣爱好，但，一懒毁终生。别让懒惰吞噬了你的梦想'),
  6,
  ARRAY['毁','吞噬']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '就算怀揣世上最伟大的梦想，也不妨碍我们得到一个普通人的快乐。这世上只有一种成功。，就是以自己喜欢的方式过一生',
  'jiù suàn huái chuāi shì shàng zuì wěi dà de mèng xiǎng ， yě bù fáng ài wǒ men dé dào yí gè pǔ tōng rén de kuài lè 。 zhè shì shàng zhǐ yǒu yì zhǒng chéng gōng 。 ， jiù shì yǐ zì jǐ xǐ huan de fāng shì guò yì shēng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '就算怀揣世上最伟大的梦想，也不妨碍我们得到一个普通人的快乐。这世上只有一种成功。，就是以自己喜欢的方式过一生'),
  1,
  ARRAY['我们','一个','的','这','一种','喜欢的','一生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '就算怀揣世上最伟大的梦想，也不妨碍我们得到一个普通人的快乐。这世上只有一种成功。，就是以自己喜欢的方式过一生'),
  2,
  ARRAY['就算','最伟大的','也不','得到','快乐','就是','以','过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '就算怀揣世上最伟大的梦想，也不妨碍我们得到一个普通人的快乐。这世上只有一种成功。，就是以自己喜欢的方式过一生'),
  3,
  ARRAY['世上','只有','成功','自己','方式']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '就算怀揣世上最伟大的梦想，也不妨碍我们得到一个普通人的快乐。这世上只有一种成功。，就是以自己喜欢的方式过一生'),
  4,
  ARRAY['怀揣','梦想','普通人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '就算怀揣世上最伟大的梦想，也不妨碍我们得到一个普通人的快乐。这世上只有一种成功。，就是以自己喜欢的方式过一生'),
  5,
  ARRAY['妨碍']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈',
  'hěn duō shì què shí bú shì suǒ yǒu nián qīng gū niáng dōu chéng shòu dé le de 。 bī zhe nǐ wǎng qián zǒu de ， bú shì qián fāng mèng xiǎng de wēi ruò guāng máng ， ér shì shēn hòu xiàn shí de shēn yuān wàn zhàng',
  'Có rất nhiều điều thực sự không phải cô gái trẻ nào cũng có thể chịu đựng được. Điều thúc đẩy bạn tiến về phía trước không phải là ánh sáng yếu ớt của ước mơ phía trước, mà là vực thẳm của hiện thực phía sau lưng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈'),
  1,
  ARRAY['很多','不是','年轻','都','的','你','前方','现实的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈'),
  2,
  ARRAY['事','所有','得了','着','往前走','身后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈'),
  3,
  ARRAY['而是','万丈']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈'),
  4,
  ARRAY['确实','梦想的','微弱','光芒','深渊']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈'),
  5,
  ARRAY['姑娘','承受']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多事确实不是所有年轻姑娘都承受得了的。逼着你往前走的，不是前方梦想的微弱光芒，而是身后现实的深渊万丈'),
  6,
  ARRAY['逼']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪',
  'měi yí cì yáng qǐ fēng fān qù yuǎn háng ， dōu nán miǎn huì yǒu zǔ dǎng ， zhǐ yào yǒu mèng xiǎng zài xīn zhōng ， wèi lái jiù chōng mǎn zhe xī wàng ； měi yí cì zhāng kāi chì bǎng qù fēi xiáng ， dōu nán miǎn huì shòu shāng ， zhī yào yǒu mèng xiǎng zài jī lì ， wèi lái jiù chéng zài zhe xī wàng 。 mèng xiǎng ， zài xīn zhōng mái cáng ， tā yǐ jīng zài màn màn zǒu lái ， gěi rén men dài lái xī wàng ， guāng máng hé qǐ dí',
  'Mỗi lần căng buồm ra khơi, khó tránh khỏi những trở ngại, nhưng chỉ cần ước mơ còn trong tim, tương lai sẽ tràn đầy hy vọng; mỗi lần dang cánh bay lên, khó tránh khỏi tổn thương, nhưng chỉ cần ước mơ vẫn thôi thúc, tương lai sẽ chất chứa hy vọng. Ước mơ, dù được chôn giấu trong lòng, nhưng nó đã dần dần đến gần, mang đến cho con người niềm hy vọng, ánh sáng và sự khai sáng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪'),
  1,
  ARRAY['去','都','会','有','在心中','飞翔','在','来','人们','和']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪'),
  2,
  ARRAY['每一','次','远航','就','希望','着','它','已经','慢慢走','给']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪'),
  3,
  ARRAY['风帆','难免','只要','张开','带来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪'),
  4,
  ARRAY['扬起','梦想','受伤','激励','光芒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪'),
  5,
  ARRAY['阻挡','未来','充满着','翅膀','承载','启迪']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每一次扬起风帆去远航，都难免会有阻挡，只要有梦想在心中，未来就充满着希望；每一次张开翅膀去飞翔，都难免会受伤，只要有梦想在激励，未来就承载着希望。梦想，在心中埋藏，它已经在慢慢走来，给人们带来希望，光芒和启迪'),
  6,
  ARRAY['埋藏']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程',
  'rén shēng zuì dà de chéng běn ， jiù shì zài cuò wù de rén jì quān lǐ ， bù zhī bù jué hào jìn yì shēng ， lù lù wú wéi dù guò yì shēng 。 rén shēng zuì dà de xǐ yuè ， jiù shì yù jiàn bǐ cǐ de nà yì zhǎn dēng ， nǐ diǎn rán wǒ de jī qíng ， wǒ diǎn rán nǐ de mèng xiǎng ； nǐ zhào liàng wǒ de qián tú ， wǒ zhǐ yǐn nǐ zǒu guò hēi àn de lǚ chéng',
  'Chi phí lớn nhất của đời người chính là vô tình tiêu phí cả cuộc đời trong những mối quan hệ sai lầm, sống qua ngày mà không làm nên điều gì. Niềm vui lớn nhất của đời người là gặp được ngọn đèn soi sáng lẫn nhau, bạn thắp lên ngọn lửa đam mê trong tôi, tôi thắp sáng ước mơ của bạn; bạn chiếu sáng con đường phía trước của tôi, tôi dẫn lối cho bạn qua những hành trình tối tăm.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  1,
  ARRAY['人生','在','人','里','不知不觉','一生','喜悦','那','一','你','点燃','我的','我','你的','前途']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  2,
  ARRAY['最大的','就是','错误的','走过','黑暗的','旅程']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  3,
  ARRAY['成本','遇见','灯','照亮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  4,
  ARRAY['济','度过一生','激情','梦想','指引']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  5,
  ARRAY['圈','彼此的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  6,
  ARRAY['耗尽','碌碌无为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最大的成本，就是在错误的人济圈里，不知不觉耗尽一生，碌碌无为度过一生。人生最大的喜悦，就是遇见彼此的那一盏灯，你点燃我的激情，我点燃你的梦想；你照亮我的前途，我指引你走过黑暗的旅程'),
  ARRAY['盏']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水',
  'bú yào yīn wèi méi yǒu yáng guāng ， ér zǒu bú jìn chūn tiān ； bú yào yīn wèi méi yǒu gē shēng ， ér fàng qì zì jǐ de zhuī qiú ； bú yào yīn wèi méi yǒu zhǎng shēng ， ér diū diào zì jǐ de lǐ xiǎng 。 qí shí měi yì tiáo tōng wǎng yáng guāng de dà dào ， dōu chōng mǎn kǎn kě 。 měi yì tiáo tōng xiàng lǐ xiǎng de tú jìng ， dōu chōng mǎn le jiān xīn yǔ hàn shuǐ',
  'Đừng vì thiếu ánh nắng mà không thể bước vào mùa xuân; đừng vì thiếu tiếng ca mà từ bỏ khát vọng của mình; đừng vì thiếu tiếng vỗ tay mà đánh mất lý tưởng. Thật ra, mỗi con đường dẫn đến ánh sáng đều đầy rẫy chông gai. Mỗi con đường dẫn đến ước mơ đều ngập tràn khó khăn và mồ hôi.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水'),
  1,
  ARRAY['不要','不','的','大道','都','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水'),
  2,
  ARRAY['因为没有','走','进','歌声','每一','条']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水'),
  3,
  ARRAY['阳光','而','春天','放弃','自己的','理想','其实','理想的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水'),
  4,
  ARRAY['丢掉','通往','通向','与','汗水']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水'),
  5,
  ARRAY['追求','掌声','充满','途径','艰辛']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要因为没有阳光，而走不进春天；不要因为没有歌声，而放弃自己的追求；不要因为没有掌声，而丢掉自己的理想。其实每一条通往阳光的大道，都充满坎坷。每一条通向理想的途径，都充满了艰辛与汗水'),
  ARRAY['坎','坷']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有梦想就立即动身吧，不要迟疑，别让明天的你，讨厌今天的自己。最可怕的不是你不够努力，而是比你聪明的人比你还要努力',
  'yǒu mèng xiǎng jiù lì jí dòng shēn ba ， bú yào chí yí ， bié ràng míng tiān de nǐ ， tǎo yàn jīn tiān de zì jǐ 。 zuì kě pà de bú shì nǐ bú gòu nǔ lì ， ér shì bǐ nǐ cōng ming de rén bǐ nǐ hái yào nǔ lì',
  'Nếu có ước mơ, hãy bắt đầu ngay, đừng chần chừ, đừng để bản thân của ngày mai ghét bỏ con người của hôm nay. Điều đáng sợ nhất không phải là bạn không đủ nỗ lực, mà là những người thông minh hơn bạn còn đang cố gắng hơn bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想就立即动身吧，不要迟疑，别让明天的你，讨厌今天的自己。最可怕的不是你不够努力，而是比你聪明的人比你还要努力'),
  1,
  ARRAY['有','不要','明天','的','你','今天','不是','不够','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想就立即动身吧，不要迟疑，别让明天的你，讨厌今天的自己。最可怕的不是你不够努力，而是比你聪明的人比你还要努力'),
  2,
  ARRAY['就','动身','吧','别让','最','可怕的','比','还要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想就立即动身吧，不要迟疑，别让明天的你，讨厌今天的自己。最可怕的不是你不够努力，而是比你聪明的人比你还要努力'),
  3,
  ARRAY['迟疑','自己','努力','而是','聪明的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想就立即动身吧，不要迟疑，别让明天的你，讨厌今天的自己。最可怕的不是你不够努力，而是比你聪明的人比你还要努力'),
  4,
  ARRAY['梦想','讨厌']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想就立即动身吧，不要迟疑，别让明天的你，讨厌今天的自己。最可怕的不是你不够努力，而是比你聪明的人比你还要努力'),
  5,
  ARRAY['立即']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有梦想的人不做选择题，只做证明题，所以，年轻的你，可以犯错，可以跌倒，但千万不要怀疑自己，也不要放弃梦想。去想去地方，做该做的事情，不迟疑，不徘徊',
  'yǒu mèng xiǎng de rén bú zuò xuǎn zé tí ， zhī zuò zhèng míng tí ， suǒ yǐ ， nián qīng de nǐ ， kě yǐ fàn cuò ， kě yǐ diē dǎo ， dàn qiān wàn bú yào huái yí zì jǐ ， yě bú yào fàng qì mèng xiǎng 。 qù xiǎng qù dì fāng ， zuò gāi zuò de shì qíng ， bù chí yí ， bù pái huái',
  'Người có ước mơ không làm câu hỏi lựa chọn, mà chỉ làm câu hỏi chứng minh. Vì vậy, bạn trẻ à, bạn có thể mắc sai lầm, có thể vấp ngã, nhưng tuyệt đối đừng nghi ngờ bản thân và cũng đừng từ bỏ ước mơ. Hãy đến nơi bạn muốn đến, làm những việc bạn cần làm, đừng chần chừ, đừng do dự.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人不做选择题，只做证明题，所以，年轻的你，可以犯错，可以跌倒，但千万不要怀疑自己，也不要放弃梦想。去想去地方，做该做的事情，不迟疑，不徘徊'),
  1,
  ARRAY['有','人','不做','年轻的','你','不要','去','想去','做','的','不迟','不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人不做选择题，只做证明题，所以，年轻的你，可以犯错，可以跌倒，但千万不要怀疑自己，也不要放弃梦想。去想去地方，做该做的事情，不迟疑，不徘徊'),
  2,
  ARRAY['题','所以','可以','但','千万','也不','要','事情']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人不做选择题，只做证明题，所以，年轻的你，可以犯错，可以跌倒，但千万不要怀疑自己，也不要放弃梦想。去想去地方，做该做的事情，不迟疑，不徘徊'),
  3,
  ARRAY['选择题','只做','自己','放弃','地方','该']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人不做选择题，只做证明题，所以，年轻的你，可以犯错，可以跌倒，但千万不要怀疑自己，也不要放弃梦想。去想去地方，做该做的事情，不迟疑，不徘徊'),
  4,
  ARRAY['梦想的','证明','怀疑','梦想','疑']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人不做选择题，只做证明题，所以，年轻的你，可以犯错，可以跌倒，但千万不要怀疑自己，也不要放弃梦想。去想去地方，做该做的事情，不迟疑，不徘徊'),
  6,
  ARRAY['犯错','跌倒','徘徊']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '一个人能否成功，关键在于他的心态是否积极。成功者之所以能，是因为相信自己能。每天揣着梦想出门，天会更蓝，云会更白',
  'yí gè rén néng fǒu chéng gōng ， guān jiàn zài yú tā de xīn tài shì fǒu jī jí 。 chéng gōng zhě zhī suǒ yǐ néng ， shì yīn wèi xiāng xìn zì jǐ néng 。 měi tiān chuāi zhe mèng xiǎng chū mén ， tiān huì gèng lán ， yún huì gèng bái',
  'Một người có thể thành công hay không, điều quan trọng nhất nằm ở việc tâm thái của họ có tích cực hay không. Người thành công là bởi vì họ tin rằng mình có thể. Mỗi ngày mang theo ước mơ ra khỏi nhà, bầu trời sẽ xanh hơn, mây sẽ trắng hơn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人能否成功，关键在于他的心态是否积极。成功者之所以能，是因为相信自己能。每天揣着梦想出门，天会更蓝，云会更白'),
  1,
  ARRAY['一个人','能否','关键','在于','他的','是否','能','是因为','出门','天会','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人能否成功，关键在于他的心态是否积极。成功者之所以能，是因为相信自己能。每天揣着梦想出门，天会更蓝，云会更白'),
  2,
  ARRAY['每天','着','白']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人能否成功，关键在于他的心态是否积极。成功者之所以能，是因为相信自己能。每天揣着梦想出门，天会更蓝，云会更白'),
  3,
  ARRAY['成功','心态','成功者','相信','自己','更','蓝']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人能否成功，关键在于他的心态是否积极。成功者之所以能，是因为相信自己能。每天揣着梦想出门，天会更蓝，云会更白'),
  4,
  ARRAY['积极','之所以','梦想','云']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人能否成功，关键在于他的心态是否积极。成功者之所以能，是因为相信自己能。每天揣着梦想出门，天会更蓝，云会更白'),
  ARRAY['揣']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人',
  'dāng nǐ yuè lái yuè piāo liàng shí ， zì rán yǒu rén guān zhù nǐ 。 dāng nǐ yuè lái yuè yǒu néng lì shí ， zì rán huì yǒu rén kàn de qǐ nǐ 。 gǎi biàn zì jǐ ， nǐ cái yǒu zì xìn ， mèng xiǎng cái huì màn màn dì shí xiàn 。 lǎn kě yǐ huǐ diào yí gè rén ， qín kě yǐ jī fā yí gè rén 。 zuò zuì hǎo de zì jǐ ， bú wèi bié rén ， zhī wèi zuò yí gè lián zì jǐ dōu xiàn mù de rén',
  'Khi bạn ngày càng xinh đẹp, tự nhiên sẽ có người chú ý đến bạn. Khi bạn ngày càng có năng lực, tự nhiên sẽ có người coi trọng bạn. Hãy thay đổi bản thân, bạn mới có thể tự tin, và ước mơ mới dần dần trở thành hiện thực. Lười biếng có thể hủy hoại một con người, chăm chỉ có thể khơi dậy tiềm năng của một người. Hãy trở thành phiên bản tốt nhất của chính mình, không phải vì người khác, mà chỉ để trở thành người mà ngay cả bản thân bạn cũng phải ngưỡng mộ.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人'),
  1,
  ARRAY['你','漂亮','时','有人','关注','有能力','会','看得起','有自信','一个人','做','不','一个','都','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人'),
  2,
  ARRAY['慢慢地','可以','最好的','为','别人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人'),
  3,
  ARRAY['当','越来越','自然','自己','才','实现','只']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人'),
  4,
  ARRAY['改变','梦想','懒','激发','连','羡慕的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人'),
  5,
  ARRAY['勤']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你越来越漂亮时，自然有人关注你。当你越来越有能力时，自然会有人看得起你。改变自己，你才有自信，梦想才会慢慢地实现。懒可以毁掉一个人，勤可以激发一个人。做最好的自己，不为别人，只为做一个连自己都羡慕的人'),
  6,
  ARRAY['毁掉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气',
  'hěn duō shí hòu ， wǒ men zhǐ néng hé zì jǐ de nèi xīn duì huà ， cóng zì jǐ zhè lǐ huò dé kěn dìng hé gǔ lì ， dàn zhè yě zhèng shì měi yí gè mèng xiǎng zhě suǒ bì xū jù bèi de yǒng qì 。 yǒng gǎn de rén ， bù jǐn shì kě yǐ zài miàn duì zhì yí shēng yīn de shí hòu ， jiāng jì dìng de lù jì xù zǒu xià qù ， hái zài yú néng yōng yǒu jiāng yí qiè yùn niàng yú xīn de chén wěn ， yǐ jí jí shǐ wú rén péi bàn yě néng jì xù xiàng qián de dī qì',
  'Có những lúc, chúng ta chỉ có thể đối thoại với chính trái tim mình, tự mình tìm kiếm sự khẳng định và động viên. Nhưng đây cũng chính là lòng can đảm mà mỗi người theo đuổi ước mơ cần phải có. Người dũng cảm không chỉ là người có thể tiếp tục bước đi trên con đường đã chọn khi đối mặt với những lời nghi ngờ, mà còn là người sở hữu sự điềm tĩnh để ấp ủ mọi thứ trong lòng, và có đủ nghị lực để tiến về phía trước, ngay cả khi không có ai bên cạnh.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气'),
  1,
  ARRAY['很多','时候','我们','和','对话','这里','这','的','不仅','是','在','面对','去','在于','能','一切','气']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气'),
  2,
  ARRAY['从','但','也','正是','每一个','所','可以','路','走下','还','以及']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气'),
  3,
  ARRAY['只能','自己的','自己','必须','声音的','于','心','向前的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气'),
  4,
  ARRAY['内心','获得','肯定','鼓励','梦想者','具备','勇气','勇敢的人','质疑','将','既定的','继续','即使','无人','陪伴','低']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气'),
  5,
  ARRAY['拥有','沉稳']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '很多时候，我们只能和自己的内心对话，从自己这里获得肯定和鼓励，但这也正是每一个梦想者所必须具备的勇气。勇敢的人，不仅是可以在面对质疑声音的时候，将既定的路继续走下去，还在于能拥有将一切酝酿于心的沉稳，以及即使无人陪伴也能继续向前的低气'),
  6,
  ARRAY['酝酿']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '真正的失败从来都不是结果的不仅如人意，而是拥有的时候随意挥霍，和未曾用心尝试前的轻言放弃',
  'zhēn zhèng de shī bài cóng lái dōu bú shì jié guǒ de bù jǐn rú rén yì ， ér shì yōng yǒu de shí hòu suí yì huī huò ， hé wèi céng yòng xīn cháng shì qián de qīng yán fàng qì',
  'Thất bại thực sự không nằm ở việc kết quả không như mong muốn, mà là khi bạn lãng phí những gì mình đang có, hoặc dễ dàng từ bỏ trước khi kịp nỗ lực thử.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正的失败从来都不是结果的不仅如人意，而是拥有的时候随意挥霍，和未曾用心尝试前的轻言放弃'),
  1,
  ARRAY['都','不是','不仅','人意','的','时候','和','前的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正的失败从来都不是结果的不仅如人意，而是拥有的时候随意挥霍，和未曾用心尝试前的轻言放弃'),
  2,
  ARRAY['真正的','从来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正的失败从来都不是结果的不仅如人意，而是拥有的时候随意挥霍，和未曾用心尝试前的轻言放弃'),
  3,
  ARRAY['结果的','如','而是','用心','轻','放弃']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正的失败从来都不是结果的不仅如人意，而是拥有的时候随意挥霍，和未曾用心尝试前的轻言放弃'),
  4,
  ARRAY['失败','随意','尝试','言']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正的失败从来都不是结果的不仅如人意，而是拥有的时候随意挥霍，和未曾用心尝试前的轻言放弃'),
  5,
  ARRAY['拥有','挥霍','未曾']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你所过的每一天，都是成功的前奏。你把握住了这每一天，就有机会把成功抓在手中；而你虚度的每一天，却会让你离成功越来越远',
  'nǐ suǒ guò de měi yì tiān ， dōu shì chéng gōng de qián zòu 。 nǐ bǎ wò zhù le zhè měi yì tiān ， jiù yǒu jī huì bǎ chéng gōng zhuā zài shǒu zhōng ； ér nǐ xū dù de měi yì tiān ， què huì ràng nǐ lí chéng gōng yuè lái yuè yuǎn',
  'Mỗi ngày bạn sống qua, đều là khúc dạo đầu cho thành công. Nếu bạn nắm bắt được từng ngày, bạn sẽ có cơ hội nắm giữ thành công trong tay; còn những ngày bạn lãng phí, sẽ chỉ khiến bạn càng ngày càng xa rời thành công.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所过的每一天，都是成功的前奏。你把握住了这每一天，就有机会把成功抓在手中；而你虚度的每一天，却会让你离成功越来越远'),
  1,
  ARRAY['你','的','都是','前奏','住','了','这','有机会','在','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所过的每一天，都是成功的前奏。你把握住了这每一天，就有机会把成功抓在手中；而你虚度的每一天，却会让你离成功越来越远'),
  2,
  ARRAY['所','过','每一天','就','手中','让','离','远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所过的每一天，都是成功的前奏。你把握住了这每一天，就有机会把成功抓在手中；而你虚度的每一天，却会让你离成功越来越远'),
  3,
  ARRAY['成功的','把握','把','成功','而','越来越']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所过的每一天，都是成功的前奏。你把握住了这每一天，就有机会把成功抓在手中；而你虚度的每一天，却会让你离成功越来越远'),
  4,
  ARRAY['却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你所过的每一天，都是成功的前奏。你把握住了这每一天，就有机会把成功抓在手中；而你虚度的每一天，却会让你离成功越来越远'),
  5,
  ARRAY['抓','虚度']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功',
  'jì mò shì yí duàn wú rén xiāng bàn de lǚ chéng ， shì yì fāng méi yǒu xīng guāng de yè kōng ， shì yí duàn méi yǒu gē shēng de shí guāng 。 tā shǐ kōng xū de rén gū kǔ ， shǐ qiǎn bó de rén fú zào ， shǐ ruì zhì de rén shēn chén 。 yí gè xīn zhōng yǒu mèng de rén ， yào nài dé zhù méi yǒu xīng kōng de yè wǎn ， zhǐ yǒu rěn shòu dé le hēi yè de jì mò ， cái néng yíng lái míng rì de chéng gōng',
  'Cô đơn là một hành trình không người đồng hành, là một bầu trời đêm không ánh sao, là một khoảng thời gian không tiếng ca. Nó khiến người trống rỗng thêm khổ đau, kẻ nông cạn thêm bồn chồn, nhưng người sáng suốt thêm sâu sắc. Người có ước mơ trong tim phải chịu đựng được những đêm không sao, chỉ khi vượt qua được nỗi cô đơn trong bóng tối, mới có thể đón nhận thành công của ngày mai.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功'),
  1,
  ARRAY['是','一段','的','一方','没有星光的','没有','时光','他','人','一个','有','星空','明日']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功'),
  2,
  ARRAY['旅程','歌声','要','得了','黑夜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功'),
  3,
  ARRAY['相伴','空虚的','心中','只有','才能','迎来','成功']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功'),
  4,
  ARRAY['无人','使','深沉','梦的','耐得住']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功'),
  5,
  ARRAY['寂寞','夜空','浅薄的','睿智的','夜晚','忍受']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '寂寞是一段无人相伴的旅程，是一方没有星光的夜空，是一段没有歌声的时光。他使空虚的人孤苦，使浅薄的人浮躁，使睿智的人深沉。一个心中有梦的人，要耐得住没有星空的夜晚，只有忍受得了黑夜的寂寞，才能迎来明日的成功'),
  6,
  ARRAY['孤苦','浮躁']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个人的生命都是一只小船，梦想则是小船的风帆',
  'měi gè rén de shēng mìng dōu shì yì zhī xiǎo chuán ， mèng xiǎng zé shì xiǎo chuán de fēng fān',
  'Cuộc đời mỗi người giống như một con thuyền nhỏ, còn ước mơ chính là cánh buồm của con thuyền ấy.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的生命都是一只小船，梦想则是小船的风帆'),
  1,
  ARRAY['的','生命','都是','一','小船','是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的生命都是一只小船，梦想则是小船的风帆'),
  2,
  ARRAY['每个人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的生命都是一只小船，梦想则是小船的风帆'),
  3,
  ARRAY['只','风帆']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的生命都是一只小船，梦想则是小船的风帆'),
  4,
  ARRAY['梦想','则']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '并不是所有的努力都会开出梦想之花，实现了的才叫梦想，没实现的叫现实。是时候放下，那放下吧，实现不了的梦想不是可耻，只是命运再告诉我们，摆在我们面前的路有很多，也许该换一条路走走了。失败了，叫回到起点，重新出发，仅此而已',
  'bìng bú shì suǒ yǒu de nǔ lì dōu huì kāi chū mèng xiǎng zhī huā ， shí xiàn le de cái jiào mèng xiǎng ， méi shí xiàn de jiào xiàn shí 。 shì shí hòu fàng xià ， nà fàng xià ba ， shí xiàn bù liǎo de mèng xiǎng bú shì kě chǐ ， zhǐ shì mìng yùn zài gào sù wǒ men ， bǎi zài wǒ men miàn qián de lù yǒu hěn duō ， yě xǔ gāi huàn yì tiáo lù zǒu zǒu le 。 shī bài le ， jiào huí dào qǐ diǎn ， chóng xīn chū fā ， jǐn cǐ ér yǐ',
  'Không phải mọi nỗ lực đều sẽ nở hoa ước mơ, điều đã thực hiện được mới gọi là ước mơ, còn chưa thực hiện được thì gọi là hiện thực. Đã đến lúc buông bỏ, cứ buông thôi, những ước mơ không thể thực hiện không phải là đáng xấu hổ, chỉ là số phận đang mách bảo chúng ta rằng trước mắt còn nhiều con đường, có lẽ nên đổi một lối đi khác. Thất bại rồi thì quay về điểm xuất phát, bắt đầu lại, chỉ có vậy thôi.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '并不是所有的努力都会开出梦想之花，实现了的才叫梦想，没实现的叫现实。是时候放下，那放下吧，实现不了的梦想不是可耻，只是命运再告诉我们，摆在我们面前的路有很多，也许该换一条路走走了。失败了，叫回到起点，重新出发，仅此而已'),
  1,
  ARRAY['都会','开出','了','的','叫','没','现实','是','时候','那','不了','不是','再','我们','在','面前','有很多','一条','回到','起点','出发']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '并不是所有的努力都会开出梦想之花，实现了的才叫梦想，没实现的叫现实。是时候放下，那放下吧，实现不了的梦想不是可耻，只是命运再告诉我们，摆在我们面前的路有很多，也许该换一条路走走了。失败了，叫回到起点，重新出发，仅此而已'),
  2,
  ARRAY['所有的','吧','可耻','告诉','路','也许','走走']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '并不是所有的努力都会开出梦想之花，实现了的才叫梦想，没实现的叫现实。是时候放下，那放下吧，实现不了的梦想不是可耻，只是命运再告诉我们，摆在我们面前的路有很多，也许该换一条路走走了。失败了，叫回到起点，重新出发，仅此而已'),
  3,
  ARRAY['努力','花','实现','才','实现的','放下','只是','该','换','重新','而已']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '并不是所有的努力都会开出梦想之花，实现了的才叫梦想，没实现的叫现实。是时候放下，那放下吧，实现不了的梦想不是可耻，只是命运再告诉我们，摆在我们面前的路有很多，也许该换一条路走走了。失败了，叫回到起点，重新出发，仅此而已'),
  4,
  ARRAY['并不是','梦想','之','命运','失败','仅','此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '并不是所有的努力都会开出梦想之花，实现了的才叫梦想，没实现的叫现实。是时候放下，那放下吧，实现不了的梦想不是可耻，只是命运再告诉我们，摆在我们面前的路有很多，也许该换一条路走走了。失败了，叫回到起点，重新出发，仅此而已'),
  5,
  ARRAY['摆']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你坚守住了自己，坚守住了心中的理想时，才能看清原来这世间最美的景色，不是在豪华餐厅中一吨丰硕的晚餐，而是当所有人都不在身边时，还有一个属于自己的世界可供欣赏',
  'dāng nǐ jiān shǒu zhù le zì jǐ ， jiān shǒu zhù le xīn zhōng de lǐ xiǎng shí ， cái néng kàn qīng yuán lái zhè shì jiān zuì měi de jǐng sè ， bú shì zài háo huá cān tīng zhōng yì dūn fēng shuò de wǎn cān ， ér shì dāng suǒ yǒu rén dōu bú zài shēn biān shí ， hái yǒu yí gè shǔ yú zì jǐ de shì jiè kě gòng xīn shǎng',
  'Khi bạn giữ vững được bản thân và lý tưởng trong lòng, bạn mới nhận ra rằng cảnh đẹp nhất trên đời này không phải là bữa tối thịnh soạn trong nhà hàng sang trọng, mà là khi tất cả mọi người không còn bên cạnh, vẫn còn một thế giới của riêng mình để thưởng thức.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你坚守住了自己，坚守住了心中的理想时，才能看清原来这世间最美的景色，不是在豪华餐厅中一吨丰硕的晚餐，而是当所有人都不在身边时，还有一个属于自己的世界可供欣赏'),
  1,
  ARRAY['你','了','的','时','看清','这','不是','在','中','一','都','不在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你坚守住了自己，坚守住了心中的理想时，才能看清原来这世间最美的景色，不是在豪华餐厅中一吨丰硕的晚餐，而是当所有人都不在身边时，还有一个属于自己的世界可供欣赏'),
  2,
  ARRAY['最美','晚餐','所有人','身边','还有一个','可供']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你坚守住了自己，坚守住了心中的理想时，才能看清原来这世间最美的景色，不是在豪华餐厅中一吨丰硕的晚餐，而是当所有人都不在身边时，还有一个属于自己的世界可供欣赏'),
  3,
  ARRAY['当','自己','心中','理想','才能','世间','而是','自己的','世界']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你坚守住了自己，坚守住了心中的理想时，才能看清原来这世间最美的景色，不是在豪华餐厅中一吨丰硕的晚餐，而是当所有人都不在身边时，还有一个属于自己的世界可供欣赏'),
  4,
  ARRAY['坚守住','原来','景色','餐厅','丰硕']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你坚守住了自己，坚守住了心中的理想时，才能看清原来这世间最美的景色，不是在豪华餐厅中一吨丰硕的晚餐，而是当所有人都不在身边时，还有一个属于自己的世界可供欣赏'),
  5,
  ARRAY['豪华','吨','属于','欣赏']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏带你',
  'rú guǒ shì yǔ yuàn wéi ， jiù xiāng xìn shàng tiān yí dìng lìng yǒu ān pái ； suǒ yǒu shī qù de ， dōu huì yǐ lìng wài yì zhǒng fāng shì guī lái 。 xiāng xìn zì jǐ ， xiāng xìn shí jiān bú huì kuī dài nǐ',
  'Nếu mọi việc không như ý muốn, hãy tin rằng ông trời nhất định có sắp xếp khác; tất cả những gì đã mất đi sẽ trở lại theo một cách khác. Hãy tin vào chính mình, tin rằng thời gian sẽ không phụ bạn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏带你'),
  1,
  ARRAY['上天','一定','都会','一种','时间','不会','你']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏带你'),
  2,
  ARRAY['事与愿违','就','所有','以']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏带你'),
  3,
  ARRAY['如果','相信','安排','方式','自己','带']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏带你'),
  4,
  ARRAY['另有','失去的','另外']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果事与愿违，就相信上天一定另有安排；所有失去的，都会以另外一种方式归来。相信自己，相信时间不会亏带你'),
  5,
  ARRAY['归来','亏']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有人总说，已经晚了。实际上，现在就是最好的时光。对于一个真正有梦想的人来说，生命的每个时期都是年轻的，及时的',
  'yǒu rén zǒng shuō ， yǐ jīng wǎn le 。 shí jì shang ， xiàn zài jiù shì zuì hǎo de shí guāng 。 duì yú yí gè zhēn zhèng yǒu mèng xiǎng de rén lái shuō ， shēng mìng de měi gè shí qī dōu shì nián qīng de ， jí shí de',
  'Có người luôn nói, đã quá muộn rồi. Thực tế, hiện tại chính là thời điểm tốt nhất. Đối với người thực sự có ước mơ, mỗi giai đoạn của cuộc đời đều trẻ trung và đúng lúc.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人总说，已经晚了。实际上，现在就是最好的时光。对于一个真正有梦想的人来说，生命的每个时期都是年轻的，及时的'),
  1,
  ARRAY['有人','说','了','现在','时光','对于','一个','有','人','来说','生命的','时期','都是','年轻的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人总说，已经晚了。实际上，现在就是最好的时光。对于一个真正有梦想的人来说，生命的每个时期都是年轻的，及时的'),
  2,
  ARRAY['已经','晚','就是','最好的','真正','每个']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人总说，已经晚了。实际上，现在就是最好的时光。对于一个真正有梦想的人来说，生命的每个时期都是年轻的，及时的'),
  3,
  ARRAY['总','实际上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人总说，已经晚了。实际上，现在就是最好的时光。对于一个真正有梦想的人来说，生命的每个时期都是年轻的，及时的'),
  4,
  ARRAY['梦想的','及时的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成',
  'yǒu mèng xiǎng de rén shēng hǎi kuò tiān kōng méi yǒu yì kē xīn huì yīn wèi zhuī qiú mèng xiǎng ér shòu shāng ， dāng nǐ zhēn xīn xiǎng yào mǒu yàng dōng xī shí ， zhěng gè yǔ zhòu dōu huì lián hé qǐ lái bāng nǐ wán chéng',
  'Cuộc sống có ước mơ thì bao la như trời biển, không một trái tim nào bị tổn thương vì theo đuổi ước mơ. Khi bạn thực sự khao khát điều gì đó, cả vũ trụ sẽ hợp lại để giúp bạn hoàn thành.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成'),
  1,
  ARRAY['有','人生','没有','一颗','会','你','想要','样','东西','时','都会','起来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成'),
  2,
  ARRAY['因为','真心','帮','完成']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成'),
  3,
  ARRAY['心','而','当']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成'),
  4,
  ARRAY['梦想的','海阔天空','梦想','受伤','整个','联合']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成'),
  5,
  ARRAY['追求','某']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有梦想的人生海阔天空没有一颗心会因为追求梦想而受伤，当你真心想要某样东西时，整个宇宙都会联合起来帮你完成'),
  6,
  ARRAY['宇宙']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '原谅一个人是很容易的，但再次信任，就没那么容易。暖一颗心需要很多年，凉一颗心只要一瞬间',
  'yuán liàng yí gè rén shì hěn róng yì de ， dàn zài cì xìn rèn ， jiù méi nà me róng yì 。 nuǎn yì kē xīn xū yào hěn duō nián ， liáng yì kē xīn zhǐ yào yí shùn jiān',
  'Tha thứ cho một người rất dễ, nhưng để tin tưởng lại thì không dễ dàng như vậy. Sưởi ấm một trái tim cần nhiều năm, nhưng làm lạnh một trái tim chỉ cần một khoảnh khắc.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '原谅一个人是很容易的，但再次信任，就没那么容易。暖一颗心需要很多年，凉一颗心只要一瞬间'),
  1,
  ARRAY['一个人','是','很容易','的','再次','没','那么','一颗','很多','年','一瞬间']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '原谅一个人是很容易的，但再次信任，就没那么容易。暖一颗心需要很多年，凉一颗心只要一瞬间'),
  2,
  ARRAY['但','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '原谅一个人是很容易的，但再次信任，就没那么容易。暖一颗心需要很多年，凉一颗心只要一瞬间'),
  3,
  ARRAY['信任','容易','心','需要','只要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '原谅一个人是很容易的，但再次信任，就没那么容易。暖一颗心需要很多年，凉一颗心只要一瞬间'),
  4,
  ARRAY['原谅','暖','凉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '世界真的很小，好像一转身，就不知道会遇见谁；世界真的很大，好像一转身，就不知道谁会消失',
  'shì jiè zhēn de hěn xiǎo ， hǎo xiàng yì zhuǎn shēn ， jiù bù zhī dào huì yù jiàn shuí ； shì jiè zhēn de hěn dà ， hǎo xiàng yì zhuǎn shēn ， jiù bù zhī dào shuí huì xiāo shī',
  'Thế giới thực sự rất nhỏ, dường như chỉ cần quay người lại là không biết sẽ gặp ai; thế giới thực sự rất lớn, dường như chỉ cần quay người lại là không biết ai sẽ biến mất.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世界真的很小，好像一转身，就不知道会遇见谁；世界真的很大，好像一转身，就不知道谁会消失'),
  1,
  ARRAY['很小','好像','一','不知道','会','谁','很大']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世界真的很小，好像一转身，就不知道会遇见谁；世界真的很大，好像一转身，就不知道谁会消失'),
  2,
  ARRAY['真的','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世界真的很小，好像一转身，就不知道会遇见谁；世界真的很大，好像一转身，就不知道谁会消失'),
  3,
  ARRAY['世界','遇见']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世界真的很小，好像一转身，就不知道会遇见谁；世界真的很大，好像一转身，就不知道谁会消失'),
  4,
  ARRAY['转身','消失']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生就是一场漫长的自娱自乐。讨别人欢心只是小聪明，每天都能讨到自己的欢心才算大智慧',
  'rén shēng jiù shì yì chǎng màn cháng de zì yú zì lè 。 tǎo bié rén huān xīn zhǐ shì xiǎo cōng ming ， měi tiān dōu néng tǎo dào zì jǐ de huān xīn cái suàn dà zhì huì',
  'Cuộc đời là một cuộc tự giải trí dài lâu. Làm vui lòng người khác chỉ là mẹo vặt, mỗi ngày đều làm vui lòng chính mình mới là trí tuệ lớn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场漫长的自娱自乐。讨别人欢心只是小聪明，每天都能讨到自己的欢心才算大智慧'),
  1,
  ARRAY['人生','一场','欢心','小聪明','能','大智慧']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场漫长的自娱自乐。讨别人欢心只是小聪明，每天都能讨到自己的欢心才算大智慧'),
  2,
  ARRAY['就是','别人','每天都','到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场漫长的自娱自乐。讨别人欢心只是小聪明，每天都能讨到自己的欢心才算大智慧'),
  3,
  ARRAY['自娱','自乐','只是','自己的','才算']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一场漫长的自娱自乐。讨别人欢心只是小聪明，每天都能讨到自己的欢心才算大智慧'),
  4,
  ARRAY['漫长的','讨']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己',
  'měi gè rén de xìng gé zhōng ， dōu yǒu mǒu xiē wú fǎ ràng rén jiē shòu de bù fen ， zài měi hǎo de rén yě yí yàng 。 suǒ yǐ ， bú yào kē qiú bié rén ， yě bú yào mán yuàn zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己'),
  1,
  ARRAY['的','中','都','有','再','人','不要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己'),
  2,
  ARRAY['每个人','让人','也一样','所以','别人','也不','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己'),
  3,
  ARRAY['接受的','苛求','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己'),
  4,
  ARRAY['性格','无法','部分','美好的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己'),
  5,
  ARRAY['某些']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人的性格中，都有某些无法让人接受的部分，再美好的人也一样。所以，不要苛求别人，也不要埋怨自己'),
  6,
  ARRAY['埋怨']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福',
  'zài dà de shāng tòng ， shuì yí jiào jiù bǎ tā wàng le 。 bèi zhe zuó tiān zhuī gǎn míng tiān ， huì lèi huài le měi yí gè dāng xià 。 biān zǒu biān wàng ， cái néng gǎn shòu dào měi yí gè yíng miàn ér lái de xìng fú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  1,
  ARRAY['再','大的','睡','一觉','昨天','明天','会','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  2,
  ARRAY['就','它','累','每一个','边','走边','到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  3,
  ARRAY['把','忘了','坏了','当下','忘','才能','感受','迎面而来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  4,
  ARRAY['伤痛','幸福']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  5,
  ARRAY['背着','追赶']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生命中有许多你不想做却不能不做的事，这就是责任；生命中有许多你想做却不能做的事，这就是命运',
  'shēng mìng zhòng yǒu xǔ duō nǐ bù xiǎng zuò què bù néng bú zuò de shì ， zhè jiù shì zé rèn ； shēng mìng zhòng yǒu xǔ duō nǐ xiǎng zuò què bù néng zuò de shì ， zhè jiù shì mìng yùn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中有许多你不想做却不能不做的事，这就是责任；生命中有许多你想做却不能做的事，这就是命运'),
  1,
  ARRAY['生命','中','有','你','不想','做','不能不','的','这','想做','不能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中有许多你不想做却不能不做的事，这就是责任；生命中有许多你想做却不能做的事，这就是命运'),
  2,
  ARRAY['事','就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中有许多你不想做却不能不做的事，这就是责任；生命中有许多你想做却不能做的事，这就是命运'),
  4,
  ARRAY['许多','却','责任','命运']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '用心去生活，别以他人的眼光为尺度，每一天幸福就好',
  'yòng xīn qù shēng huó ， bié yǐ tā rén de yǎn guāng wèi chǐ dù ， měi yì tiān xìng fú jiù hǎo',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '用心去生活，别以他人的眼光为尺度，每一天幸福就好'),
  1,
  ARRAY['去','生活','他人的','好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '用心去生活，别以他人的眼光为尺度，每一天幸福就好'),
  2,
  ARRAY['别','以','眼光','为','每一天','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '用心去生活，别以他人的眼光为尺度，每一天幸福就好'),
  3,
  ARRAY['用心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '用心去生活，别以他人的眼光为尺度，每一天幸福就好'),
  4,
  ARRAY['幸福']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '用心去生活，别以他人的眼光为尺度，每一天幸福就好'),
  5,
  ARRAY['尺度']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '任何时候都可以开始做自己想做的事，希望不要用年龄和其他东西来束缚自己。年龄从来不是界限，除非你自己拿来为难自己',
  'rèn hé shí hòu dōu kě yǐ kāi shǐ zuò zì jǐ xiǎng zuò de shì ， xī wàng bú yào yòng nián líng hé qí tā dōng xī lái shù fù zì jǐ 。 nián líng cóng lái bú shì jiè xiàn ， chú fēi nǐ zì jǐ ná lái wéi nán zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '任何时候都可以开始做自己想做的事，希望不要用年龄和其他东西来束缚自己。年龄从来不是界限，除非你自己拿来为难自己'),
  1,
  ARRAY['时候','都','开始做','想做','的','不要','年龄','和','东西来','是','你自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '任何时候都可以开始做自己想做的事，希望不要用年龄和其他东西来束缚自己。年龄从来不是界限，除非你自己拿来为难自己'),
  2,
  ARRAY['可以','事','希望','从来不','为难']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '任何时候都可以开始做自己想做的事，希望不要用年龄和其他东西来束缚自己。年龄从来不是界限，除非你自己拿来为难自己'),
  3,
  ARRAY['自己','用','其他','束缚','界限','除非','拿来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '任何时候都可以开始做自己想做的事，希望不要用年龄和其他东西来束缚自己。年龄从来不是界限，除非你自己拿来为难自己'),
  4,
  ARRAY['任何']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子',
  'nìng yuàn pào qǐ lái bèi bàn dǎo wú shù cì ， yě bú yào guī guī jǔ jǔ zǒu yí bèi zi',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子'),
  1,
  ARRAY['起来','一辈子']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子'),
  2,
  ARRAY['也不','要','走']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子'),
  3,
  ARRAY['被']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子'),
  4,
  ARRAY['绊倒','无数次','规规矩矩']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子'),
  5,
  ARRAY['宁愿']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '宁愿泡起来被绊倒无数次，也不要规规矩矩走一辈子'),
  6,
  ARRAY['泡']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉',
  'chú le nǐ zì jǐ ， méi yǒu rén huì míng bái nǐ de gù shì lǐ yǒu guò duō shǎo kuài lè huò shāng bēi ， yīn wèi nà zhōng jiū zhǐ shì nǐ yí gè rén de gǎn jué',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  1,
  ARRAY['你自己','没有人','会','明白','你的','里','有','少','那','你','一个人','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  2,
  ARRAY['过多','快乐','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  3,
  ARRAY['除了','故事','或','终究','只是','感觉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  4,
  ARRAY['伤悲']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '没有人可以回到过去重新开始，但谁都可以从今日开始，书写一个全然不同的结局',
  'méi yǒu rén kě yǐ huí dào guò qù chóng xīn kāi shǐ ， dàn shuí dōu kě yǐ cóng jīn rì kāi shǐ ， shū xiě yí gè quán rán bù tóng de jié jú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人可以回到过去重新开始，但谁都可以从今日开始，书写一个全然不同的结局'),
  1,
  ARRAY['没有人','回到','谁','都','开始','书写','一个','不同的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人可以回到过去重新开始，但谁都可以从今日开始，书写一个全然不同的结局'),
  2,
  ARRAY['可以','过去','但','从今','日']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人可以回到过去重新开始，但谁都可以从今日开始，书写一个全然不同的结局'),
  3,
  ARRAY['重新开始','结局']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没有人可以回到过去重新开始，但谁都可以从今日开始，书写一个全然不同的结局'),
  4,
  ARRAY['全然']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '或许在某一个地方，会有另外一个我。做着我不敢做的事，过着我想要的生活',
  'huò xǔ zài mǒu yí gè dì fāng ， huì yǒu lìng wài yí gè wǒ 。 zuò zhe wǒ bù gǎn zuò de shì ， guò zhe wǒ xiǎng yào de shēng huó',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '或许在某一个地方，会有另外一个我。做着我不敢做的事，过着我想要的生活'),
  1,
  ARRAY['在','会','有','我','做','不敢','的','我想','生活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '或许在某一个地方，会有另外一个我。做着我不敢做的事，过着我想要的生活'),
  2,
  ARRAY['着','事','过着','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '或许在某一个地方，会有另外一个我。做着我不敢做的事，过着我想要的生活'),
  3,
  ARRAY['或许','地方']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '或许在某一个地方，会有另外一个我。做着我不敢做的事，过着我想要的生活'),
  4,
  ARRAY['另外一个']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '或许在某一个地方，会有另外一个我。做着我不敢做的事，过着我想要的生活'),
  5,
  ARRAY['某一个']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人一辈子如何，其实取决于几次重要的选择，愿你能做对那几次重要的选择，活出自己想要的模样',
  'rén yí bèi zi rú hé ， qí shí qǔ jué yú jǐ cì zhòng yào de xuǎn zé ， yuàn nǐ néng zuò duì nà jǐ cì zhòng yào de xuǎn zé ， huó chū zì jǐ xiǎng yào de mú yàng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一辈子如何，其实取决于几次重要的选择，愿你能做对那几次重要的选择，活出自己想要的模样'),
  1,
  ARRAY['人','一辈子','几','你','能','做','对那','出自','想要','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一辈子如何，其实取决于几次重要的选择，愿你能做对那几次重要的选择，活出自己想要的模样'),
  2,
  ARRAY['次']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一辈子如何，其实取决于几次重要的选择，愿你能做对那几次重要的选择，活出自己想要的模样'),
  3,
  ARRAY['如何','其实','重要的','选择','愿','己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一辈子如何，其实取决于几次重要的选择，愿你能做对那几次重要的选择，活出自己想要的模样'),
  4,
  ARRAY['取决于','活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一辈子如何，其实取决于几次重要的选择，愿你能做对那几次重要的选择，活出自己想要的模样'),
  5,
  ARRAY['模样']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人，永远不会珍惜三种人：一是轻易得到的，二是永远不会离开的，三是那个一直对你很好的。但是，往往这三种人一旦离开就永远不会再回来',
  'rén ， yǒng yuǎn bú huì zhēn xī sān zhǒng rén ： yī shì qīng yì dé dào de ， èr shì yǒng yuǎn bú huì lí kāi de ， sān shì nà ge yì zhí duì nǐ hěn hǎo de 。 dàn shì ， wǎng wǎng zhè sān zhǒng rén yí dàn lí kāi jiù yǒng yuǎn bú huì zài huí lái',
  'Con người thường không biết trân trọng ba kiểu người: một là người dễ dàng có được, hai là người không bao giờ rời đi, và ba là người luôn đối xử tốt với bạn. Nhưng thường khi ba kiểu người này rời đi, họ sẽ không bao giờ quay lại.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人，永远不会珍惜三种人：一是轻易得到的，二是永远不会离开的，三是那个一直对你很好的。但是，往往这三种人一旦离开就永远不会再回来'),
  1,
  ARRAY['人','不会','三','一','是','的','二','那个','一直','对','你','很好的','这','一旦','再','回来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人，永远不会珍惜三种人：一是轻易得到的，二是永远不会离开的，三是那个一直对你很好的。但是，往往这三种人一旦离开就永远不会再回来'),
  2,
  ARRAY['得到','离开的','但是','往往','离开','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人，永远不会珍惜三种人：一是轻易得到的，二是永远不会离开的，三是那个一直对你很好的。但是，往往这三种人一旦离开就永远不会再回来'),
  3,
  ARRAY['种','轻易']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人，永远不会珍惜三种人：一是轻易得到的，二是永远不会离开的，三是那个一直对你很好的。但是，往往这三种人一旦离开就永远不会再回来'),
  4,
  ARRAY['永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人，永远不会珍惜三种人：一是轻易得到的，二是永远不会离开的，三是那个一直对你很好的。但是，往往这三种人一旦离开就永远不会再回来'),
  5,
  ARRAY['珍惜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达',
  'bèi wō hěn shū fú qǐ chuáng kùn nán ， nà jiù fàng xià shǒu jī zǎo diǎn shuì 。 shū duī dé duō bù zhī kàn nǎ běn ， nà jiù ná qǐ zuì jīng diǎn de 。 shuō zǒu jiù zǒu de lǚ xíng xià bù liǎo jué xīn ， nà jiù xiān xué huì xīn shǎng shēn biān měi jǐng 。 rú guǒ bù céng kāi shǐ ， yǒng yuǎn bú huì dǐ dá',
  'Nếu việc rời khỏi giường quá khó vì chăn ấm, hãy đặt điện thoại xuống và đi ngủ sớm. Nếu có quá nhiều sách không biết đọc quyển nào, hãy chọn quyển kinh điển nhất. Nếu chưa thể quyết tâm cho chuyến đi ngay lập tức, hãy học cách trân trọng cảnh đẹp xung quanh. Nếu không bắt đầu, bạn sẽ không bao giờ đến đích.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达'),
  1,
  ARRAY['很','起床','那就','睡','书','多','不知','看','哪','本','的','说','下','不了','先','学会','不曾','开始','不会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达'),
  2,
  ARRAY['手机','早点','得','最','经典','走','就','旅行','身边']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达'),
  3,
  ARRAY['被窝','舒服','放下','拿起','决心','如果']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达'),
  4,
  ARRAY['困难','美景','永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达'),
  5,
  ARRAY['堆','欣赏']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '被窝很舒服起床困难，那就放下手机早点睡。书堆得多不知看哪本，那就拿起最经典的。说走就走的旅行下不了决心，那就先学会欣赏身边美景。如果不曾开始，永远不会抵达'),
  6,
  ARRAY['抵达']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的',
  'zhèng zhí qīng chūn nián huá de wǒ men ， zǒng huì yí cì cì bú zì jué wàng xiàng yuǎn fāng ， duì yuǎn fāng de dào lù chōng mǎn chōng jǐng ， jǐn guǎn hū yǐn hū xiàn ， chōng mǎn mí máng 。 yǒu shí hòu shēn biān jiù xiàng bèi nóng wù jǐn jǐn bāo wéi ， nà zhǒng mí máng hé wú zhù zhǐ yǒu zì jǐ néng dǒng 。 jǐn guǎn yǒu diǎn gū dú ， jǐn guǎn dài zháo mí máng hé wú nài ， dàn wǒ yī rán yǒng gǎn dì miàn duì ， yīn wèi zhè jiù shì wǒ de qīng chūn ， bú shì bié rén de ， zhī shǔ yú wǒ de',
  'Đang ở độ tuổi thanh xuân, chúng ta thường không ngừng hướng ánh mắt về phía chân trời xa xôi, đầy khát vọng về con đường phía trước, dù nó mờ mịt và đầy hoài nghi. Đôi khi, cảm giác như bị sương mù dày đặc bao quanh, chỉ mình ta hiểu rõ sự lạc lõng và bất lực ấy. Dù có chút cô đơn, dù đầy hoang mang và bất lực, tôi vẫn dũng cảm đối mặt, vì đây là thanh xuân của chính tôi, không phải của ai khác, mà chỉ thuộc về tôi.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  1,
  ARRAY['的','我们','一次次','不','对','有时候','那种','和','能','有点','我','这','我的','不是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  2,
  ARRAY['正值','望','远方','道路','身边','就像','懂','着迷','但','因为','就是','别人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  3,
  ARRAY['总会','自觉','向','被','包围','只有','自己','带','只']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  4,
  ARRAY['尽管','迷茫','紧紧','无助','无奈','勇敢地面对']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  5,
  ARRAY['青春年华','充满','忽隐忽现','浓雾','依然','青春','属于']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  6,
  ARRAY['孤独','茫']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '正值青春年华的我们，总会一次次不自觉望向远方，对远方的道路充满憧憬，尽管忽隐忽现，充满迷茫。有时候身边就像被浓雾紧紧包围，那种迷茫和无助只有自己能懂。尽管有点孤独，尽管带着迷茫和无奈，但我依然勇敢地面对，因为这就是我的青春，不是别人的，只属于我的'),
  ARRAY['憧','憬']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生命中终将会错过一些人，我们应该感谢那些错过的人，他们让我们明白了幸福的珍贵。不要相信该是自己的终该是自己的，不去争取不去把握的话，永远都不会有机会',
  'shēng mìng zhōng zhōng jiāng huì cuò guò yì xiē rén ， wǒ men yīng gāi gǎn xiè nà xiē cuò guò de rén ， tā men ràng wǒ men míng bái le xìng fú de zhēn guì 。 bú yào xiāng xìn gāi shì zì jǐ de zhōng gāi shì zì jǐ de ， bú qù zhēng qǔ bú qù bǎ wò de huà ， yǒng yuǎn dōu bú huì yǒu jī huì',
  'Trong cuộc đời, chắc chắn sẽ có những người mà ta vô tình để lỡ. Chúng ta nên cảm ơn những người ấy, vì họ giúp ta hiểu được giá trị của hạnh phúc. Đừng tin rằng điều gì thuộc về mình rồi sẽ thuộc về mình, nếu không cố gắng và nắm bắt, bạn sẽ không bao giờ có cơ hội.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中终将会错过一些人，我们应该感谢那些错过的人，他们让我们明白了幸福的珍贵。不要相信该是自己的终该是自己的，不去争取不去把握的话，永远都不会有机会'),
  1,
  ARRAY['生命','中','会','一些','人','我们','那些','的','他们','们','明白','了','不要','是','不去','的话','都','不会','有机会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中终将会错过一些人，我们应该感谢那些错过的人，他们让我们明白了幸福的珍贵。不要相信该是自己的终该是自己的，不去争取不去把握的话，永远都不会有机会'),
  2,
  ARRAY['错过','让我']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中终将会错过一些人，我们应该感谢那些错过的人，他们让我们明白了幸福的珍贵。不要相信该是自己的终该是自己的，不去争取不去把握的话，永远都不会有机会'),
  3,
  ARRAY['终将','应该感谢','相信','该','自己的','终','把握']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中终将会错过一些人，我们应该感谢那些错过的人，他们让我们明白了幸福的珍贵。不要相信该是自己的终该是自己的，不去争取不去把握的话，永远都不会有机会'),
  4,
  ARRAY['幸福的','争取','永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命中终将会错过一些人，我们应该感谢那些错过的人，他们让我们明白了幸福的珍贵。不要相信该是自己的终该是自己的，不去争取不去把握的话，永远都不会有机会'),
  5,
  ARRAY['珍贵']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么',
  'rén zuì qiáng dà de shí hòu ， bú shì jiān chí de shí hòu ， ér shì fàng xià de shí hòu 。 dāng nǐ xuǎn zé téng kōng shuāng shǒu ， hái yǒu shuí néng cóng nǐ shǒu zhōng duó zǒu shén me',
  'Thời điểm con người mạnh mẽ nhất không phải lúc cố gắng kiên trì, mà là khi biết buông bỏ. Khi bạn chọn để đôi tay trống trải, liệu còn ai có thể lấy đi thứ gì từ bạn?',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么'),
  1,
  ARRAY['人','时候','不是','的','你','谁','能','什么']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么'),
  2,
  ARRAY['最','还有','从','手中']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么'),
  3,
  ARRAY['而是','放下','当','选择','双手']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么'),
  4,
  ARRAY['坚持的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么'),
  5,
  ARRAY['强大的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人最强大的时候，不是坚持的时候，而是放下的时候。当你选择腾空双手，还有谁能从你手中夺走什么'),
  6,
  ARRAY['腾空','夺走']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心',
  'lù kě yǐ huí tóu kàn ， què bù kě yǐ huí tóu zǒu 。 bǎ wò měi yí gè shùn jiān ， zhēn xī měi yí cì yōng yǒu 。 jí shǐ yù dào cōng cōng lí kāi de rén ， yě yào jì de gǎn xiè tā céng chū xiàn zài nǐ de shēng mìng zhòng ， yīn wèi tā yě shì nǐ jīng cǎi huí yì de yí bù fen 。 rén shēng ， bù qiú jìn rú rén yì ， dàn qiú wú kuì yú xīn',
  'Con đường có thể ngoảnh lại nhìn, nhưng không thể bước ngược trở lại. Hãy trân trọng từng khoảnh khắc, quý trọng từng lần sở hữu. Dù gặp phải những người rời đi vội vã, hãy nhớ cảm ơn vì họ đã từng xuất hiện trong cuộc đời bạn, vì họ cũng là một phần trong những kỷ niệm đẹp của bạn. Cuộc sống, không cần mọi thứ hoàn hảo, chỉ cần không hối hận trong lòng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心'),
  1,
  ARRAY['回头看','不可以','回头','的','人','他','出现在','你的','生命','中','你','回忆的','一部分','人生','不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心'),
  2,
  ARRAY['路','可以','走','每一个','每一','次','也','要','因为','也是','但']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心'),
  3,
  ARRAY['把握','遇到','记得','感谢','求','心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心'),
  4,
  ARRAY['却','即使','精彩','尽如人意','无愧于']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心'),
  5,
  ARRAY['珍惜','拥有','匆匆离开','曾']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '路可以回头看，却不可以回头走。把握每一个瞬间，珍惜每一次拥有。即使遇到匆匆离开的人，也要记得感谢他曾出现在你的生命中，因为他也是你精彩回忆的一部分。人生，不求尽如人意，但求无愧于心'),
  6,
  ARRAY['瞬间']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '刻意去找的东西，往往是找不到的。天下万物的来和去，都有它的时间',
  'kè yì qù zhǎo de dōng xī ， wǎng wǎng shì zhǎo bú dào de 。 tiān xià wàn wù de lái hé qù ， dōu yǒu tā de shí jiān',
  'Những thứ cố tình tìm kiếm thường là không thể tìm thấy. Mọi thứ trên thế gian này, sự đến và đi của chúng đều có thời điểm của riêng mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '刻意去找的东西，往往是找不到的。天下万物的来和去，都有它的时间'),
  1,
  ARRAY['去','的','东西','是','天下','来','和','都','有','时间']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '刻意去找的东西，往往是找不到的。天下万物的来和去，都有它的时间'),
  2,
  ARRAY['找','往往','找不到','它的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '刻意去找的东西，往往是找不到的。天下万物的来和去，都有它的时间'),
  3,
  ARRAY['刻意','万物']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间并不会真的帮我们解决问题，它只是把原来想不通的事，变得不那么重要了',
  'shí jiān bìng bú huì zhēn de bāng wǒ men jiě jué wèn tí ， tā zhǐ shì bǎ yuán lái xiǎng bù tōng de shì ， biàn de bú nà me zhòng yào le',
  'Thời gian không thực sự giúp chúng ta giải quyết vấn đề, mà chỉ làm cho những điều trước đây không thể hiểu được trở nên ít quan trọng hơn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间并不会真的帮我们解决问题，它只是把原来想不通的事，变得不那么重要了'),
  1,
  ARRAY['时间','我们','想不通','的','不','那么','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间并不会真的帮我们解决问题，它只是把原来想不通的事，变得不那么重要了'),
  2,
  ARRAY['真的','帮','它','事']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间并不会真的帮我们解决问题，它只是把原来想不通的事，变得不那么重要了'),
  3,
  ARRAY['解决问题','只是','把','变得','重要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间并不会真的帮我们解决问题，它只是把原来想不通的事，变得不那么重要了'),
  4,
  ARRAY['并不会','原来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '现在的你也许很痛苦，等过阵子回头看看，你会发现其实那都不算事',
  'xiàn zài de nǐ yě xǔ hěn tòng kǔ ， děng guò zhèn zǐ huí tóu kàn kàn ， nǐ huì fā xiàn qí shí nà dōu bú suàn shì',
  'Bây giờ bạn có thể đang rất đau khổ, nhưng sau một thời gian quay đầu nhìn lại, bạn sẽ nhận ra rằng những điều đó chẳng đáng là gì.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你也许很痛苦，等过阵子回头看看，你会发现其实那都不算事'),
  1,
  ARRAY['现在的','你','很','回头看','看','会','那','都','不算']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你也许很痛苦，等过阵子回头看看，你会发现其实那都不算事'),
  2,
  ARRAY['也许','等','过','事']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你也许很痛苦，等过阵子回头看看，你会发现其实那都不算事'),
  3,
  ARRAY['发现','其实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '现在的你也许很痛苦，等过阵子回头看看，你会发现其实那都不算事'),
  5,
  ARRAY['痛苦','阵子']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好',
  'yōng yǒu shàn liáng qīng líng de xīn ， kāi xīn dì xiào ， chàng kuài dì hǔ 。 bù jiǎo róu zào zuò ， bù gōng yú xīn jì ， zhè yàng de nǚ hái gāng gāng hǎo',
  'Có một trái tim hiền lành và trong sáng, cười vui vẻ, sống thoải mái. Không giả tạo, không toan tính, cô gái như vậy thật tuyệt vời.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好'),
  1,
  ARRAY['的','开心','不','工于心计','这样的','女孩','好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好'),
  2,
  ARRAY['笑']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好'),
  3,
  ARRAY['清','心','地','刚刚']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好'),
  4,
  ARRAY['虎']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好'),
  5,
  ARRAY['拥有','善良','灵']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '拥有善良清灵的心，开心地笑，畅快地虎。不矫揉造作，不工于心计，这样的女孩刚刚好'),
  6,
  ARRAY['畅快','矫揉造作']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '做个稳妥的人，不要高估两年内的自己，也不要低估10年后的自己',
  'zuò gè wěn tuǒ de rén ， bú yào gāo gū liǎng nián nèi de zì jǐ ， yě bú yào dī gū 1 0 nián hòu de zì jǐ',
  'Hãy trở thành một người chín chắn, đừng đánh giá quá cao bản thân trong vòng hai năm tới, cũng đừng đánh giá thấp bản thân sau mười năm nữa.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做个稳妥的人，不要高估两年内的自己，也不要低估10年后的自己'),
  1,
  ARRAY['做','个','的','人','不要','高估','年','后的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做个稳妥的人，不要高估两年内的自己，也不要低估10年后的自己'),
  2,
  ARRAY['两','也不','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做个稳妥的人，不要高估两年内的自己，也不要低估10年后的自己'),
  3,
  ARRAY['自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做个稳妥的人，不要高估两年内的自己，也不要低估10年后的自己'),
  4,
  ARRAY['内的','低估']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做个稳妥的人，不要高估两年内的自己，也不要低估10年后的自己'),
  5,
  ARRAY['稳妥']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福',
  'hé cōng ming rén jiāo liú ， hé kào pǔ de rén liàn ài ， hé jī jí de rén gòng shì ， hé yōu mò de rén suì xíng 。 wǒ rén shēng ruò néng rú cǐ ， jiù shì zuì dà de xìng fú',
  'Giao tiếp với người thông minh, yêu đương với người đáng tin, làm việc với người tích cực, đồng hành cùng người hài hước. Nếu cuộc đời tôi có thể như vậy, đó chính là hạnh phúc lớn nhất.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  1,
  ARRAY['和','的','人','我人','生','能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  2,
  ARRAY['共事','就是','最大的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  3,
  ARRAY['聪明人','行','如此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  4,
  ARRAY['交流','积极的','幽默','幸福']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  5,
  ARRAY['靠','恋爱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  6,
  ARRAY['谱','若']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '和聪明人交流，和靠谱的人恋爱，和积极的人共事，和幽默的人遂行。我人生若能如此，就是最大的幸福'),
  ARRAY['遂']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心',
  'shēng huó zǒng shì zhè yàng ， bù néng jiào rén chù chù dōu mǎn yì 。 dàn wǒ men hái yào rè qíng dì huó xià qù 。 rén huó yì shēng ， zhí dé ài de dōng xī hěn duō ， bú yào yīn wèi yí gè bù mǎn yì ， jiù huī xīn',
  'Cuộc sống luôn như thế, không thể khiến mọi thứ đều hoàn hảo như mong muốn. Nhưng chúng ta vẫn phải sống hết mình với nhiệt huyết. Trong cuộc đời, có rất nhiều điều đáng để yêu thương, đừng vì một điều không vừa ý mà nản lòng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  1,
  ARRAY['生活','这样','不能','叫','人','都','我们','热情地','一生','爱的','东西','很多','不要','一个','不满']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  2,
  ARRAY['但','还要','因为','意','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  3,
  ARRAY['总是','满意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  4,
  ARRAY['处处','活下去','活','值得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  5,
  ARRAY['灰心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生命如此短暂。何不打破成规，原谅坏一点，亲吻慢一点，爱德真一点，笑得疯一点，并且只要是让自己笑过的事，就永远不会后悔',
  'shēng mìng rú cǐ duǎn zàn 。 hé bù dǎ pò chéng guī ， yuán liàng huài yì diǎn ， qīn wěn màn yì diǎn ， ài dé zhēn yì diǎn ， xiào dé fēng yì diǎn ， bìng qiě zhī yào shi ràng zì jǐ xiào guò de shì ， jiù yǒng yuǎn bú huì hòu huǐ',
  'Cuộc đời ngắn ngủi như vậy. Sao không phá vỡ những quy tắc, tha thứ nhiều hơn, hôn chậm hơn, yêu chân thành hơn, cười điên cuồng hơn. Và bất cứ điều gì khiến bạn mỉm cười, bạn sẽ không bao giờ phải hối tiếc.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命如此短暂。何不打破成规，原谅坏一点，亲吻慢一点，爱德真一点，笑得疯一点，并且只要是让自己笑过的事，就永远不会后悔'),
  1,
  ARRAY['生命','打破','一点','爱德','是','的','不会','后悔']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命如此短暂。何不打破成规，原谅坏一点，亲吻慢一点，爱德真一点，笑得疯一点，并且只要是让自己笑过的事，就永远不会后悔'),
  2,
  ARRAY['慢一点','真','笑','得','让','过','事','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命如此短暂。何不打破成规，原谅坏一点，亲吻慢一点，爱德真一点，笑得疯一点，并且只要是让自己笑过的事，就永远不会后悔'),
  3,
  ARRAY['如此','短暂','成规','坏','只要','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命如此短暂。何不打破成规，原谅坏一点，亲吻慢一点，爱德真一点，笑得疯一点，并且只要是让自己笑过的事，就永远不会后悔'),
  4,
  ARRAY['何不','原谅','亲吻','并且','永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命如此短暂。何不打破成规，原谅坏一点，亲吻慢一点，爱德真一点，笑得疯一点，并且只要是让自己笑过的事，就永远不会后悔'),
  5,
  ARRAY['疯']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间是种极好的东西，原谅了不可原谅的，过去了曾经过不去的，也许我偶尔想回到之前的时光，但我知道人始终要学会向前看',
  'shí jiān shì zhǒng jí hǎo de dōng xī ， yuán liàng le bù kě yuán liàng de ， guò qù le céng jīng guò bú qù de ， yě xǔ wǒ ǒu ěr xiǎng huí dào zhī qián de shí guāng ， dàn wǒ zhī dào rén shǐ zhōng yào xué huì xiàng qián kàn',
  'Thời gian là điều tuyệt vời, nó giúp ta tha thứ những điều tưởng chừng không thể tha thứ, vượt qua những điều từng nghĩ không thể vượt qua. Có thể đôi khi tôi muốn quay lại quá khứ, nhưng tôi biết rằng con người luôn phải học cách nhìn về phía trước.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是种极好的东西，原谅了不可原谅的，过去了曾经过不去的，也许我偶尔想回到之前的时光，但我知道人始终要学会向前看'),
  1,
  ARRAY['时间','是','了','不可原谅的','的','我','想','回到','时光','我知道','人','学会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是种极好的东西，原谅了不可原谅的，过去了曾经过不去的，也许我偶尔想回到之前的时光，但我知道人始终要学会向前看'),
  2,
  ARRAY['过去','过不去','也许','但','始终','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是种极好的东西，原谅了不可原谅的，过去了曾经过不去的，也许我偶尔想回到之前的时光，但我知道人始终要学会向前看'),
  3,
  ARRAY['种','极好的东西','向前看']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是种极好的东西，原谅了不可原谅的，过去了曾经过不去的，也许我偶尔想回到之前的时光，但我知道人始终要学会向前看'),
  4,
  ARRAY['原谅','偶尔','之前']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是种极好的东西，原谅了不可原谅的，过去了曾经过不去的，也许我偶尔想回到之前的时光，但我知道人始终要学会向前看'),
  5,
  ARRAY['曾经']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '感谢黑夜的来临，我知道今天不论有多失败，全新的明天仍然等待我来证明自己。明天又是新的一天',
  'gǎn xiè hēi yè de lái lín ， wǒ zhī dào jīn tiān bú lùn yǒu duō shī bài ， quán xīn de míng tiān réng rán děng dài wǒ lái zhèng míng zì jǐ 。 míng tiān yòu shì xīn de yì tiān',
  'Cảm ơn màn đêm đã đến, tôi biết rằng dù hôm nay có thất bại đến đâu, một ngày mai hoàn toàn mới vẫn đang chờ tôi chứng minh bản thân. Ngày mai sẽ lại là một khởi đầu mới.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '感谢黑夜的来临，我知道今天不论有多失败，全新的明天仍然等待我来证明自己。明天又是新的一天'),
  1,
  ARRAY['的','来临','我知道','今天','不论','有','多','明天','我来','一天']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '感谢黑夜的来临，我知道今天不论有多失败，全新的明天仍然等待我来证明自己。明天又是新的一天'),
  2,
  ARRAY['黑夜','等待','新的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '感谢黑夜的来临，我知道今天不论有多失败，全新的明天仍然等待我来证明自己。明天又是新的一天'),
  3,
  ARRAY['感谢','自己','又是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '感谢黑夜的来临，我知道今天不论有多失败，全新的明天仍然等待我来证明自己。明天又是新的一天'),
  4,
  ARRAY['失败','全新的','仍然','证明']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的',
  'rén zài 2 0 duō suì de shí hòu ， zǒng shì yuàn yì xiāng xìn yí jù huà ： shēng huó zài bié chù 。 dāng nǐ hěn qīng yì dì fàng qì yí fèn gōng zuò ， hěn qīng yì dì fàng shǒu yí duàn ài qíng ， hěn qīng yì dì shè qì yí gè péng yǒu ， dōu shì yīn wèi zhè zhǒng xiāng xìn 。 kě xī zǒng shì yào guò hěn jiǔ zhī hòu cái néng míng bái ， zhè shì shàng bìng bù cún zài chuán shuō zhōng de " bié chù " nǐ suǒ yōng yǒu de ， bú guò shì nǐ shǒu shàng de zhè xiē 。 ér nǐ dōu dōu zhuǎn zhuǎn zuì zhōng dé dào de ， yě bú guò shì nǐ zài dì yī gè zhàn cuò guò de',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的'),
  1,
  ARRAY['人','在','多','岁的','时候','一句话','生活在','你','很','一份','工作','一段','爱情','一个','朋友','都是','这种','很久','明白','这','中的','的','不过','是','这些']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的'),
  2,
  ARRAY['别处','因为','可惜','要','过','所','手上','最终','得到','也不','第一个','站','错过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的'),
  3,
  ARRAY['总是','愿意','相信','当','轻易地','放弃','放手','才能','世上','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的'),
  4,
  ARRAY['之后','并不','存在','传说','转转']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的'),
  5,
  ARRAY['舍弃','拥有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人在20多岁的时候，总是愿意相信一句话：生活在别处。当你很轻易地放弃一份工作，很轻易地放手一段爱情，很轻易地舍弃一个朋友，都是因为这种相信。可惜总是要过很久之后才能明白，这世上并不存在传说中的"别处"你所拥有的，不过是你手上的这些。而你兜兜转转最终得到的，也不过是你在第一个站错过的'),
  6,
  ARRAY['兜兜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '做最真实最漂亮的自己，依心而行，别回头，别四顾，别管别人说什么。比不上你的，才议论你；比你强的，人家忙着赶路，根本不会多看你一眼',
  'zuò zuì zhēn shí zuì piào liang de zì jǐ ， yī xīn ér xíng ， bié huí tóu ， bié sì gù ， bié guǎn bié rén shuō shén me 。 bǐ bú shàng nǐ de ， cái yì lùn nǐ ； bǐ nǐ qiáng de ， rén jiā máng zhe gǎn lù ， gēn běn bú huì duō kàn nǐ yì yǎn',
  'Hãy là phiên bản chân thực và đẹp đẽ nhất của chính mình, sống theo trái tim, đừng ngoảnh lại, đừng nhìn quanh, và đừng bận tâm người khác nói gì. Những người không bằng bạn mới bàn tán về bạn; còn những người giỏi hơn bạn, họ bận rộn tiến về phía trước, thậm chí chẳng thèm liếc nhìn bạn lấy một lần.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做最真实最漂亮的自己，依心而行，别回头，别四顾，别管别人说什么。比不上你的，才议论你；比你强的，人家忙着赶路，根本不会多看你一眼'),
  1,
  ARRAY['做','漂亮的','回头','四顾','说','什么','你的','你','人家','会','多','看','一眼']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做最真实最漂亮的自己，依心而行，别回头，别四顾，别管别人说什么。比不上你的，才议论你；比你强的，人家忙着赶路，根本不会多看你一眼'),
  2,
  ARRAY['最','真实','别','别管','别人','比不上','比','忙','着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做最真实最漂亮的自己，依心而行，别回头，别四顾，别管别人说什么。比不上你的，才议论你；比你强的，人家忙着赶路，根本不会多看你一眼'),
  3,
  ARRAY['自己','心','而','行','才','议论','根本不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做最真实最漂亮的自己，依心而行，别回头，别四顾，别管别人说什么。比不上你的，才议论你；比你强的，人家忙着赶路，根本不会多看你一眼'),
  4,
  ARRAY['赶路']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '做最真实最漂亮的自己，依心而行，别回头，别四顾，别管别人说什么。比不上你的，才议论你；比你强的，人家忙着赶路，根本不会多看你一眼'),
  5,
  ARRAY['依','强的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重',
  'shēng huó rú shuǐ ， píng dàn zuì měi 。 rén shēng zhī lù ， yí dìng bú huì zǒng yǒu zhī fán yè mào de shù ， xiān yàn duó mù dì huā duǒ ， dié fēi fēng wù de měi hǎo jǐng sè ， tā yí dìng yě huì yǒu zǔ dǎng zài qián de gāo shān hé huāng liáng de shā mò ； yí dìng bú huì zǒng yǒu yáng guāng zhào yào xià bīn fēn de sè cǎi ， yě yí dìng huì yǒu yīn tiān shí de wù ǎi chóng chóng',
  'Cuộc sống như dòng nước, vẻ đẹp nằm ở sự bình dị. Trên con đường đời, không phải lúc nào cũng có những tán cây xanh tươi, những bông hoa rực rỡ, những cảnh đẹp như trong tranh với bướm bay và ong mật. Chắc chắn sẽ có những ngọn núi cao chắn lối và sa mạc hoang vu; không phải lúc nào cũng có ánh mặt trời rực rỡ, sẽ có những ngày u ám với sương mù dày đặc.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重'),
  1,
  ARRAY['生活','水','人生','一定','不会','的','飞','会','有','在前的','高山','和','下','时']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重'),
  2,
  ARRAY['最美','路','它','也','色彩','阴天']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重'),
  3,
  ARRAY['如','平淡','总有','树','鲜艳夺目的','花朵','阳光','照耀','重重']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重'),
  4,
  ARRAY['之','美好','景色','沙漠']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重'),
  5,
  ARRAY['蝶','蜂','雾','阻挡','缤纷','雾霭']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活如水，平淡最美。人生之路，一定不会总有枝繁叶茂的树，鲜艳夺目的花朵，蝶飞蜂雾的美好景色，它一定也会有阻挡在前的高山和荒凉的沙漠；一定不会总有阳光照耀下缤纷的色彩，也一定会有阴天时的雾霭重重'),
  6,
  ARRAY['枝繁叶茂','荒凉的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演',
  'zhēn shí de shēng huó shì qù rèn zhēn zuò hǎo měi yì tiān nǐ fèn nèi de shì qíng 。   bù suǒ qǔ mù qián yǔ nǐ wú guān de ài yǔ yuǎn jǐng 。 bú qù wàng xiǎng ， bú zài qí zhōng zì wǒ chén zuì 。 bù shāng hài ， bù yǔ zì jǐ hé tā rén wéi dí 。 bú qù biǎo yǎn ， yě bù xiāng xìn tā rén de biǎo yǎn',
  'Cuộc sống thực sự là chăm chỉ làm tốt những việc thuộc trách nhiệm của mình mỗi ngày. Đừng đòi hỏi tình yêu hay viễn cảnh không thuộc về mình lúc này. Đừng mơ mộng viển vông, đừng tự đắm chìm trong ảo tưởng. Đừng gây tổn thương, đừng chống lại bản thân hay người khác. Đừng diễn trò, và cũng đừng tin vào những màn trình diễn của người khác.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演'),
  1,
  ARRAY['生活','是','去','认真','做好','你','不','爱','不去','不在','和','他人','他人的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演'),
  2,
  ARRAY['真实的','每一天','事情','远景','为','表演','也不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演'),
  3,
  ARRAY['目前','其中','自我','自己','相信']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演'),
  4,
  ARRAY['份','内的','与','无关的','伤害']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演'),
  5,
  ARRAY['索取','沉醉','敌']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真实的生活是去认真做好每一天你份内的事情。 不索取目前与你无关的爱与远景。不去妄想，不在其中自我沉醉。不伤害，不与自己和他人为敌。不去表演，也不相信他人的表演'),
  6,
  ARRAY['妄想']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有',
  'yě xǔ nǐ xiàn zài réng rán shì yí gè rén xià bān ， yí gè rén chéng dì tiě ， yí gè rén shàng lóu ， yí gè rén chī fàn ， yí gè rén shuì jiào ， yí gè rén fā dāi 。 hěn duō rén lí kāi lìng wài yí gè rén ， jiù méi yǒu le zì jǐ 。 ér nǐ què yí gè rén ， dù guò le suǒ yǒu',
  'Có lẽ bây giờ bạn vẫn một mình tan ca, một mình đi tàu điện ngầm, một mình lên lầu, một mình ăn cơm, một mình ngủ, một mình ngẩn ngơ. Nhiều người khi rời xa người khác thì cũng đánh mất chính mình. Còn bạn, bạn đã vượt qua tất cả một mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  1,
  ARRAY['你','现在','是','一个人','下班','上楼','吃饭','睡觉','很多人','人','没有','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  2,
  ARRAY['也许','离开','就','所有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  3,
  ARRAY['发呆','自己','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  4,
  ARRAY['仍然','乘地铁','另外一个','却','度过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间不能减轻我们所受的伤害，但却能让我们变得不那么害怕伤害。时间也不会帮我们解决问题，只会把原来怎么也想不通的问题，变得不再重要',
  'shí jiān bù néng jiǎn qīng wǒ men suǒ shòu de shāng hài ， dàn què néng ràng wǒ men biàn de bú nà me hài pà shāng hài 。 shí jiān yě bú huì bāng wǒ men jiě jué wèn tí ， zhī huì bǎ yuán lái zěn me yě xiǎng bù tōng de wèn tí ， biàn de bú zài zhòng yào',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间不能减轻我们所受的伤害，但却能让我们变得不那么害怕伤害。时间也不会帮我们解决问题，只会把原来怎么也想不通的问题，变得不再重要'),
  1,
  ARRAY['时间','不能','我们','的','能','们','不','那么','会','怎么','想不通','不再重要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间不能减轻我们所受的伤害，但却能让我们变得不那么害怕伤害。时间也不会帮我们解决问题，只会把原来怎么也想不通的问题，变得不再重要'),
  2,
  ARRAY['所','但','让我','也不','帮','也','问题']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间不能减轻我们所受的伤害，但却能让我们变得不那么害怕伤害。时间也不会帮我们解决问题，只会把原来怎么也想不通的问题，变得不再重要'),
  3,
  ARRAY['变得','害怕','解决问题','只','把']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间不能减轻我们所受的伤害，但却能让我们变得不那么害怕伤害。时间也不会帮我们解决问题，只会把原来怎么也想不通的问题，变得不再重要'),
  4,
  ARRAY['减轻','受','伤害','却','原来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望',
  'mài chū jiǎo bù qù nǐ zhī qián bù gǎn shè zú de dì fāng ， shēn chū bì bǎng jù qù yōng bào guò qù bù gǎn pèng chù de lǐng dì ， nǐ huì fā xiàn ， yuán lái shēng huó bù zhǐ yǒu nà yì diǎn ér tiān dì ， nǐ kě yǐ ràng zì jǐ guò dé gèng hǎo ， yě kě yǐ ràng shēn biān de rén jué de hé nǐ zài yì qǐ chōng mǎn zhe xī wàng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望'),
  1,
  ARRAY['去','你','不敢','的','会','生活','不只','有','那','一点儿','天地','人','觉得','和','在一起']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望'),
  2,
  ARRAY['过去','可以','让','过','得','也','身边','希望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望'),
  3,
  ARRAY['脚步','地方','句','发现','自己','更好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望'),
  4,
  ARRAY['之前','原来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望'),
  5,
  ARRAY['伸出','拥抱','碰触','领地','充满着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '迈出脚步去你之前不敢涉足的地方，伸出臂膀句去拥抱过去不敢碰触的领地，你会发现，原来生活不只有那一点儿天地，你可以让自己过得更好，也可以让身边的人觉得和你在一起充满着希望'),
  6,
  ARRAY['迈出','涉足','臂膀']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '如果你感到委屈，证明你还有底线；如果你感到迷茫，证明你还有追求；如果你感到痛苦，证明你还有力气；如果你感到绝望，证明你还要希望。 从某种意义上，你永远都不会被打倒，因为你还有你',
  'rú guǒ nǐ gǎn dào wěi qu ， zhèng míng nǐ hái yǒu dǐ xiàn ； rú guǒ nǐ gǎn dào mí máng ， zhèng míng nǐ hái yǒu zhuī qiú ； rú guǒ nǐ gǎn dào tòng kǔ ， zhèng míng nǐ hái yǒu lì qi ； rú guǒ nǐ gǎn dào jué wàng ， zhèng míng nǐ hái yào xī wàng 。   cóng mǒu zhǒng yì yì shàng ， nǐ yǒng yuǎn dōu bú huì bèi dǎ dǎo ， yīn wèi nǐ hái yǒu nǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你感到委屈，证明你还有底线；如果你感到迷茫，证明你还有追求；如果你感到痛苦，证明你还有力气；如果你感到绝望，证明你还要希望。 从某种意义上，你永远都不会被打倒，因为你还有你'),
  1,
  ARRAY['你','上','都','不会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你感到委屈，证明你还有底线；如果你感到迷茫，证明你还有追求；如果你感到痛苦，证明你还有力气；如果你感到绝望，证明你还要希望。 从某种意义上，你永远都不会被打倒，因为你还有你'),
  2,
  ARRAY['还有','还要','希望','从','意义','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你感到委屈，证明你还有底线；如果你感到迷茫，证明你还有追求；如果你感到痛苦，证明你还有力气；如果你感到绝望，证明你还要希望。 从某种意义上，你永远都不会被打倒，因为你还有你'),
  3,
  ARRAY['如果','感到委屈','感到','感到痛苦','力气','被打倒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你感到委屈，证明你还有底线；如果你感到迷茫，证明你还有追求；如果你感到痛苦，证明你还有力气；如果你感到绝望，证明你还要希望。 从某种意义上，你永远都不会被打倒，因为你还有你'),
  4,
  ARRAY['证明','底线','迷茫','绝望','永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你感到委屈，证明你还有底线；如果你感到迷茫，证明你还有追求；如果你感到痛苦，证明你还有力气；如果你感到绝望，证明你还要希望。 从某种意义上，你永远都不会被打倒，因为你还有你'),
  5,
  ARRAY['追求','某种']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容',
  'nǐ xiàn mù bié rén shēng bìng le yǒu nà me duō rén guān xīn ， xiàn mù bié rén chū qù wán yǒu rén péi bàn ， xiàn mù bié rén měi tiān yǒu rén shuō zǎo ān wǎn ān ， xiàn mù bié rén yǒu nà me duō rén jì de tā men de shēng rì ， xiàn mù bié rén měi gè jié rì dōu yǒu rén zhù fú ， ér yǐ wéi zì jǐ shén me dōu méi yǒu 。 qí shí ， zài bié rén yǎn lǐ ， tā men xiàn mù nǐ yí gè rén kě yǐ nà me jiān qiáng ， xiàn mù nǐ yí gè rén kě yǐ dàn dìng cóng róng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容'),
  1,
  ARRAY['你','生病','了','有','那么多','人','关心','出去','有人','有人说','他们的','生日','都','什么','没有','在','他们','一个人','那么']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容'),
  2,
  ARRAY['别人','玩','每天','早安','晚安','每个','以为','眼里','可以','从容']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容'),
  3,
  ARRAY['记得','节日','而','自己','其实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容'),
  4,
  ARRAY['羡慕','陪伴','祝福','坚强']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容'),
  5,
  ARRAY['淡定']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容。你羡慕别人，别人羡慕你，然后各自生活',
  'nǐ xiàn mù bié rén shēng bìng le yǒu nà me duō rén guān xīn ， xiàn mù bié rén chū qù wán yǒu rén péi bàn ， xiàn mù bié rén měi tiān yǒu rén shuō zǎo ān wǎn ān ， xiàn mù bié rén yǒu nà me duō rén jì de tā men de shēng rì ， xiàn mù bié rén měi gè jié rì dōu yǒu rén zhù fú ， ér yǐ wéi zì jǐ shén me dōu méi yǒu 。 qí shí ， zài bié rén yǎn lǐ ， tā men xiàn mù nǐ yí gè rén kě yǐ nà me jiān qiáng ， xiàn mù nǐ yí gè rén kě yǐ dàn dìng cóng róng 。 nǐ xiàn mù bié rén ， bié rén xiàn mù nǐ ， rán hòu gè zì shēng huó',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容。你羡慕别人，别人羡慕你，然后各自生活'),
  1,
  ARRAY['你','生病','了','有','那么多','人','关心','出去','有人','有人说','他们的','生日','都','什么','没有','在','他们','一个人','那么','生活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容。你羡慕别人，别人羡慕你，然后各自生活'),
  2,
  ARRAY['别人','玩','每天','早安','晚安','每个','以为','眼里','可以','从容','然后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容。你羡慕别人，别人羡慕你，然后各自生活'),
  3,
  ARRAY['记得','节日','而','自己','其实']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容。你羡慕别人，别人羡慕你，然后各自生活'),
  4,
  ARRAY['羡慕','陪伴','祝福','坚强','各自']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人生病了有那么多人关心，羡慕别人出去玩有人陪伴，羡慕别人每天有人说早安晚安，羡慕别人有那么多人记得他们的生日，羡慕别人每个节日都有人祝福，而以为自己什么都没有。其实，在别人眼里，他们羡慕你一个人可以那么坚强，羡慕你一个人可以淡定从容。你羡慕别人，别人羡慕你，然后各自生活'),
  5,
  ARRAY['淡定']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你',
  'xiāng xìn rén shēng bú huì kuī dài nǐ ， nǐ chī de kǔ ， nǐ shòu de lèi ， nǐ diào jìn de kēng ， nǐ zǒu cuò de lù ， dōu huì liàn jiù dú yī wú èr ， chéng shú jiān qiáng ， dǒng de gǎn ēn de nǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你'),
  1,
  ARRAY['人生','不会','你','吃的','的','都会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你'),
  2,
  ARRAY['累','进','走','错','路','懂得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你'),
  3,
  ARRAY['相信','练就','成熟','感恩']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你'),
  4,
  ARRAY['苦','受','掉','坚强']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你'),
  5,
  ARRAY['亏待','独一无二']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '相信人生不会亏待你，你吃的苦，你受的累，你掉进的坑，你走错的路，都会练就独一无二，成熟坚强，懂得感恩的你'),
  6,
  ARRAY['坑']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了',
  'rén zhè me yí bèi zi ， nián qīng shí suǒ shòu de kǔ bú shì kǔ ， dōu bú guò shì yí kuài tiào bǎn 。 rén zài tiào bǎn shàng ， zuì nán de bú shì tiào xià lái nà yí kè ， ér shì tiào xià lái zhī qián ， xīn lǐ de zhēng zhá ， yóu yù ， wú zhù hé huàn dé huàn shī ， gēn běn wú fǎ xiàng bié rén qīng sù 。 wǒ men yǐ wéi tiào bú guò qù le ， bì shàng yǎn jīng ， gǔ qǐ yǒng qì ， què tiào guò le',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了'),
  1,
  ARRAY['人','这么','一辈子','年轻时','的','不是','都','不过','是','一块','在','上','来','那','一刻','和','我们','去了','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了'),
  2,
  ARRAY['所','跳板','最','跳下','别人','以为','跳','眼睛','跳过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了'),
  3,
  ARRAY['难的','而是','心里','根本','向']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了'),
  4,
  ARRAY['受','苦','之前','无助','无法','鼓起勇气','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了'),
  5,
  ARRAY['挣扎','犹豫','闭上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人这么一辈子，年轻时所受的苦不是苦，都不过是一块跳板。人在跳板上，最难的不是跳下来那一刻，而是跳下来之前，心里的挣扎，犹豫，无助和患得患失，根本无法向别人倾诉。我们以为跳不过去了，闭上眼睛，鼓起勇气，却跳过了'),
  6,
  ARRAY['患得患失','倾诉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '只有放下那些无谓的负担，我们才能一路潇洒前行。护士生活的原味，累是人生的本质',
  'zhǐ yǒu fàng xià nà xiē wú wèi de fù dān ， wǒ men cái néng yí lù xiāo sǎ qián xíng 。 hù shì shēng huó de yuán wèi ， lèi shì rén shēng de běn zhì',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有放下那些无谓的负担，我们才能一路潇洒前行。护士生活的原味，累是人生的本质'),
  1,
  ARRAY['那些','的','我们','一路','前行','生活的','是','人生','本质']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有放下那些无谓的负担，我们才能一路潇洒前行。护士生活的原味，累是人生的本质'),
  2,
  ARRAY['累']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有放下那些无谓的负担，我们才能一路潇洒前行。护士生活的原味，累是人生的本质'),
  3,
  ARRAY['只有','放下','才能','护士']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有放下那些无谓的负担，我们才能一路潇洒前行。护士生活的原味，累是人生的本质'),
  4,
  ARRAY['无谓','负担','原味']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '只有放下那些无谓的负担，我们才能一路潇洒前行。护士生活的原味，累是人生的本质'),
  6,
  ARRAY['潇洒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你',
  'shēng huó bú huì yīn wèi nǐ shì nǚ shēng jiù lián xiāng xī yù 。 xué huì cóng yǐ xià mó lì zhōng shēng huá chū gèng hǎo de zì jǐ 。 yào jì zhù ： zuì yōu xiù de nà ge yí dìng shì míng tiān de nǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你'),
  1,
  ARRAY['生活','不会','你','是','女生','学会','中','出','那个','一定','明天','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你'),
  2,
  ARRAY['因为','就','从','以下','要','最优秀的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你'),
  3,
  ARRAY['更好的','自己','记住']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你'),
  4,
  ARRAY['怜香惜玉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你'),
  5,
  ARRAY['升华']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活不会因为你是女生就怜香惜玉。学会从以下磨砺中升华出更好的自己。要记住：最优秀的那个一定是明天的你'),
  6,
  ARRAY['磨砺']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不知道从何时开始，那些曾经让我执着的人和事都变得可有可无。时间慢慢告诉了我，要学会说',
  'bù zhī dào cóng hé shí kāi shǐ ， nà xiē céng jīng ràng wǒ zhí zhe de rén hé shì dōu biàn de kě yǒu kě wú 。 shí jiān màn màn gào sù le wǒ ， yào xué huì shuō',
  'Không biết từ khi nào, những người và việc từng khiến tôi cố chấp giờ đã trở nên không còn quan trọng. Thời gian dần dần dạy tôi phải học cách buông bỏ.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道从何时开始，那些曾经让我执着的人和事都变得可有可无。时间慢慢告诉了我，要学会说'),
  1,
  ARRAY['不知道','开始','那些','人和','都','时间','了','我','学会','说']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道从何时开始，那些曾经让我执着的人和事都变得可有可无。时间慢慢告诉了我，要学会说'),
  2,
  ARRAY['从','让我','事','可有可无','慢慢','告诉','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道从何时开始，那些曾经让我执着的人和事都变得可有可无。时间慢慢告诉了我，要学会说'),
  3,
  ARRAY['变得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道从何时开始，那些曾经让我执着的人和事都变得可有可无。时间慢慢告诉了我，要学会说'),
  4,
  ARRAY['何时']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不知道从何时开始，那些曾经让我执着的人和事都变得可有可无。时间慢慢告诉了我，要学会说'),
  5,
  ARRAY['曾经','执着的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有',
  'yě xǔ nǐ xiàn zài réng rán shì yí gè rén xià bān ， yí gè rén chéng dì tiě ， yí gè rén shàng lóu ， yí gè rén chī fàn ， yí gè rén shuì jiào ， yí gè rén fā dāi 。 hěn duō rén lí kāi lìng wài yí gè rén ， jiù méi yǒu le zì jǐ 。 ér nǐ què yí gè rén ， dù guò le suǒ yǒu',
  'Có lẽ bây giờ bạn vẫn một mình tan ca, một mình đi tàu điện ngầm, một mình lên lầu, một mình ăn cơm, một mình ngủ, một mình ngẩn ngơ. Nhiều người khi rời xa người khác thì cũng đánh mất chính mình. Còn bạn, bạn đã vượt qua tất cả một mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  1,
  ARRAY['你','现在','是','一个人','下班','上楼','吃饭','睡觉','很多人','人','没有','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  2,
  ARRAY['也许','离开','就','所有']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  3,
  ARRAY['发呆','自己','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你现在仍然是一个人下班，一个人乘地铁，一个人上楼，一个人吃饭，一个人睡觉，一个人发呆。很多人离开另外一个人，就没有了自己。而你却一个人，度过了所有'),
  4,
  ARRAY['仍然','乘地铁','另外一个','却','度过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '来到这世上，总会有许多不如意，也会有许多不公平，会有许多失落，也会有许多羡慕。你羡慕我的自由，我羡慕你的约束；你羡慕我的车，我羡慕你的房；真正的美丽，不是青春的容颜，而是绽放的心灵；不是巧言令色，而是真诚与人；不是物质的附庸，是知识的光芒',
  'lái dào zhè shì shàng ， zǒng huì yǒu xǔ duō bù rú yì ， yě huì yǒu xǔ duō bù gōng píng ， huì yǒu xǔ duō shī luò ， yě huì yǒu xǔ duō xiàn mù 。 nǐ xiàn mù wǒ de zì yóu ， wǒ xiàn mù nǐ de yuē shù ； nǐ xiàn mù wǒ de chē ， wǒ xiàn mù nǐ de fáng ； zhēn zhèng de měi lì ， bú shì qīng chūn de róng yán ， ér shì zhàn fàng de xīn líng ； bú shì qiǎo yán lìng sè ， ér shì zhēn chéng yǔ rén ； bú shì wù zhì de fù yōng ， shì zhī shi de guāng máng',
  'Khi đến thế gian này, chắc chắn sẽ có nhiều điều không như ý, nhiều sự bất công, nhiều nỗi thất vọng và cũng nhiều sự ngưỡng mộ. Bạn ngưỡng mộ tự do của tôi, tôi ngưỡng mộ sự ràng buộc của bạn; bạn ngưỡng mộ xe của tôi, tôi ngưỡng mộ nhà của bạn; vẻ đẹp thực sự không phải là dung nhan tuổi trẻ, mà là tâm hồn tỏa sáng; không phải lời nói ngọt ngào mà là sự chân thành; không phải sự phụ thuộc vào vật chất, mà là ánh sáng của tri thức.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '来到这世上，总会有许多不如意，也会有许多不公平，会有许多失落，也会有许多羡慕。你羡慕我的自由，我羡慕你的约束；你羡慕我的车，我羡慕你的房；真正的美丽，不是青春的容颜，而是绽放的心灵；不是巧言令色，而是真诚与人；不是物质的附庸，是知识的光芒'),
  1,
  ARRAY['来到','这','有','不如意','会','不公平','你','我的','我','你的','车','不是','的','人','是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '来到这世上，总会有许多不如意，也会有许多不公平，会有许多失落，也会有许多羡慕。你羡慕我的自由，我羡慕你的约束；你羡慕我的车，我羡慕你的房；真正的美丽，不是青春的容颜，而是绽放的心灵；不是巧言令色，而是真诚与人；不是物质的附庸，是知识的光芒'),
  2,
  ARRAY['也','房','真正的','真诚','知识的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '来到这世上，总会有许多不如意，也会有许多不公平，会有许多失落，也会有许多羡慕。你羡慕我的自由，我羡慕你的约束；你羡慕我的车，我羡慕你的房；真正的美丽，不是青春的容颜，而是绽放的心灵；不是巧言令色，而是真诚与人；不是物质的附庸，是知识的光芒'),
  3,
  ARRAY['世上','总会','自由','容颜','而是','绽放','心灵','物质的','附庸']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '来到这世上，总会有许多不如意，也会有许多不公平，会有许多失落，也会有许多羡慕。你羡慕我的自由，我羡慕你的约束；你羡慕我的车，我羡慕你的房；真正的美丽，不是青春的容颜，而是绽放的心灵；不是巧言令色，而是真诚与人；不是物质的附庸，是知识的光芒'),
  4,
  ARRAY['许多','失落','羡慕','约束','美丽','巧言令色','与','光芒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '来到这世上，总会有许多不如意，也会有许多不公平，会有许多失落，也会有许多羡慕。你羡慕我的自由，我羡慕你的约束；你羡慕我的车，我羡慕你的房；真正的美丽，不是青春的容颜，而是绽放的心灵；不是巧言令色，而是真诚与人；不是物质的附庸，是知识的光芒'),
  5,
  ARRAY['青春的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '日子一天天过去，讨厌的人会带着讨人厌的话离开，喜欢的人会带着美好的事到来。把目光放在别处，洒脱还给自己',
  'rì zi yì tiān tiān guò qù ， tǎo yàn de rén huì dài zhe tǎo rén yàn de huà lí kāi ， xǐ huan de rén huì dài zhe měi hǎo de shì dào lái 。 bǎ mù guāng fàng zài bié chù ， sǎ tuō hái gěi zì jǐ',
  'Ngày qua ngày, những người mình ghét sẽ mang theo những lời khó chịu ra đi, còn người mình thích sẽ mang đến những điều tốt đẹp. Hãy hướng ánh nhìn sang nơi khác, trả lại sự tự do cho chính mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子一天天过去，讨厌的人会带着讨人厌的话离开，喜欢的人会带着美好的事到来。把目光放在别处，洒脱还给自己'),
  1,
  ARRAY['一天天','会','话','喜欢的','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子一天天过去，讨厌的人会带着讨人厌的话离开，喜欢的人会带着美好的事到来。把目光放在别处，洒脱还给自己'),
  2,
  ARRAY['日子','过去','着','离开','事','到来','别处','还给']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子一天天过去，讨厌的人会带着讨人厌的话离开，喜欢的人会带着美好的事到来。把目光放在别处，洒脱还给自己'),
  3,
  ARRAY['带','把','目光','放在','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子一天天过去，讨厌的人会带着讨人厌的话离开，喜欢的人会带着美好的事到来。把目光放在别处，洒脱还给自己'),
  4,
  ARRAY['讨厌的人','讨人厌的','美好的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子一天天过去，讨厌的人会带着讨人厌的话离开，喜欢的人会带着美好的事到来。把目光放在别处，洒脱还给自己'),
  5,
  ARRAY['洒脱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢',
  'bù xiǎng jīng lì dà xǐ dà bēi ， bú yuàn bēi fù tài duō qī pàn ， xiǎng ràng shēng huó biàn de jiǎn dān ， xiǎng ràng zì jǐ suí yù ér ān ， ǒu ěr qiāo qiāo huàn xiǎng ， ǒu ěr qiǎn qiǎn làng màn 。 kě shì tài duō shí hòu ， hái shì zhǐ néng chéng shòu fù dān ， dú zì jiān qiáng 。 zài zhè ge cōng máng de shì jiè ， méi rén yǒu shí jiān zhào gù nǐ 。 nǐ ruò bù jiān qiáng ， shuí tì nǐ yǒng gǎn',
  'Không muốn trải qua những niềm vui hay nỗi buồn quá lớn, không muốn gánh vác quá nhiều kỳ vọng, chỉ muốn cuộc sống trở nên đơn giản, để bản thân tùy duyên, thỉnh thoảng mơ mộng, thỉnh thoảng lãng mạn nhẹ nhàng. Nhưng quá nhiều lúc, ta vẫn chỉ có thể chịu đựng áp lực và mạnh mẽ một mình. Trong thế giới bận rộn này, không ai có thời gian chăm sóc bạn. Nếu bạn không mạnh mẽ, ai sẽ thay bạn dũng cảm?',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢'),
  1,
  ARRAY['不想','大喜','大','不愿','太多','期盼','想','生活','时候','在','这个','没人','有时','你','不','谁']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢'),
  2,
  ARRAY['经历','让','可是','还是','间']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢'),
  3,
  ARRAY['变得','简单','自己','只能','世界','照顾']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢'),
  4,
  ARRAY['随遇而安','偶尔','浪漫','负担','坚强','勇敢']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢'),
  5,
  ARRAY['悲','背负','悄悄','幻想','浅浅','承受','独自','匆忙的','替']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不想经历大喜大悲，不愿背负太多期盼，想让生活变得简单，想让自己随遇而安，偶尔悄悄幻想，偶尔浅浅浪漫。可是太多时候，还是只能承受负担，独自坚强。在这个匆忙的世界，没人有时间照顾你。你若不坚强，谁替你勇敢'),
  6,
  ARRAY['若']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世',
  'rén shēng zhōng xǔ duō dāng xià wú jiě de nán tí ， dù guò de wéi yī fāng shì jiù shì shì kǔ kǔ de jiān áo ， áo dào yí bù fen de zì jǐ sǐ qù ， áo dào yí bù fen de zì jǐ xǐng lái ， áo dào tuō tāi huàn gǔ ， huǎng ruò gé shì',
  'Trong cuộc đời, nhiều vấn đề khó khăn không thể giải quyết ngay lập tức, cách duy nhất để vượt qua là chịu đựng trong đau khổ, chịu đựng đến khi một phần của bản thân như chết đi, chịu đựng đến khi một phần khác tỉnh dậy, chịu đựng đến khi bản thân thay đổi hoàn toàn, như thể đã sống một kiếp khác.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世'),
  1,
  ARRAY['人生','中','的','是','一部分的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世'),
  2,
  ARRAY['就是','到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世'),
  3,
  ARRAY['当下','解','难题','方式','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世'),
  4,
  ARRAY['许多','无','度过','苦苦','死去','醒来','脱胎换骨']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世'),
  5,
  ARRAY['唯一','熬']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生中许多当下无解的难题，度过的唯一方式就是是苦苦的煎熬，熬到一部分的自己死去，熬到一部分的自己醒来，熬到脱胎换骨，恍若隔世'),
  6,
  ARRAY['煎熬','恍若隔世']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要',
  'měi gè rén zǒng yǒu zhè yàng de shí hòu ： zuì xiǎng liú lèi de shì fā shēng shí ， sǐ chēng zhe bù kěn luò yì dī yǎn lèi 。 zuì xiǎng wǎn liú de rén lí kāi shí ， yǎo jǐn le yá bù kěn shuō yí jù wǎn liú 。 xīn lǐ wú shù cì jiào rǎng zhuó xiǎng tóu xiáng ， liǎn shàng què yáng zhuāng chū yí fù háo bú zài hu de biǎo qíng 。 nà yí kè jué de zì jǐ hǎo jiān qiáng ， qīng chūn jiù zài téng tòng de qiān qiǎng zhōng yì tiān tiān xiāo hào guāng 。 gòu hòu cái dǒng ， yīn wèi ruǎn ruò ， suǒ yǐ chěng qiáng 。 zǒng bǎ zì zūn kàn dé bǐ mìng hái zhòng yào',
  'Mỗi người đều có những lúc như thế này: Khi điều khiến mình muốn khóc nhất xảy ra, ta cố gắng chịu đựng mà không để rơi một giọt nước mắt. Khi người mà ta muốn níu giữ nhất rời đi, ta cắn chặt răng không thốt ra một lời giữ lại. Trong lòng vô số lần muốn đầu hàng, nhưng trên gương mặt lại giả vờ ra vẻ không quan tâm. Lúc đó, ta nghĩ mình thật mạnh mẽ, nhưng thanh xuân cứ thế dần trôi qua trong sự cố gắng gượng ép đầy đau đớn. Chỉ khi đã trải qua đủ, ta mới hiểu rằng, vì yếu đuối nên mới cố tỏ ra mạnh mẽ. Luôn coi lòng tự trọng quan trọng hơn cả mạng sống.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要'),
  1,
  ARRAY['这样的','时候','想','生','时','不肯','一滴','的','人','了','说','一句','叫嚷','出','一','不在乎的','那','一刻','觉得','好','在','中','一天天','后','看']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要'),
  2,
  ARRAY['每个人','最','事发','着','眼泪','离开','着想','表情','就','懂','因为','所以','得','比','还']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要'),
  3,
  ARRAY['总有','牙','心里','脸上','自己','疼痛的','才','总','把','自尊','重要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要'),
  4,
  ARRAY['流泪的','死','落','紧','无数次','却','洋装','富豪','坚强','消耗','光','够','命']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要'),
  5,
  ARRAY['咬','投降','青春','软弱','逞强']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人总有这样的时候：最想流泪的事发生时，死撑着不肯落一滴眼泪。最想挽留的人离开时，咬紧了牙不肯说一句挽留。心里无数次叫嚷着想投降，脸上却洋装出一富豪不在乎的表情。那一刻觉得自己好坚强，青春就在疼痛的牵强中一天天消耗光。够后才懂，因为软弱，所以逞强。总把自尊看得比命还重要'),
  6,
  ARRAY['撑','挽留','牵强']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选',
  'yù jiàn le xíng xíng sè sè de rén zhī hòu ， nǐ cái zhī dào ， yuán lái shì jiè shàng chú le fù mǔ bú huì yǒu rén tāo xīn tāo fèi duì nǐ ， bú huì yǒu rén wú tiáo jiàn wán quán xìn rèn nǐ ， yě bú huì yǒu rén yì zhí duì nǐ hǎo ， nǐ zǎo gāi míng bái ， tiān huì hēi ， rén huì biàn ， rén shēng nà me cháng ， lù nà me yuǎn ， nǐ zhǐ néng kào zì jǐ ， bié wú tā xuǎn',
  'Sau khi gặp gỡ đủ loại người, bạn mới nhận ra rằng, trên đời này ngoài cha mẹ ra, sẽ không có ai hết lòng vì bạn, không ai hoàn toàn tin tưởng bạn vô điều kiện, cũng không ai luôn đối xử tốt với bạn. Bạn sớm nên hiểu rằng, trời sẽ tối, người sẽ thay đổi, cuộc đời dài như vậy, con đường xa như thế, bạn chỉ có thể dựa vào chính mình, không còn lựa chọn nào khác.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选'),
  1,
  ARRAY['了','人','你','不会','有人','对','会','一直','你好','明白','天会','人生','那么','他']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选'),
  2,
  ARRAY['知道','完全','也不','早','黑','长','路','远','别无']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选'),
  3,
  ARRAY['遇见','才','世界上','除了','信任','该','变','只能','选']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选'),
  4,
  ARRAY['之后','原来','父母','无条件']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选'),
  5,
  ARRAY['形形色色的','靠自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '遇见了形形色色的人之后，你才知道，原来世界上除了父母不会有人掏心掏肺对你，不会有人无条件完全信任你，也不会有人一直对你好，你早该明白，天会黑，人会变，人生那么长，路那么远，你只能靠自己，别无他选'),
  6,
  ARRAY['掏心掏肺']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生活总是这样，不能叫人处处都满意，但我们还要热情地活下去',
  'shēng huó zǒng shì zhè yàng ， bù néng jiào rén chù chù dōu mǎn yì ， dàn wǒ men hái yào rè qíng dì huó xià qù',
  'Cuộc sống luôn như vậy, không thể làm hài lòng tất cả mọi thứ, nhưng chúng ta vẫn phải sống hết mình với nhiệt huyết.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意，但我们还要热情地活下去'),
  1,
  ARRAY['生活','这样','不能','叫','人','都','我们','热情地']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意，但我们还要热情地活下去'),
  2,
  ARRAY['但','还要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意，但我们还要热情地活下去'),
  3,
  ARRAY['总是','满意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意，但我们还要热情地活下去'),
  4,
  ARRAY['处处','活下去']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活',
  'dāng yǎn lèi diào xià lái de shí hòu ， shì zhēn de lèi le ， qí shí rén shēng jiù shì zhè yàng ： nǐ yǒu nǐ de fán ， wǒ yǒu wǒ de nán ， rén rén dōu yǒu wú shēng de lèi ， rén rén dōu yǒu nán yán de kǔ 。 wàng bù liǎo de zuó tiān ， máng bù wán de jīn tiān ， xiǎng bú dào de míng tiān ， zǒu bù wán de rén shēng ， guò bù wán de kǎn kě ， yuè bú guò de wú nài ， tīng bù wán de huǎng yán ， kàn bú tòu de rén xīn ， fàng bú xià de qiān guà ， jīng lì bù wán de suān tián kǔ là ， zhè jiù shì wén shēng ， zhè jiù shì shēng huó',
  'Khi nước mắt rơi xuống, đó là lúc thực sự mệt mỏi. Thực ra cuộc đời là như vậy: Bạn có nỗi phiền não của bạn, tôi có khó khăn của tôi, ai cũng có những giọt nước mắt âm thầm, ai cũng có những nỗi đau khó nói. Hôm qua không thể quên, hôm nay bận rộn không ngừng, ngày mai không thể ngờ tới, cuộc đời dài không thể đi hết, những gập ghềnh không thể vượt qua, những bất lực không thể vượt qua, những lời nói dối nghe không hết, lòng người khó đoán, những lo lắng không thể buông bỏ, vô vàn những cung bậc cảm xúc, đó chính là cuộc sống.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  1,
  ARRAY['的','时候','是','人生','这样','你有','你的','我有','我的','人人都','有','昨天','不','今天','想不到的','明天','不过','听','看','人心','这','生活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  2,
  ARRAY['眼泪','真的','累了','就是','忙','完','走','过','经历']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  3,
  ARRAY['当','其实','难','忘不了的','越','放不下','文生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  4,
  ARRAY['掉下来','烦','无声的','言','苦','无奈','酸甜苦辣']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  5,
  ARRAY['泪','透']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  6,
  ARRAY['谎言','牵挂']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当眼泪掉下来的时候，是真的累了，其实人生就是这样：你有你的烦，我有我的难，人人都有无声的泪，人人都有难言的苦。忘不了的昨天，忙不完的今天，想不到的明天，走不完的人生，过不完的坎坷，越不过的无奈，听不完的谎言，看不透的人心，放不下的牵挂，经历不完的酸甜苦辣，这就是文生，这就是生活'),
  ARRAY['坎','坷']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不管世界上所有人怎么说，我都认为自己的感受才是正确的。无论别人怎么看，我绝不打乱自己的节奏。喜欢的事自然可以坚持，不喜欢的怎么也长久不了',
  'bù guǎn shì jiè shàng suǒ yǒu rén zěn me shuō ， wǒ dōu rèn wéi zì jǐ de gǎn shòu cái shì zhèng què de 。 wú lùn bié rén zěn me kàn ， wǒ jué bù dǎ luàn zì jǐ de jié zòu 。 xǐ huan de shì zì rán kě yǐ jiān chí ， bù xǐ huan de zěn me yě cháng jiǔ bù liǎo',
  'Dù cả thế giới có nói gì đi nữa, tôi vẫn tin rằng cảm nhận của mình mới là đúng. Dù người khác có nhìn nhận ra sao, tôi sẽ không bao giờ phá vỡ nhịp điệu của chính mình. Điều mình yêu thích tự nhiên có thể kiên trì, còn điều không thích thì dù cố gắng thế nào cũng khó mà kéo dài.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管世界上所有人怎么说，我都认为自己的感受才是正确的。无论别人怎么看，我绝不打乱自己的节奏。喜欢的事自然可以坚持，不喜欢的怎么也长久不了'),
  1,
  ARRAY['不管','怎么','说','我','都','认为','看','打乱','喜欢的','不喜欢','的','不了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管世界上所有人怎么说，我都认为自己的感受才是正确的。无论别人怎么看，我绝不打乱自己的节奏。喜欢的事自然可以坚持，不喜欢的怎么也长久不了'),
  2,
  ARRAY['所有人','正确的','别人','事','可以','也','长久']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管世界上所有人怎么说，我都认为自己的感受才是正确的。无论别人怎么看，我绝不打乱自己的节奏。喜欢的事自然可以坚持，不喜欢的怎么也长久不了'),
  3,
  ARRAY['世界上','自己的','感受','才是','节奏','自然']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不管世界上所有人怎么说，我都认为自己的感受才是正确的。无论别人怎么看，我绝不打乱自己的节奏。喜欢的事自然可以坚持，不喜欢的怎么也长久不了'),
  4,
  ARRAY['无论','绝不','坚持']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '愿你所有的努力都不白费，所想的都能如愿，所做的都能实现，愿你往后路途，深情不再枉付',
  'yuàn nǐ suǒ yǒu de nǔ lì dōu bù bái fèi ， suǒ xiǎng de dōu néng rú yuàn ， suǒ zuò de dōu néng shí xiàn ， yuàn nǐ wǎng hòu lù tú ， shēn qíng bú zài wǎng fù',
  'Mong rằng mọi nỗ lực của bạn đều không uổng phí, những gì bạn mong muốn đều thành hiện thực, và những gì bạn làm đều đạt được. Mong rằng trên chặng đường phía trước, tình cảm sâu đậm của bạn sẽ không còn bị lãng phí.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '愿你所有的努力都不白费，所想的都能如愿，所做的都能实现，愿你往后路途，深情不再枉付'),
  1,
  ARRAY['你','都','不','的','能','做','不再']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '愿你所有的努力都不白费，所想的都能如愿，所做的都能实现，愿你往后路途，深情不再枉付'),
  2,
  ARRAY['所有的','白费','所想','所','往后','路途']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '愿你所有的努力都不白费，所想的都能如愿，所做的都能实现，愿你往后路途，深情不再枉付'),
  3,
  ARRAY['愿','努力','如愿','实现']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '愿你所有的努力都不白费，所想的都能如愿，所做的都能实现，愿你往后路途，深情不再枉付'),
  4,
  ARRAY['深情','付']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '愿你所有的努力都不白费，所想的都能如愿，所做的都能实现，愿你往后路途，深情不再枉付'),
  6,
  ARRAY['枉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人一定要旅行，尤其是女孩子。一个女孩子见识很重要，你见得多了自然就会心胸豁达，饰演宽广，会影响到自己对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它让你更有信心，不会在精神世界里迷失方向',
  'rén yí dìng yào lǚ xíng ， yóu qí shì nǚ hái zi 。 yí gè nǚ hái zi jiàn shi hěn zhòng yào ， nǐ jiàn dé duō le zì rán jiù huì xīn xiōng huō dá ， shì yǎn kuān guǎng ， huì yǐng xiǎng dào zì jǐ duì hěn duō shì qíng de kàn fǎ 。 lǚ xíng ràng rén jiàn duō shí guǎng ， duì nǚ hái zi lái shuō gèng shì rú cǐ ， tā ràng nǐ gèng yǒu xìn xīn ， bú huì zài jīng shén shì jiè lǐ mí shī fāng xiàng',
  'Con người nhất định phải đi du lịch, đặc biệt là các bạn gái. Sự hiểu biết của một cô gái rất quan trọng, khi bạn đã trải nghiệm nhiều, tự nhiên sẽ trở nên cởi mở hơn, bao dung hơn, điều này sẽ ảnh hưởng đến cách nhìn nhận của bạn về nhiều vấn đề. Du lịch giúp mở rộng tầm mắt, và đối với các cô gái thì điều này càng quan trọng, nó giúp bạn tự tin hơn, không bị lạc lối trong thế giới tinh thần.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一定要旅行，尤其是女孩子。一个女孩子见识很重要，你见得多了自然就会心胸豁达，饰演宽广，会影响到自己对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它让你更有信心，不会在精神世界里迷失方向'),
  1,
  ARRAY['人','一定要','女孩子','一个','见识','很','你','见得','多','了','会心','会','影响','对','很多','的','看法','见多识广','来说','有信心','不会','在','里']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一定要旅行，尤其是女孩子。一个女孩子见识很重要，你见得多了自然就会心胸豁达，饰演宽广，会影响到自己对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它让你更有信心，不会在精神世界里迷失方向'),
  2,
  ARRAY['旅行','就','到','事情','让人','它','让']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一定要旅行，尤其是女孩子。一个女孩子见识很重要，你见得多了自然就会心胸豁达，饰演宽广，会影响到自己对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它让你更有信心，不会在精神世界里迷失方向'),
  3,
  ARRAY['重要','自然','自己','更是','如此','更','世界']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一定要旅行，尤其是女孩子。一个女孩子见识很重要，你见得多了自然就会心胸豁达，饰演宽广，会影响到自己对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它让你更有信心，不会在精神世界里迷失方向'),
  4,
  ARRAY['尤其是','精神','迷失方向']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人一定要旅行，尤其是女孩子。一个女孩子见识很重要，你见得多了自然就会心胸豁达，饰演宽广，会影响到自己对很多事情的看法。旅行让人见多识广，对女孩子来说更是如此，它让你更有信心，不会在精神世界里迷失方向'),
  5,
  ARRAY['胸','豁达','饰演','宽广']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想',
  'qǐng xiāng xìn ， nà xiē tōu tōu liū zǒu de shí guāng ， cuī lǎo le wǒ men de róng yán ， què fēng yíng le wǒ men de rén shēng 。 qǐng xiāng xìn ， qīng chūn de kě guì bìng bú shì yīn wèi nà xiē nián qīng shí guāng ， ér shì nà kē yíng mǎn le yǒng gǎn hé rè qíng de xīn ， bú pà shòu shāng ， bú pà fù chū ， bú pà qù ài ， bú pà qù mèng xiǎng',
  'Hãy tin rằng, những năm tháng trôi qua âm thầm đã làm già đi nhan sắc của chúng ta, nhưng lại làm phong phú thêm cuộc đời. Hãy tin rằng, điều quý giá của tuổi trẻ không phải là những thời khắc trẻ trung, mà là trái tim tràn đầy lòng dũng cảm và nhiệt huyết, không sợ bị tổn thương, không sợ hy sinh, không sợ yêu thương, không sợ mơ ước.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想'),
  1,
  ARRAY['请','那些','的','时光','老了','我们的','了','人生','年轻时','那','和','热情的','不怕','去','爱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想'),
  2,
  ARRAY['可贵','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想'),
  3,
  ARRAY['相信','容颜','而是','心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想'),
  4,
  ARRAY['却','丰盈','并不是','光','勇敢','受伤','付出','梦想']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想'),
  5,
  ARRAY['偷偷','催','青春的','颗']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '请相信，那些偷偷溜走的时光，催老了我们的容颜，却丰盈了我们的人生。请相信，青春的可贵并不是因为那些年轻时光，而是那颗盈满了勇敢和热情的心，不怕受伤，不怕付出，不怕去爱，不怕去梦想'),
  6,
  ARRAY['溜走','盈满']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点',
  'xué huì ràng zì jǐ ān jìng ， bǎ sī wéi chén jìn xià lái ， jiàn jiàn jiǎn shǎo duì shì wù de yù wàng ； xué huì ràng zì wǒ cháng cháng guī líng ， bǎ měi yì tiān dōu dàng zuò shì xīn de qǐ diǎn',
  'Hãy học cách giữ bình tĩnh, để tâm trí lắng đọng, và dần dần giảm bớt ham muốn đối với mọi thứ; học cách thường xuyên đưa bản thân về điểm xuất phát, coi mỗi ngày là một khởi đầu mới.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点'),
  1,
  ARRAY['学会','下来','对','的','都','是','起点']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点'),
  2,
  ARRAY['让','思维','事物','常常','零','每一天','新的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点'),
  3,
  ARRAY['自己','安静','把','自我','当作']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点'),
  4,
  ARRAY['减少']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点'),
  5,
  ARRAY['沉浸','渐渐','归']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会让自己安静，把思维沉浸下来，渐渐减少对事物的欲望；学会让自我常常归零，把每一天都当作是新的起点'),
  6,
  ARRAY['欲望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人',
  'xué huì dī diào ， qǔ shě jiān ， bì yǒu dé shī 。 zuò zì jǐ de jué dìng ， rán hòu zhǔn bèi hǎo chéng dān hòu guǒ 。 shèn yán ， dú lì ， xué huì tuǒ xié de tóng shí ， yě yào jiān chí zì jǐ de dǐ xiàn 。 míng bái fù chū bìng bù yí dìng yǒu jié guǒ 。 guò qù de shì qíng kě yǐ bú wàng jì ， dàn yí dìng yào fàng xià 。 yào kuài lè ， yào jiān rèn ， yào wēn nuǎn ， jǐ yǔ zhēn chéng 。 yuàn wǒ zuò dào zhè yí qiè ， zhī wèi jiǔ děng de rén',
  'Hãy học cách sống khiêm tốn, trong việc lựa chọn sẽ luôn có được và mất. Tự mình đưa ra quyết định, và sẵn sàng gánh chịu hậu quả. Cẩn trọng trong lời nói, độc lập, học cách thỏa hiệp nhưng vẫn kiên định với những nguyên tắc của mình. Hiểu rằng cho đi chưa chắc đã có kết quả. Quá khứ có thể không quên, nhưng nhất định phải buông bỏ. Hãy vui vẻ, kiên cường, ấm áp, và chân thành. Mong rằng tôi có thể làm được tất cả những điều này, chỉ để chờ đợi người đã đợi lâu.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人'),
  1,
  ARRAY['学会','有','做自己','的','同时','明白','一定','不忘','一定要','我','做到','这','一切','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人'),
  2,
  ARRAY['间','得失','然后','准备好','也','要','过去的事','情','可以','但','快乐','给予','真诚','为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人'),
  3,
  ARRAY['必','决定','自己的','结果','记','放下','愿','只','久等']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人'),
  4,
  ARRAY['低调','取舍','坚持','底线','付出','并不','坚韧','温暖']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人'),
  5,
  ARRAY['承担后果','慎言','独立']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '学会低调，取舍间，必有得失。做自己的决定，然后准备好承担后果。慎言，独立，学会妥协的同时，也要坚持自己的底线。明白付出并不一定有结果。过去的事情可以不忘记，但一定要放下。要快乐，要坚韧，要温暖，给予真诚。愿我做到这一切，只为久等的人'),
  6,
  ARRAY['妥协']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生，不过一杯茶，满也好，小也好，挣个什么。浓也好，淡也好，自有味道。急也好，缓也好，那要如何？暖要好，冷也好，相视一笑。人生，因为在乎，所以痛苦。因为怀疑，所以伤害。因为看清，所以坏乐。因为看淡，所以幸福',
  'rén shēng ， bú guò yì bēi chá ， mǎn yě hǎo ， xiǎo yě hǎo ， zhèng gè shén me 。 nóng yě hǎo ， dàn yě hǎo ， zì yǒu wèi dào 。 jí yě hǎo ， huǎn yě hǎo ， nà yào rú hé ？ nuǎn yào hǎo ， lěng yě hǎo ， xiāng shì yí xiào 。 rén shēng ， yīn wèi zài hū ， suǒ yǐ tòng kǔ 。 yīn wèi huái yí ， suǒ yǐ shāng hài 。 yīn wèi kàn qīng ， suǒ yǐ huài lè 。 yīn wèi kàn dàn ， suǒ yǐ xìng fú',
  'Cuộc sống, chẳng qua cũng chỉ như một tách trà, đầy hay vơi, có gì phải tranh giành? Đậm hay nhạt, tự nó có hương vị riêng. Nhanh hay chậm, thì đã sao? Ấm hay lạnh, chỉ cần nhìn nhau mỉm cười. Cuộc sống, vì để tâm nên đau khổ. Vì nghi ngờ nên bị tổn thương. Vì nhìn thấu nên vui vẻ. Vì xem nhẹ nên hạnh phúc.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生，不过一杯茶，满也好，小也好，挣个什么。浓也好，淡也好，自有味道。急也好，缓也好，那要如何？暖要好，冷也好，相视一笑。人生，因为在乎，所以痛苦。因为怀疑，所以伤害。因为看清，所以坏乐。因为看淡，所以幸福'),
  1,
  ARRAY['人生','不过','一杯茶','小','个','什么','那','冷','一','在乎','看清','看淡']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生，不过一杯茶，满也好，小也好，挣个什么。浓也好，淡也好，自有味道。急也好，缓也好，那要如何？暖要好，冷也好，相视一笑。人生，因为在乎，所以痛苦。因为怀疑，所以伤害。因为看清，所以坏乐。因为看淡，所以幸福'),
  2,
  ARRAY['也好','要','要好','笑','因为','所以','乐']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生，不过一杯茶，满也好，小也好，挣个什么。浓也好，淡也好，自有味道。急也好，缓也好，那要如何？暖要好，冷也好，相视一笑。人生，因为在乎，所以痛苦。因为怀疑，所以伤害。因为看清，所以坏乐。因为看淡，所以幸福'),
  3,
  ARRAY['满','自有','急','如何','相视','坏']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生，不过一杯茶，满也好，小也好，挣个什么。浓也好，淡也好，自有味道。急也好，缓也好，那要如何？暖要好，冷也好，相视一笑。人生，因为在乎，所以痛苦。因为怀疑，所以伤害。因为看清，所以坏乐。因为看淡，所以幸福'),
  4,
  ARRAY['味道','暖','怀疑','伤害','幸福']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生，不过一杯茶，满也好，小也好，挣个什么。浓也好，淡也好，自有味道。急也好，缓也好，那要如何？暖要好，冷也好，相视一笑。人生，因为在乎，所以痛苦。因为怀疑，所以伤害。因为看清，所以坏乐。因为看淡，所以幸福'),
  5,
  ARRAY['挣','浓','淡','缓','痛苦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明',
  'shī bài hòu ， bié máng zhe zhǎo lǐ yóu ， jiù suàn zhǎo chū qiān wàn gè ， yě yú shì wú bǔ ； kùn nán qián ， xiān shì zhuó xiǎng bàn fǎ ， nǎ pà zhī zhǎo dào yí gè ， jiù néng jiě jué wèn tí 。 zài jué wàng de chǔ jìng ， zhǐ yào nǐ bù huī xīn ， bú sàng qì ， bù shī dǎn ， shī zhì bù yí dì qián xíng ， nǐ zǒng huì yíng lái guāng míng',
  'Sau khi thất bại, đừng vội tìm lý do, dù có tìm ra hàng ngàn lý do cũng chẳng ích gì; trước khó khăn, hãy thử tìm cách giải quyết, dù chỉ tìm được một cách, thì cũng đủ để giải quyết vấn đề. Trong hoàn cảnh tuyệt vọng đến đâu, chỉ cần bạn không nản lòng, không mất tinh thần, không chùn bước, kiên định tiến về phía trước, bạn sẽ luôn tìm thấy ánh sáng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明'),
  1,
  ARRAY['后','个','前','先试','哪怕','一个','能解决问题','再','你','不','不移','前行']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明'),
  2,
  ARRAY['别忙','着','找','就算','找出','千万','也','着想','找到','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明'),
  3,
  ARRAY['理由','于事无补','办法','只','只要','地','总会','迎来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明'),
  4,
  ARRAY['失败','困难','绝望的','处境','失','志','光明']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明'),
  5,
  ARRAY['灰心','胆']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '失败后，别忙着找理由，就算找出千万个，也于事无补；困难前，先试着想办法，哪怕只找到一个，就能解决问题。再绝望的处境，只要你不灰心，不丧气，不失胆，失志不移地前行，你总会迎来光明'),
  6,
  ARRAY['丧气']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方',
  'wèi le zì jǐ xiǎng guò de shēng huó ， yǒng yú fàng qì yì xiē dōng xī 。 zhè ge shì jiè méi yǒu gōng zhèng zhī chù ， nǐ yě yǒng yuǎn dé bú dào liǎng quán zhī jì 。 ruò yào zì yóu ， yào dé xī shēng ān quán 。 ruò yào xián sǎn ， jiù bù néng huò dé bié rén píng jià zhōng de chéng jiù 。 ruò yào yú yuè ， jiù wú xū jì jiào shēn biān rén jǐ yǔ de tài dù 。 ruò yào qián xíng ， jiù dé lí kāi nǐ xiàn zài tíng liú de dì fāng',
  'Để sống cuộc sống mà mình mong muốn, hãy dũng cảm từ bỏ một số thứ. Thế giới này không có sự công bằng tuyệt đối, và bạn cũng sẽ không bao giờ có được mọi thứ. Nếu muốn tự do, bạn phải hy sinh sự an toàn. Nếu muốn nhàn hạ, bạn không thể đạt được thành tựu mà người khác đánh giá cao. Nếu muốn vui vẻ, đừng quá để tâm đến thái độ của người xung quanh. Nếu muốn tiến lên, bạn phải rời khỏi nơi bạn đang dừng chân.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方'),
  1,
  ARRAY['想','的','生活','一些','东西','这个','没有','你','不能','中的','人','前行','现在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方'),
  2,
  ARRAY['为了自己','过','公正','也','得不到','两全','要得','就','别人','身边','给予','就得','离开']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方'),
  3,
  ARRAY['放弃','世界','自由','安全','成就','地方']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方'),
  4,
  ARRAY['勇于','之处','永远','之','计','获得','评价','愉悦','无须','计较','态度','停留']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方'),
  5,
  ARRAY['闲散']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '为了自己想过的生活，勇于放弃一些东西。这个世界没有公正之处，你也永远得不到两全之计。若要自由，要得牺牲安全。若要闲散，就不能获得别人评价中的成就。若要愉悦，就无须计较身边人给予的态度。若要前行，就得离开你现在停留的地方'),
  6,
  ARRAY['若要','牺牲']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '一个人20岁出头的时候，除了仅剩不多的青春以外什么都没有，但是你手头为数不多的青春却能决定你变成一个什么样的人',
  'yí gè rén 2 0 suì chū tóu de shí hòu ， chú le jǐn shèng bù duō de qīng chūn yǐ wài shén me dōu méi yǒu ， dàn shì nǐ shǒu tóu wéi shù bù duō de qīng chūn què néng jué dìng nǐ biàn chéng yí gè shén me yàng de rén',
  'Khi một người mới ngoài 20 tuổi, ngoài tuổi trẻ chẳng còn nhiều thì chẳng có gì cả, nhưng khoảng thời gian tuổi trẻ ít ỏi đó lại có thể quyết định bạn sẽ trở thành người như thế nào.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人20岁出头的时候，除了仅剩不多的青春以外什么都没有，但是你手头为数不多的青春却能决定你变成一个什么样的人'),
  1,
  ARRAY['一个人','岁','出头','的','时候','不多的','什么','都','没有','你','能','一个','什么样','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人20岁出头的时候，除了仅剩不多的青春以外什么都没有，但是你手头为数不多的青春却能决定你变成一个什么样的人'),
  2,
  ARRAY['以外','但是','手头','为数不多']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人20岁出头的时候，除了仅剩不多的青春以外什么都没有，但是你手头为数不多的青春却能决定你变成一个什么样的人'),
  3,
  ARRAY['除了','决定','变成']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人20岁出头的时候，除了仅剩不多的青春以外什么都没有，但是你手头为数不多的青春却能决定你变成一个什么样的人'),
  4,
  ARRAY['仅','剩','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人20岁出头的时候，除了仅剩不多的青春以外什么都没有，但是你手头为数不多的青春却能决定你变成一个什么样的人'),
  5,
  ARRAY['青春']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人',
  'bú yào máng mù chóng bài hé xiāng xìn bù xiāng gān de rén gào sù nǐ de huà 。 dōu bú shì gé yán 。 tā rén gào sù nǐ de zhī dài biǎo tā rén gǎn shòu bú dài biǎo nǐ de gǎn shòu 。 shì jiān rèn hé shì zì jǐ xiǎng tōng hěn zhòng yào 。 shuí dōu bú shì shuí de xīn lǐ zhuān jiā ， zì jǐ cái shì zuì hǎo de jiě líng rén',
  'Đừng mù quáng tôn thờ và tin tưởng những gì người không liên quan nói với bạn. Những điều đó không phải là chân lý. Những gì người khác nói với bạn chỉ đại diện cho cảm nhận của họ, không phải cảm nhận của bạn. Trong cuộc sống, việc tự mình hiểu ra vấn đề là rất quan trọng. Không ai là chuyên gia tâm lý của ai, chính mình mới là người giải quyết vấn đề tốt nhất.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人'),
  1,
  ARRAY['不要','和','不相干','的','人','你的','话','都','不是','他人','不','是','想通','很','谁','谁的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人'),
  2,
  ARRAY['告诉','最好的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人'),
  3,
  ARRAY['相信','只','感受','世间','自己','重要','心理','才是','解铃']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人'),
  4,
  ARRAY['格言','任何','专家']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人'),
  5,
  ARRAY['代表']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要盲目崇拜和相信不相干的人告诉你的话。都不是格言。他人告诉你的只代表他人感受不代表你的感受。世间任何是自己想通很重要。谁都不是谁的心理专家，自己才是最好的解铃人'),
  6,
  ARRAY['盲目','崇拜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生活越来越像是黑色幽默，不让你懂的时候里偏想懂，等到你懂的时候却又想什么都不懂',
  'shēng huó yuè lái yuè xiàng shì hēi sè yōu mò ， bú ràng nǐ dǒng de shí hòu lǐ piān xiǎng dǒng ， děng dào nǐ dǒng de shí hòu què yòu xiǎng shén me dōu bù dǒng',
  'Cuộc sống ngày càng giống như một trò đùa đen tối, khi không cho bạn hiểu thì bạn lại cố gắng hiểu, nhưng khi bạn đã hiểu rồi thì lại muốn không biết gì cả.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活越来越像是黑色幽默，不让你懂的时候里偏想懂，等到你懂的时候却又想什么都不懂'),
  1,
  ARRAY['生活','是','不','你懂的','时候','里','想','什么','都','不懂']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活越来越像是黑色幽默，不让你懂的时候里偏想懂，等到你懂的时候却又想什么都不懂'),
  2,
  ARRAY['黑色','让','懂','等到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活越来越像是黑色幽默，不让你懂的时候里偏想懂，等到你懂的时候却又想什么都不懂'),
  3,
  ARRAY['越来越','像']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活越来越像是黑色幽默，不让你懂的时候里偏想懂，等到你懂的时候却又想什么都不懂'),
  4,
  ARRAY['幽默','却又']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活越来越像是黑色幽默，不让你懂的时候里偏想懂，等到你懂的时候却又想什么都不懂'),
  6,
  ARRAY['偏']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '既然选择了一条路，就不要惦记着另一条路的风景',
  'jì rán xuǎn zé le yì tiáo lù ， jiù bú yào diàn jì zhe lìng yì tiáo lù de fēng jǐng',
  'Một khi đã chọn một con đường, đừng mơ mộng về phong cảnh của con đường khác.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '既然选择了一条路，就不要惦记着另一条路的风景'),
  1,
  ARRAY['了','一条','不要','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '既然选择了一条路，就不要惦记着另一条路的风景'),
  2,
  ARRAY['路','就','条']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '既然选择了一条路，就不要惦记着另一条路的风景'),
  3,
  ARRAY['选择','风景']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '既然选择了一条路，就不要惦记着另一条路的风景'),
  4,
  ARRAY['既然','另一']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '既然选择了一条路，就不要惦记着另一条路的风景'),
  6,
  ARRAY['惦记着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞',
  'dāng nǐ kě wàng zhǎo gè rén tán yi tán de shí hòu ， nǐ men zhè méi yǒu tán shén me 。 yú shì ， nǐ lǐng wù dào ， yǒu xiē shì qíng shì bù néng gào sù bié rén de ， yǒu xiē shì qíng shì bú bì gào sù bié rén de 。 nà zuì hǎo de bàn fǎ jiù shì jìng xià lái ， kěn shì zì jǐ de jì mò',
  'Khi bạn khao khát tìm ai đó để trò chuyện, nhưng lại chẳng nói gì cả. Lúc đó, bạn nhận ra rằng có những điều không thể chia sẻ với người khác, và có những điều không cần phải nói ra. Cách tốt nhất là bình tĩnh lại, đối mặt với nỗi cô đơn của chính mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞'),
  1,
  ARRAY['你','个人','的','时候','你们','这','没有','什么','有些','是','不能','不必','那']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞'),
  2,
  ARRAY['找','到','事情','告诉','别人','最好的','就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞'),
  3,
  ARRAY['当','渴望','于是','办法','静下来','自己的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞'),
  4,
  ARRAY['谈一','谈']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞'),
  5,
  ARRAY['领悟','寂寞']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你渴望找个人谈一谈的时候，你们这没有谈什么。于是，你领悟到，有些事情是不能告诉别人的，有些事情是不必告诉别人的。那最好的办法就是静下来，啃噬自己的寂寞'),
  6,
  ARRAY['啃噬']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现',
  'liú nián niàn niàn bù yǔ ， què ràng rén kǒu kǒu xiāng chuán ； guāng yīn mò mò bù wén ， què zhī xiǎo shì tài yán liáng 。 xǔ duō nián ， huò xǔ zài cháo qǐ cháo luò lǐ ， wǒ men yī zhe suì yuè de shēn qíng ， yán xù zhe chái mǐ yóu yán de yān huǒ ， ràng yì huā yì chá de rì zi ， bān bó le suì yuè de guāng yùn ， zhě zhòu le fú shì de xīn xiāng ， suǒ yǒu de měi hǎo ， cái cóng cǐ zài shēng huó lǐ xiǎn xiàn',
  'Thời gian trôi qua âm thầm không nói, nhưng lại khiến người ta truyền tai nhau; năm tháng lặng lẽ không nghe, nhưng thấu hiểu sự lạnh nhạt của cuộc đời. Qua bao năm, có lẽ giữa những thăng trầm, chúng ta dựa vào tình cảm sâu sắc của thời gian, tiếp tục cuộc sống đời thường với những bữa cơm giản dị, để từng khoảnh khắc với một bông hoa, một tách trà làm phai nhạt ánh sáng của năm tháng, tạo nên hương thơm của thế gian, và tất cả những điều tốt đẹp ấy từ đó hiện lên trong cuộc sống.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现'),
  1,
  ARRAY['不','语','在','里','我们','岁月','的','一','茶','了','生活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现'),
  2,
  ARRAY['让人','知晓','着','让','日子','所有的','从此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现'),
  3,
  ARRAY['口口相传','闻','世态炎凉','或许','花','馨香','才']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现'),
  4,
  ARRAY['流年','却','光阴','默默','许多年','深情','烟火','光晕','美好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现'),
  5,
  ARRAY['念念','潮起潮落','依','延续','柴米油盐','显现']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '流年念念不语，却让人口口相传；光阴默默不闻，却知晓世态炎凉。许多年，或许在潮起潮落里，我们依着岁月的深情，延续着柴米油盐的烟火，让一花一茶的日子，斑驳了岁月的光晕，褶皱了浮世的馨香，所有的美好，才从此在生活里显现'),
  6,
  ARRAY['斑驳','褶皱','浮世']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的',
  'bié tài shàn liáng le ， bié tài dà fāng le ， yě bié tài néng gàn le ， shí jiān jiǔ le rén jiā huì jué dé ， nǐ zuò de yí qiè dōu shì yīng gāi de 。 jí shǐ yǒu yì tiān nǐ chēng bú zhù ， kū le lèi le ， yě méi rén xīn téng nǐ 。 yīn wèi zài tā men yǎn lǐ zhè dōu shì nǐ yuàn yì de',
  'Đừng quá tử tế, đừng quá hào phóng, và cũng đừng quá giỏi giang, vì lâu dần người ta sẽ nghĩ rằng những gì bạn làm là điều hiển nhiên. Ngay cả khi một ngày bạn không chịu nổi nữa, khóc lóc mệt mỏi, cũng chẳng ai thương xót bạn. Bởi trong mắt họ, đó đều là những điều bạn tự nguyện làm.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的'),
  1,
  ARRAY['太','了','太大','能干','时间','人家','会','觉得','你','做','的','一切都','是','有一天','没人','在','他们','这','都是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的'),
  2,
  ARRAY['别','也','累了','因为','眼里']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的'),
  3,
  ARRAY['方','久','应该','哭','心疼','愿意的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的'),
  4,
  ARRAY['即使']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的'),
  5,
  ARRAY['善良']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '别太善良了，别太大方了，也别太能干了，时间久了人家会觉得，你做的一切都是应该的。即使有一天你撑不住，哭了累了，也没人心疼你。因为在他们眼里这都是你愿意的'),
  6,
  ARRAY['撑不住']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了',
  'rén shēng jiù shì yí gè chōng mǎn yí hàn de guò chéng 。 yǒu xiē shì ， tǐng yi tǐng ， jiù guò qù le ； yǒu xiē rén ， hěn yi hěn ， yě jiù wàng jì le ； yǒu xiē kǔ ， xiào yi xiào ， jiù bīng shì le ； yǒu kē xīn ， shāng yi shāng ， nà me yě jiù shì jiān qiáng le',
  'Cuộc đời là một hành trình đầy những tiếc nuối. Có những việc, cố gắng chịu đựng một chút là sẽ qua đi; có những người, mạnh mẽ quên đi một chút là sẽ không còn nhớ; có những nỗi đau, mỉm cười một cái là sẽ tan biến; và có những trái tim, dù bị tổn thương nhưng chính điều đó lại khiến chúng mạnh mẽ hơn.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了'),
  1,
  ARRAY['人生','一个','有些','一','了','有些人','有','那么']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了'),
  2,
  ARRAY['就是','过程','事','就','过去','也','笑一笑','也就是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了'),
  3,
  ARRAY['忘记了','冰释','心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了'),
  4,
  ARRAY['挺','苦','伤','坚强']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了'),
  5,
  ARRAY['充满','遗憾的','颗']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就是一个充满遗憾的过程。有些事，挺一挺，就过去了；有些人，狠一狠，也就忘记了；有些苦，笑一笑，就冰释了；有颗心，伤一伤，那么也就是坚强了'),
  6,
  ARRAY['狠']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的',
  'céng jīng dǔ dìng shì zhèng què de dōng xī ， qí shí wèi bì shì duì de ； yǐ wéi tè bié zhòng yào de shì qíng ， yě méi yǒu xiǎng xiàng zhōng nà yàng zhòng yào ； zhēn xīn duì yí gè rén ， kě néng tā men bìng bú zài yì nǐ de hǎo 。 rén shēng duō shì shì yǔ yuàn wéi ， bú yào suí biàn duì shuí jiù tāo xīn tāo fèi ， yě bú yòng tài gù zhí ， méi yǒu shén me shì bú huì gǎi biàn de',
  'Những điều mà trước đây bạn tin chắc là đúng, thực ra chưa chắc đã đúng; những việc mà bạn nghĩ là vô cùng quan trọng, cũng không quan trọng như bạn tưởng; bạn chân thành với một người, nhưng có thể họ không hề quan tâm đến điều tốt đẹp của bạn. Cuộc sống thường không như mong muốn, đừng dễ dàng mở lòng với bất kỳ ai, cũng đừng quá cố chấp, vì không có gì là không thể thay đổi.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的'),
  1,
  ARRAY['是','东西','对的','想象','中','那样','对','一个人','他们','在意','你的','好','人生','多','不要','谁','太','没有','什么是','不会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的'),
  2,
  ARRAY['正确的','以为','情','也没有','真心','可能','事与愿违','就','也不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的'),
  3,
  ARRAY['笃定','其实','特别','重要的事','重要','用']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的'),
  4,
  ARRAY['并不','随便','改变的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的'),
  5,
  ARRAY['曾经','未必','固执']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '曾经笃定是正确的东西，其实未必是对的；以为特别重要的事情，也没有想象中那样重要；真心对一个人，可能他们并不在意你的好。人生多是事与愿违，不要随便对谁就掏心掏肺，也不用太固执，没有什么是不会改变的'),
  6,
  ARRAY['掏心掏肺']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西',
  'měi tiān wǔ gè xiǎo shí ， rú guǒ nǐ shì yòng lái kàn hán jù ， liú lǎn wǎng yè ， liáo tiān ， qī nián hòu ， nǐ huì biàn chéng shēng huó de páng guān zhě ， nǐ zuì shàn cháng de jiù shì " rú shǔ jiā zhēn " dì shuō qǐ bié rén de chéng gōng hé shī bài ， què zài zì jǐ shēn shàng zhǎo bú dào rèn hé kě shuō de dōng xī',
  'Mỗi ngày dành năm tiếng đồng hồ, nếu bạn dùng để xem phim Hàn Quốc, lướt web, hoặc trò chuyện, thì bảy năm sau, bạn sẽ trở thành một khán giả của cuộc sống. Điều bạn giỏi nhất là kể vanh vách về thành công và thất bại của người khác, nhưng lại chẳng có gì đáng nói về chính mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  1,
  ARRAY['五','个','小时','你','是','看','七','年','后','会','生活的','说起','的','和','在','说','东西']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  2,
  ARRAY['每天','旁观者','最','就是','别人','身上','找不到','可']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  3,
  ARRAY['如果','用来','网页','聊天','变成','如数家珍','地','成功','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  4,
  ARRAY['剧','失败','却','任何']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  5,
  ARRAY['浏览']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  6,
  ARRAY['擅长的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每天五个小时，如果你是用来看韩剧，浏览网页，聊天，七年后，你会变成生活的旁观者，你最擅长的就是"如数家珍"地说起别人的成功和失败，却在自己身上找不到任何可说的东西'),
  ARRAY['韩']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '放纵自己的欲望是最大的祸害，谈论别人的隐私是最大的罪恶，不知自己过失是最大的病痛',
  'fàng zòng zì jǐ de yù wàng shì zuì dà de huò hài ， tán lùn bié rén de yǐn sī shì zuì dà de zuì è ， bù zhī zì jǐ guò shī shì zuì dà de bìng tòng',
  'Phóng túng dục vọng của bản thân là tai họa lớn nhất, bàn tán về đời tư của người khác là tội lỗi lớn nhất, và không nhận ra lỗi lầm của chính mình là nỗi đau lớn nhất.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '放纵自己的欲望是最大的祸害，谈论别人的隐私是最大的罪恶，不知自己过失是最大的病痛'),
  1,
  ARRAY['的','是','不知']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '放纵自己的欲望是最大的祸害，谈论别人的隐私是最大的罪恶，不知自己过失是最大的病痛'),
  2,
  ARRAY['最大的','别人','过失','病痛']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '放纵自己的欲望是最大的祸害，谈论别人的隐私是最大的罪恶，不知自己过失是最大的病痛'),
  3,
  ARRAY['放纵自己','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '放纵自己的欲望是最大的祸害，谈论别人的隐私是最大的罪恶，不知自己过失是最大的病痛'),
  4,
  ARRAY['谈论']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '放纵自己的欲望是最大的祸害，谈论别人的隐私是最大的罪恶，不知自己过失是最大的病痛'),
  6,
  ARRAY['欲望','祸害','隐私','罪恶']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生最困难的不是努力，也不是奋斗，而是做出正确的抉择。别放弃，一步一步走下去，别让机会从眼前溜走',
  'rén shēng zuì kùn nán de bú shì nǔ lì ， yě bú shì fèn dòu ， ér shì zuò chū zhèng què de jué zé 。 bié fàng qì ， yí bù yi bù zǒu xià qù ， bié ràng jī huì cóng yǎn qián liū zǒu',
  'Điều khó khăn nhất trong cuộc đời không phải là nỗ lực, cũng không phải là phấn đấu, mà là đưa ra quyết định đúng đắn. Đừng bỏ cuộc, cứ từng bước tiến lên, đừng để cơ hội trôi qua trước mắt.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最困难的不是努力，也不是奋斗，而是做出正确的抉择。别放弃，一步一步走下去，别让机会从眼前溜走'),
  1,
  ARRAY['人生','不是','是','做出','一步','去','机会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最困难的不是努力，也不是奋斗，而是做出正确的抉择。别放弃，一步一步走下去，别让机会从眼前溜走'),
  2,
  ARRAY['最','也不','正确的','别','走下','别让','从','眼前']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最困难的不是努力，也不是奋斗，而是做出正确的抉择。别放弃，一步一步走下去，别让机会从眼前溜走'),
  3,
  ARRAY['努力','而是','抉择','放弃']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最困难的不是努力，也不是奋斗，而是做出正确的抉择。别放弃，一步一步走下去，别让机会从眼前溜走'),
  4,
  ARRAY['困难的','奋斗']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生最困难的不是努力，也不是奋斗，而是做出正确的抉择。别放弃，一步一步走下去，别让机会从眼前溜走'),
  6,
  ARRAY['溜走']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '自己永远是自己的主角，不要总在别人的戏剧里充当着配角',
  'zì jǐ yǒng yuǎn shì zì jǐ de zhǔ jué ， bú yào zǒng zài bié rén de xì jù lǐ chōng dāng zhe pèi jué',
  'Mình luôn là nhân vật chính của cuộc đời mình, đừng mãi đóng vai phụ trong vở kịch của người khác.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己永远是自己的主角，不要总在别人的戏剧里充当着配角'),
  1,
  ARRAY['是','不要','在','的','里']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己永远是自己的主角，不要总在别人的戏剧里充当着配角'),
  2,
  ARRAY['别人','着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己永远是自己的主角，不要总在别人的戏剧里充当着配角'),
  3,
  ARRAY['自己','自己的','主角','总','戏剧']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己永远是自己的主角，不要总在别人的戏剧里充当着配角'),
  4,
  ARRAY['永远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己永远是自己的主角，不要总在别人的戏剧里充当着配角'),
  5,
  ARRAY['充当','配角']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生浮常，原来缘去自有它的定数，又何必苦苦纠缠忘不掉的过去，释怀不了的人。其实很多时候，我们一个转弯，便会忘了来时的路',
  'rén shēng fú cháng ， yuán lái yuán qù zì yǒu tā de dìng shù ， yòu hé bì kǔ kǔ jiū chán wàng bú diào de guò qù ， shì huái bù liǎo de rén 。 qí shí hěn duō shí hòu ， wǒ men yí gè zhuǎn wān ， biàn huì wàng le lái shí de lù',
  'Cuộc đời vô thường, duyên đến rồi đi đều có số phận của nó, vậy tại sao phải mãi đau đáu về quá khứ không thể quên, hay những người không thể buông bỏ? Thực ra, đôi khi chỉ cần một bước ngoặt, chúng ta sẽ quên mất con đường mình đã đi qua.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生浮常，原来缘去自有它的定数，又何必苦苦纠缠忘不掉的过去，释怀不了的人。其实很多时候，我们一个转弯，便会忘了来时的路'),
  1,
  ARRAY['人生','去','不','的','不了','人','很多','时候','我们','一个','会','来时']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生浮常，原来缘去自有它的定数，又何必苦苦纠缠忘不掉的过去，释怀不了的人。其实很多时候，我们一个转弯，便会忘了来时的路'),
  2,
  ARRAY['常','它的','过去','便','路']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生浮常，原来缘去自有它的定数，又何必苦苦纠缠忘不掉的过去，释怀不了的人。其实很多时候，我们一个转弯，便会忘了来时的路'),
  3,
  ARRAY['自有','定数','又','忘','其实','忘了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生浮常，原来缘去自有它的定数，又何必苦苦纠缠忘不掉的过去，释怀不了的人。其实很多时候，我们一个转弯，便会忘了来时的路'),
  4,
  ARRAY['原来','何必','苦苦','掉','释怀','转弯']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生浮常，原来缘去自有它的定数，又何必苦苦纠缠忘不掉的过去，释怀不了的人。其实很多时候，我们一个转弯，便会忘了来时的路'),
  6,
  ARRAY['浮','缘','纠缠']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负',
  'yǒu shí hòu rén jiù shì zhè yàng ， yù dào zài dà de shì zì jǐ rěn rěn jiù guò qù le ， tīng dào shēn páng de rén yí jù ān wèi jiù shùn jiān wán bài 。 hòu lái cái míng bái ， pà de bú shì lěng mò ， pà de shì tū rán de wēn róu ； pà de bú shì zì jǐ chī kǔ ， pà de shì shēn biān de rén wéi nǐ nán guò ； pà de bú shì gū dú ， pà de shì gū fù',
  'Đôi khi con người là như vậy, dù gặp chuyện lớn đến đâu, tự mình chịu đựng một chút rồi cũng qua. Nhưng chỉ cần nghe một lời an ủi từ người bên cạnh, tâm trạng bỗng vỡ òa. Sau này mới hiểu, điều đáng sợ không phải là sự lạnh lùng, mà là sự dịu dàng bất ngờ; không phải sợ bản thân chịu khổ, mà là sợ người bên cạnh vì mình mà đau lòng; không phải sợ cô đơn, mà là sợ làm người khác thất vọng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负'),
  1,
  ARRAY['有时候','人','这样','再','大的','了','听到','的','一句','后来','明白','不是','冷漠','的是','吃苦','人为','你']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负'),
  2,
  ARRAY['就是','事','就','过去','身旁','完','身边']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负'),
  3,
  ARRAY['遇到','自己','安慰','才','怕','突然的','难过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负'),
  4,
  ARRAY['败','温柔']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负'),
  5,
  ARRAY['忍忍']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候人就是这样，遇到再大的事自己忍忍就过去了，听到身旁的人一句安慰就瞬间完败。后来才明白，怕的不是冷漠，怕的是突然的温柔；怕的不是自己吃苦，怕的是身边的人为你难过；怕的不是孤独，怕的是辜负'),
  6,
  ARRAY['瞬间','孤独','辜负']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景',
  'pí juàn le ， xīn lèi le ， jiù yí gè rén jìng jìng tǎng zhe ， yòng chén mò dài tì yí qiè ， bù tí ， bú wèn 。 nán guò le ， xīn tòng le ， jiù yí gè rén bù tíng dì zǒu ， yòng chén mò dài tì yí qiè ， bù kū ， bǔ xiào 。 rén shēng de měi tiáo lù dōu hěn nán zǒu ， zhù dìng yào jīng lì yì xiē kǎn kě ， bù kě yǐ qiǎng qiú rèn hé rén lái péi kàn zì jǐ de fēng jǐng',
  'Khi mệt mỏi, khi trái tim kiệt sức, hãy nằm yên một mình, dùng sự im lặng thay cho mọi thứ, không nhắc đến, không hỏi han. Khi buồn bã, khi đau lòng, hãy cứ đi không ngừng, dùng sự im lặng thay cho tất cả, không khóc, không cười. Mỗi con đường trong cuộc đời đều khó đi, chắc chắn sẽ phải trải qua những gập ghềnh, không thể ép buộc ai đó cùng ngắm nhìn phong cảnh của riêng mình.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景'),
  1,
  ARRAY['一个人','一切','不','不问','了','不停地','人生','的','都','很难','一些','不可以','来','看']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景'),
  2,
  ARRAY['累了','就','走','笑','每','条','路','经历']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景'),
  3,
  ARRAY['心','静静','用','提','难过','心痛','哭','注定要','自己的','风景']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景'),
  4,
  ARRAY['躺着','任何人','陪']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景'),
  5,
  ARRAY['疲倦了','沉默','代替','强求']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '疲倦了，心累了，就一个人静静躺着，用沉默代替一切，不提，不问。难过了，心痛了，就一个人不停地走，用沉默代替一切，不哭，卜笑。人生的每条路都很难走，注定要经历一些坎坷，不可以强求任何人来陪看自己的风景'),
  ARRAY['卜','坎','坷']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '一个人最好的生活状态，是该看书时看书，该玩时尽情玩，看见优秀的人欣赏，看到落魄的人也不轻视，有自己的小生活和小情趣，不用去想改变世界，努力去活出自己。没人爱时专注自己，有人爱时，有能力拥抱彼此',
  'yí gè rén zuì hǎo de shēng huó zhuàng tài ， shì gāi kàn shū shí kàn shū ， gāi wán shí jìn qíng wán ， kàn jiàn yōu xiù de rén xīn shǎng ， kàn dào luò pò de rén yě bù qīng shì ， yǒu zì jǐ de xiǎo shēng huó hé xiǎo qíng qù ， bú yòng qù xiǎng gǎi biàn shì jiè ， nǔ lì qù huó chū zì jǐ 。 méi rén ài shí zhuān zhù zì jǐ ， yǒu rén ài shí ， yǒu néng lì yōng bào bǐ cǐ',
  'Trạng thái sống tốt nhất của một người là đọc sách khi cần, vui chơi hết mình khi có thể, biết trân trọng người xuất sắc và không khinh thường người thất bại. Có cuộc sống nhỏ và sở thích riêng, không cần nghĩ đến việc thay đổi thế giới, chỉ cần cố gắng sống đúng với bản thân. Khi không có ai yêu, hãy tập trung vào chính mình; khi có người yêu, hãy có khả năng ôm lấy nhau.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人最好的生活状态，是该看书时看书，该玩时尽情玩，看见优秀的人欣赏，看到落魄的人也不轻视，有自己的小生活和小情趣，不用去想改变世界，努力去活出自己。没人爱时专注自己，有人爱时，有能力拥抱彼此'),
  1,
  ARRAY['一个人','生活','是','看书','时','看见','人','看到','有','小生','和','小','不用','去','想','出自','没人','爱','有人','有能力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人最好的生活状态，是该看书时看书，该玩时尽情玩，看见优秀的人欣赏，看到落魄的人也不轻视，有自己的小生活和小情趣，不用去想改变世界，努力去活出自己。没人爱时专注自己，有人爱时，有能力拥抱彼此'),
  2,
  ARRAY['最好的','玩','也不','情趣']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人最好的生活状态，是该看书时看书，该玩时尽情玩，看见优秀的人欣赏，看到落魄的人也不轻视，有自己的小生活和小情趣，不用去想改变世界，努力去活出自己。没人爱时专注自己，有人爱时，有能力拥抱彼此'),
  3,
  ARRAY['该','轻视','自己的','世界','努力','己','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人最好的生活状态，是该看书时看书，该玩时尽情玩，看见优秀的人欣赏，看到落魄的人也不轻视，有自己的小生活和小情趣，不用去想改变世界，努力去活出自己。没人爱时专注自己，有人爱时，有能力拥抱彼此'),
  4,
  ARRAY['尽情','优秀的','落魄的人','活','改变','专注']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '一个人最好的生活状态，是该看书时看书，该玩时尽情玩，看见优秀的人欣赏，看到落魄的人也不轻视，有自己的小生活和小情趣，不用去想改变世界，努力去活出自己。没人爱时专注自己，有人爱时，有能力拥抱彼此'),
  5,
  ARRAY['状态','欣赏','拥抱','彼此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主',
  'zài duǎn zàn de rén shēng suì yuè zhōng ，   shuí dōu huì pèng dào shēng lí sǐ bié de jiū xīn shì 。 shāng xīn hé wěi qu de shí hòu ， kě yǐ   kū ， kū wán xǐ bǎ liǎn ， pāi pāi zì jǐ de liǎn ， gěi zì jǐ yí gè wēi xiào ， bú yào róu yǎn jīng ， fǒu zé dì èr tiān zǎo shàng yǎn jīng huì zhǒng 。 hǎo hǎo shēng huó ， nǐ de shēng mìng yóu zì jǐ zuò zhǔ',
  'Trong những năm tháng ngắn ngủi của cuộc đời, ai cũng sẽ gặp phải những chuyện đau lòng như sinh ly tử biệt. Khi buồn bã và tủi thân, có thể khóc, khóc xong rửa mặt, vỗ nhẹ vào mặt mình, và tặng cho mình một nụ cười. Đừng dụi mắt, nếu không sáng hôm sau mắt sẽ sưng. Hãy sống thật tốt, cuộc đời của bạn do chính bạn quyết định.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主'),
  1,
  ARRAY['在','人生','岁月','中','谁','都会','生离死别','的','和','时候','一个','不要','会','好好','生活','你的','生命']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主'),
  2,
  ARRAY['事','可以','完','洗','给','眼睛','第二天','早上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主'),
  3,
  ARRAY['短暂的','揪心','哭','把','脸','自己的','自己','自己做','主']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主'),
  4,
  ARRAY['伤心','微笑','否则','由']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主'),
  5,
  ARRAY['碰到','委屈','拍拍']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在短暂的人生岁月中， 谁都会碰到生离死别的揪心事。伤心和委屈的时候，可以 哭，哭完洗把脸，拍拍自己的脸，给自己一个微笑，不要揉眼睛，否则第二天早上眼睛会肿。好好生活，你的生命由自己做主'),
  6,
  ARRAY['揉','肿']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你羡慕别人月薪几万，却不知道他日日加班到深夜的辛苦。你羡慕别人说走就走到处游玩的自由，却不知道他为这份自由放弃的东西。一切都有代价，无论财富，事业，爱情，还是自由',
  'nǐ xiàn mù bié rén yuè xīn jǐ wàn ， què bù zhī dào tā rì rì jiā bān dào shēn yè de xīn kǔ 。 nǐ xiàn mù bié rén shuō zǒu jiù zǒu dào chù yóu wán de zì yóu ， què bù zhī dào tā wèi zhè fèn zì yóu fàng qì de dōng xī 。 yí qiè dōu yǒu dài jià ， wú lùn cái fù ， shì yè ， ài qíng ， hái shì zì yóu',
  'Bạn ngưỡng mộ người khác có thu nhập hàng tháng lên đến vài chục triệu, nhưng bạn đâu biết họ phải làm việc tăng ca đến tận khuya. Bạn ngưỡng mộ người khác có thể đi du lịch khắp nơi một cách tự do, nhưng bạn đâu biết họ đã phải từ bỏ những gì cho sự tự do đó. Mọi thứ đều có cái giá của nó, dù là tiền bạc, sự nghiệp, tình yêu hay tự do.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人月薪几万，却不知道他日日加班到深夜的辛苦。你羡慕别人说走就走到处游玩的自由，却不知道他为这份自由放弃的东西。一切都有代价，无论财富，事业，爱情，还是自由'),
  1,
  ARRAY['你','月薪','几万','不知道','他日','的','说','的自由','他','这','东西','一切都','有','爱情']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人月薪几万，却不知道他日日加班到深夜的辛苦。你羡慕别人说走就走到处游玩的自由，却不知道他为这份自由放弃的东西。一切都有代价，无论财富，事业，爱情，还是自由'),
  2,
  ARRAY['别人','日','到','走','就','走到','游玩','为','事业','还是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人月薪几万，却不知道他日日加班到深夜的辛苦。你羡慕别人说走就走到处游玩的自由，却不知道他为这份自由放弃的东西。一切都有代价，无论财富，事业，爱情，还是自由'),
  3,
  ARRAY['加班','自由','放弃的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人月薪几万，却不知道他日日加班到深夜的辛苦。你羡慕别人说走就走到处游玩的自由，却不知道他为这份自由放弃的东西。一切都有代价，无论财富，事业，爱情，还是自由'),
  4,
  ARRAY['羡慕','却','深夜','辛苦','处','份','无论']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你羡慕别人月薪几万，却不知道他日日加班到深夜的辛苦。你羡慕别人说走就走到处游玩的自由，却不知道他为这份自由放弃的东西。一切都有代价，无论财富，事业，爱情，还是自由'),
  5,
  ARRAY['代价','财富']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生',
  'rén yǒu yì diǎn nián jì zǒng shì hǎo de ， yuè lái yuè néng tǐ liàng tā rén shēng huó de bú yì ， yě yuè lái yuè néng gòu lǐ jiě yì xiē rén de xuǎn zé 。 bú zài wèi qiú ér bù dé de dōng xī xiē sī dǐ lǐ ，   yě bú zài wèi nà xiē yǔ zì jǐ de zhēn shí rén shēng bìng wú tài duō guān xì de rén shì jiāo jiē 。   hǎo de huài de dōu xué huì le zì jǐ chéng dān ， jiàn shi le rén shēng de cán kù ， yě jiān dìng le nèi xīn ， huái chuāi zhe nián qīng shí de yì diǎn yù wàng hé chōng jǐng ， yǒng gǎn gǎn lù ， bú fù yú shēng',
  'Có tuổi đời nhất định luôn là điều tốt, càng ngày càng biết thông cảm với những khó khăn trong cuộc sống của người khác và dần hiểu được những lựa chọn của họ. Không còn điên cuồng vì những thứ không thể đạt được, cũng không còn bận tâm đến những người hay việc không liên quan quá nhiều đến cuộc đời thật của mình. Tốt hay xấu đều học cách tự gánh vác, trải nghiệm sự khắc nghiệt của cuộc đời và củng cố ý chí, mang theo chút khát vọng và ước mơ thời trẻ, dũng cảm bước tiếp, không hối tiếc phần đời còn lại.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  1,
  ARRAY['人','有一点','年纪','好的','能','他人','生活的','不易','能够','一些','人的','不再','不得','的','东西','再','那些','人生','太多','关系','人事','都','学会','了','见识','年轻时','一点','和','不复']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  2,
  ARRAY['体谅','也','为','也不','真实','着']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  3,
  ARRAY['总是','越来越','理解','选择','求','而','自己的','坏的','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  4,
  ARRAY['与','并','无','交接','坚定','内心','怀揣','勇敢','赶路']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  5,
  ARRAY['歇斯底里','承担','余生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  6,
  ARRAY['残酷','欲望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人有一点年纪总是好的，越来越能体谅他人生活的不易，也越来越能够理解一些人的选择。不再为求而不得的东西歇斯底里， 也不再为那些与自己的真实人生并无太多关系的人事交接。 好的坏的都学会了自己承担，见识了人生的残酷，也坚定了内心，怀揣着年轻时的一点欲望和憧憬，勇敢赶路，不复余生'),
  ARRAY['憧','憬']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾',
  'rén shēng shì tiáo dān háng xiàn ， suǒ yǒu de cuò guò ， dōu méi yào chóng lái de jī huì ， bié zài wèi shǒu wèi wěi ，   bié ràng mìng yùn chù chù jiē shì yí hàn',
  'Cuộc đời là một con đường một chiều, mọi sự bỏ lỡ đều không có cơ hội để làm lại. Đừng do dự, đừng để vận mệnh tràn ngập những tiếc nuối.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾'),
  1,
  ARRAY['人生','是','都','没','的','机会','在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾'),
  2,
  ARRAY['条','所有的','错过','要','别','别让']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾'),
  3,
  ARRAY['单行线','重来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾'),
  4,
  ARRAY['命运','处处']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾'),
  5,
  ARRAY['遗憾']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是条单行线，所有的错过，都没要重来的机会，别在畏首畏尾， 别让命运处处皆是遗憾'),
  6,
  ARRAY['畏首畏尾','皆']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活',
  'suì de shí hòu ， qiān wàn bú yào huā jīng lì hé shí jiān qù yóu yù hé jiū jié shén me xuǎn zé shì zuì hǎo de ， yīn wèi méi yǒu rén zhī dào 。 yǒu xiǎng fǎ jiù dà dǎn dì qù cháng shì ， gǎn shòu bù tóng de shēng huó ， duō cháng shì gōng zuò lèi xíng ， duō dú shū ， duō lǚ xíng ， duō tán liàn ài ， duō jié jiāo péng yǒu ， bǎ zhè xiē gāi jiāo de xué fèi dōu jiāo le ， rú cǐ yì lái ， 3 0 suì yǐ hòu ， nǐ cái yǒu kě néng cóng róng bú pò dì guò zì jǐ xiǎng yào de shēng huó',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活'),
  1,
  ARRAY['岁的','时候','不要','和','时间','去','什么','是','人','有','想法','大胆地','不同的','生活','多','工作','读书','朋友','这些','的','学费','都','了','岁','你','有可能','想要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活'),
  2,
  ARRAY['千万','最好的','因为没有','知道','就','旅行','以后','从容不迫地','过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活'),
  3,
  ARRAY['花','选择','感受','结交','把','该','如此一来','才','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活'),
  4,
  ARRAY['精力','尝试','谈','交']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活'),
  5,
  ARRAY['犹豫','类型','恋爱']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁的时候，千万不要花精力和时间去犹豫和纠结什么选择是最好的，因为没有人知道。有想法就大胆地去尝试，感受不同的生活，多尝试工作类型，多读书，多旅行，多谈恋爱，多结交朋友，把这些该交的学费都交了，如此一来，30岁以后，你才有可能从容不迫地过自己想要的生活'),
  6,
  ARRAY['纠结']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心',
  'shēng huó zǒng shì zhè yàng ， bù néng jiào rén chù chù dōu mǎn yì 。 dàn wǒ men hái yào rè qíng dì huó xià qù 。 rén huó yì shēng ， zhí dé ài de dōng xī hěn duō ， bú yào yīn wèi yí gè bù mǎn yì ， jiù huī xīn',
  'Cuộc sống luôn như thế, không thể khiến mọi thứ đều hoàn hảo như mong muốn. Nhưng chúng ta vẫn phải sống hết mình với nhiệt huyết. Trong cuộc đời, có rất nhiều điều đáng để yêu thương, đừng vì một điều không vừa ý mà nản lòng.',
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  1,
  ARRAY['生活','这样','不能','叫','人','都','我们','热情地','一生','爱的','东西','很多','不要','一个','不满']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  2,
  ARRAY['但','还要','因为','意','就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  3,
  ARRAY['总是','满意']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  4,
  ARRAY['处处','活下去','活','值得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生活总是这样，不能叫人处处都满意。但我们还要热情地活下去。人活一生，值得爱的东西很多，不要因为一个不满意，就灰心'),
  5,
  ARRAY['灰心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完',
  'zěn yàng dù guò rén shēng de dī cháo qī ？ hǎo hǎo shuì jiào ， duàn liàn shēn tǐ ， wú lùn hé shí hǎo de tǐ pò dōu yòng dé zhe ； hé zhī xīn de péng yǒu tán tiān ， jī běn shàng bù fā láo sāo ， zhǔ yào shi huí yì huài lè de shí guāng ； duō dú shū ，   kàn yì xiē zhuàn jì ， zēng zhǎng zhī shi ， shùn dài hái kě qiáo qiáo bié rén dǎo méi de shí hòu shì zěn me tǐng guò qù de ； chèn jī zuò jiā wù ， bǎ píng shí máng lù gù bú shàng de huó ér dōu gān wán',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  1,
  ARRAY['怎样','人生','的','好好','睡觉','好的','都','和','朋友','不','是','回忆','时光','多','读书','看','一些','时候','怎么','去','做家务','上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  2,
  ARRAY['身体','体魄','知心','乐','知识','还','可','别人','忙碌','完']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  3,
  ARRAY['锻炼','用得着','发牢骚','主要','坏','把','平时','顾','干']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  4,
  ARRAY['度过','低潮期','无论何时','谈天','基本上','传记','增长','顺带','倒霉的','挺过','活儿']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  5,
  ARRAY['瞧瞧','趁机']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福',
  'yǒu xǐ yǒu bēi cái shì rén shēng ， yǒu kǔ yǒu tián cái shì shēng huó 。 wú lùn shì fán huá hái shì cāng liáng ， kàn guò de fēng jǐng jiù bú yào tài liú liàn ， bì jìng nǐ bù qián xíng shēng huó hái yào qián xíng 。 zài dà de shāng tòng ， shuì yí jiào jiù bǎ tā wàng le 。 bèi zhe zuó tiān zhuī gǎn míng tiān ， huì lèi huài le měi yí gè dāng xià 。 biān zǒu biān wàng ， cái néng gǎn shòu dào měi yí gè yíng miàn ér lái de xìng fú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  1,
  ARRAY['有喜','有','人生','生活','看过','的','不要','太','你','不','前行','再','大的','睡','一觉','昨天','明天','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  2,
  ARRAY['还是','就','还要','它','累','每一个','边','走边','到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  3,
  ARRAY['才是','甜','风景','留恋','把','忘了','坏了','当下','忘','才能','感受','迎面而来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  4,
  ARRAY['苦','无论是','毕竟','伤痛','幸福']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  5,
  ARRAY['悲','繁华','背着','追赶']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有喜有悲才是人生，有苦有甜才是生活。无论是繁华还是苍凉，看过的风景就不要太留恋，毕竟你不前行生活还要前行。再大的伤痛，睡一觉就把它忘了。背着昨天追赶明天，会累坏了每一个当下。边走边忘，才能感受到每一个迎面而来的幸福'),
  6,
  ARRAY['苍凉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生',
  'lǎo xiǎng huó gěi bié rén kàn ， nán guài nǐ guò dé nà me lèi 。 hé bì wèi le nà xiē bù shǔ yú nǐ de guān zhòng ， qù yǎn yì bú shì shàn cháng de rén shēng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生'),
  1,
  ARRAY['老','想','看','你','那么','那些','不','你的','去','不是','人生']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生'),
  2,
  ARRAY['给','别人','过','得','累','为了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生'),
  3,
  ARRAY['难怪']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生'),
  4,
  ARRAY['活','何必','观众','演绎']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生'),
  5,
  ARRAY['属于']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '老想活给别人看，难怪你过得那么累。何必为了那些不属于你的观众，去演绎不是擅长的人生'),
  6,
  ARRAY['擅长的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '在你坚持不住的时候，记得告诉自己，再坚持一下。无论心情怎么糟糕，都不要打破生活原有的规律，按时吃饭，按时睡觉。每一个今天， 都将是明天的回忆；每一个今年，都将是明年的故事。365天，每天1440分钟，做该做的事，见想见的人，吃好吃的东西',
  'zài nǐ jiān chí bú zhù de shí hòu ， jì de gào sù zì jǐ ， zài jiān chí yí xià 。 wú lùn xīn qíng zěn me zāo gāo ， dōu bú yào dǎ pò shēng huó yuán yǒu de guī lǜ ， àn shí chī fàn ， àn shí shuì jiào 。 měi yí gè jīn tiān ，   dōu jiāng shì míng tiān de huí yì ； měi yí gè jīn nián ， dōu jiāng shì míng nián de gù shì 。 3 6 5 tiān ， měi tiān 1 4 4 0 fēn zhōng ， zuò gāi zuò de shì ， jiàn xiǎng jiàn de rén ， chī hǎo chī de dōng xī',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你坚持不住的时候，记得告诉自己，再坚持一下。无论心情怎么糟糕，都不要打破生活原有的规律，按时吃饭，按时睡觉。每一个今天， 都将是明天的回忆；每一个今年，都将是明年的故事。365天，每天1440分钟，做该做的事，见想见的人，吃好吃的东西'),
  1,
  ARRAY['在','你','不住','的','时候','再','一下','怎么','都','不要','打破','生活','吃饭','睡觉','今天','是','明天','回忆','今年','明年','天','分钟','做','见','想见','人','吃','好吃的','东西']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你坚持不住的时候，记得告诉自己，再坚持一下。无论心情怎么糟糕，都不要打破生活原有的规律，按时吃饭，按时睡觉。每一个今天， 都将是明天的回忆；每一个今年，都将是明年的故事。365天，每天1440分钟，做该做的事，见想见的人，吃好吃的东西'),
  2,
  ARRAY['告诉','每一个','每天','事']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你坚持不住的时候，记得告诉自己，再坚持一下。无论心情怎么糟糕，都不要打破生活原有的规律，按时吃饭，按时睡觉。每一个今天， 都将是明天的回忆；每一个今年，都将是明年的故事。365天，每天1440分钟，做该做的事，见想见的人，吃好吃的东西'),
  3,
  ARRAY['记得','自己','心情','故事','该']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你坚持不住的时候，记得告诉自己，再坚持一下。无论心情怎么糟糕，都不要打破生活原有的规律，按时吃饭，按时睡觉。每一个今天， 都将是明天的回忆；每一个今年，都将是明年的故事。365天，每天1440分钟，做该做的事，见想见的人，吃好吃的东西'),
  4,
  ARRAY['坚持','无论','原有的','规律','按时','将']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '在你坚持不住的时候，记得告诉自己，再坚持一下。无论心情怎么糟糕，都不要打破生活原有的规律，按时吃饭，按时睡觉。每一个今天， 都将是明天的回忆；每一个今年，都将是明年的故事。365天，每天1440分钟，做该做的事，见想见的人，吃好吃的东西'),
  5,
  ARRAY['糟糕']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了',
  'suì nà nián mǎi de qǐ nà shí nián mǎi bù qǐ de wán jù ， kě què méi le dāng chū nà bān qī dài gǎn ； 3 0 suì nà nián yǒu yǒng qì qù zhuī 2 0 suì nà nián bù gǎn zhuī de nǚ hái ， kě nǚ hái zǎo yǐ wèi rén fù duō nián ； 4 0 suì nà nián xiǎng zài qù zhēn xī 3 0 suì nà nián gāi zhēn xī de péng yǒu ， kě què yǐ jīng shū yuǎn duō nián 。 rén shēng jiù shì zhè yàng ， cuò guò le jiù zài yě huí bù lái le 。 yǒu xiē shì ， xiàn zài bú zuò ， yǐ hòu zài yě bú huì zuò le',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了'),
  1,
  ARRAY['岁','那年','买得起','那','十年','买不起','的','没','了','那般','期待','有勇气','去','不敢','女孩','多年','想','再','朋友','人生','这样','再也','回','不','来','有些','现在','不做','再也不会','做']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了'),
  2,
  ARRAY['玩具','可','早已','为人','已经','就是','错过','就','事','以后']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了'),
  3,
  ARRAY['当初','感','该']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了'),
  4,
  ARRAY['却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了'),
  5,
  ARRAY['追','妇','珍惜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '岁那年买得起那十年买不起的玩具，可却没了当初那般期待感；30岁那年有勇气去追20岁那年不敢追的女孩，可女孩早已为人妇多年；40岁那年想再去珍惜30岁那年该珍惜的朋友，可却已经疏远多年。人生就是这样，错过了就再也回不来了。有些事，现在不做，以后再也不会做了'),
  6,
  ARRAY['疏远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生这部大戏，一旦拉开序幕，不管你如何怯场，都得演到戏的结尾。戏中我们爱犯一个错误，就是总把希望寄予明天，却常常做过了今天',
  'rén shēng zhè bù dà xì ， yí dàn lā kāi xù mù ， bù guǎn nǐ rú hé qiè chǎng ， dōu dé yǎn dào xì de jié wěi 。 xì zhōng wǒ men ài fàn yí gè cuò wù ， jiù shì zǒng bǎ xī wàng jì yǔ míng tiān ， què cháng cháng zuò guò le jīn tiān',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生这部大戏，一旦拉开序幕，不管你如何怯场，都得演到戏的结尾。戏中我们爱犯一个错误，就是总把希望寄予明天，却常常做过了今天'),
  1,
  ARRAY['人生','这部','大戏','一旦','不管','你','都','的','中','我们','爱','明天','做','了','今天']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生这部大戏，一旦拉开序幕，不管你如何怯场，都得演到戏的结尾。戏中我们爱犯一个错误，就是总把希望寄予明天，却常常做过了今天'),
  2,
  ARRAY['得','到','就是','希望','常常','过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生这部大戏，一旦拉开序幕，不管你如何怯场，都得演到戏的结尾。戏中我们爱犯一个错误，就是总把希望寄予明天，却常常做过了今天'),
  3,
  ARRAY['如何','戏','结尾','总','把']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生这部大戏，一旦拉开序幕，不管你如何怯场，都得演到戏的结尾。戏中我们爱犯一个错误，就是总把希望寄予明天，却常常做过了今天'),
  4,
  ARRAY['拉开','序幕','演','寄予','却']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生这部大戏，一旦拉开序幕，不管你如何怯场，都得演到戏的结尾。戏中我们爱犯一个错误，就是总把希望寄予明天，却常常做过了今天'),
  6,
  ARRAY['怯场','犯一个错误']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途',
  'méi rén néng ràng suǒ yǒu rén mǎn yì ， suǒ yǐ ràng nǐ zì jǐ hé zhòng yì de rén mǎn yì jiù kě yǐ le 。 nǐ suǒ pàn dìng de yí qiè ， yě xǔ jiù shì nǐ nèi xīn de tóu yǐng 。 rén shēng jiù shì yí gè bú duàn jiē nà hé pāo qì de guò chéng ， jiù shì yí duàn yíng jiē lěng yǎn cháo xiào gū dú qián xíng de lǚ tú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途'),
  1,
  ARRAY['没人','能','你自己','和','中意的','人','了','你','的','一切','人生','一个','不断','一段','冷眼','前行']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途'),
  2,
  ARRAY['让','所有人','所以','就','可以','所','也许','就是','过程','旅途']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途'),
  3,
  ARRAY['满意','接纳','迎接']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途'),
  4,
  ARRAY['判定','内心的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途'),
  5,
  ARRAY['投影']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '没人能让所有人满意，所以让你自己和中意的人满意就可以了。你所判定的一切，也许就是你内心的投影。人生就是一个不断接纳和抛弃的过程，就是一段迎接冷眼嘲笑孤独前行的旅途'),
  6,
  ARRAY['抛弃','嘲笑','孤独']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己',
  'dāng nǐ hěn lèi hěn lèi de shí hòu ， nǐ yīng gāi bì shàng yǎn jīng zuò shēn hū xī ， gào sù zì jǐ yīng gāi jiān chí dé zhù ，   bú yào zhè me qīng yì dì fǒu dìng zì jǐ ， shuí shuō nǐ méi yǒu hǎo de wèi lái ，   guān yú míng tiān de shì hòu tiān cái zhī dào ，   zài yí qiē biàn hǎo zhī qián ， wǒ men zǒng yào jīng lì yì xiē bù kāi xīn de rì zi ， bú yào yīn wèi yì diǎn xiá cī ér fàng qì yí duàn jiān chí ， jí shǐ méi yǒu rén wéi nǐ gǔ zhǎng ， yě yào yōu yǎ dì xiè mù ， gǎn xiè rèn zhēn fù chū de zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己'),
  1,
  ARRAY['你','很累很累','的','时候','做','住','不要','这么','谁','说','没有','好的','关于','明天','天才','在','一切','我们','一些','不开心','一点','一段','没有人','谢幕','认真']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己'),
  2,
  ARRAY['眼睛','告诉','得','事后','知道','要','经历','日子','因为','为','也']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己'),
  3,
  ARRAY['当','应该','自己','轻易地','变好','总','而','放弃','感谢']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己'),
  4,
  ARRAY['深呼吸','坚持','否定','之前','即使','鼓掌','优雅地','付出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己'),
  5,
  ARRAY['闭上','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你很累很累的时候，你应该闭上眼睛做深呼吸，告诉自己应该坚持得住， 不要这么轻易地否定自己，谁说你没有好的未来， 关于明天的事后天才知道， 在一切变好之前，我们总要经历一些不开心的日子，不要因为一点瑕疵而放弃一段坚持，即使没有人为你鼓掌，也要优雅地谢幕，感谢认真付出的自己'),
  ARRAY['瑕','疵']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生就那么几十年，走好自己的路就要有自己的思考，有坚定的意志，坚持自己的信念，坚持自己的追求，不能放松对自己的要求，更不能糊里糊涂地度过自己的人生。人生不能虚度，自己要对得起自己',
  'rén shēng jiù nà me jǐ shí nián ， zǒu hǎo zì jǐ de lù jiù yào yǒu zì jǐ de sī kǎo ， yǒu jiān dìng de yì zhì ， jiān chí zì jǐ de xìn niàn ， jiān chí zì jǐ de zhuī qiú ， bù néng fàng sōng duì zì jǐ de yāo qiú ， gèng bù néng hú lǐ hú tú dì dù guò zì jǐ de rén shēng 。 rén shēng bù néng xū dù ， zì jǐ yào duì de qǐ zì jǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就那么几十年，走好自己的路就要有自己的思考，有坚定的意志，坚持自己的信念，坚持自己的追求，不能放松对自己的要求，更不能糊里糊涂地度过自己的人生。人生不能虚度，自己要对得起自己'),
  1,
  ARRAY['人生','那么','几十','年','好','有','不能','对','对得起']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就那么几十年，走好自己的路就要有自己的思考，有坚定的意志，坚持自己的信念，坚持自己的追求，不能放松对自己的要求，更不能糊里糊涂地度过自己的人生。人生不能虚度，自己要对得起自己'),
  2,
  ARRAY['就','走','路','就要','思考','意志','要求','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就那么几十年，走好自己的路就要有自己的思考，有坚定的意志，坚持自己的信念，坚持自己的追求，不能放松对自己的要求，更不能糊里糊涂地度过自己的人生。人生不能虚度，自己要对得起自己'),
  3,
  ARRAY['自己的','信念','放松','更','地','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就那么几十年，走好自己的路就要有自己的思考，有坚定的意志，坚持自己的信念，坚持自己的追求，不能放松对自己的要求，更不能糊里糊涂地度过自己的人生。人生不能虚度，自己要对得起自己'),
  4,
  ARRAY['坚定的','坚持','度过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生就那么几十年，走好自己的路就要有自己的思考，有坚定的意志，坚持自己的信念，坚持自己的追求，不能放松对自己的要求，更不能糊里糊涂地度过自己的人生。人生不能虚度，自己要对得起自己'),
  5,
  ARRAY['追求','糊里糊涂','虚度']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间是个好东西，让我们知道日久见人心，留到最后的才是好的。也让我们学会冷暖自知，更懂得好自为之',
  'shí jiān shì gè hǎo dōng xī ， ràng wǒ men zhī dào rì jiǔ jiàn rén xīn ， liú dào zuì hòu de cái shì hǎo de 。 yě ràng wǒ men xué huì lěng nuǎn zì zhī ， gèng dǒng de hǎo zì wéi zhī',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是个好东西，让我们知道日久见人心，留到最后的才是好的。也让我们学会冷暖自知，更懂得好自为之'),
  1,
  ARRAY['时间','是','个','好','东西','们','好的','学会','冷暖自知','好自为之']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是个好东西，让我们知道日久见人心，留到最后的才是好的。也让我们学会冷暖自知，更懂得好自为之'),
  2,
  ARRAY['让我','知道','日久见人心','到','最后的','也','懂得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间是个好东西，让我们知道日久见人心，留到最后的才是好的。也让我们学会冷暖自知，更懂得好自为之'),
  3,
  ARRAY['留','才是','更']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完',
  'zěn yàng dù guò rén shēng de dī cháo qī ？ hǎo hǎo shuì jiào ， duàn liàn shēn tǐ ， wú lùn hé shí hǎo de tǐ pò dōu yòng dé zhe ； hé zhī xīn de péng yǒu tán tiān ， jī běn shàng bù fā láo sāo ， zhǔ yào shi huí yì huài lè de shí guāng ； duō dú shū ，   kàn yì xiē zhuàn jì ， zēng zhǎng zhī shi ， shùn dài hái kě qiáo qiáo bié rén dǎo méi de shí hòu shì zěn me tǐng guò qù de ； chèn jī zuò jiā wù ， bǎ píng shí máng lù gù bú shàng de huó ér dōu gān wán',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  1,
  ARRAY['怎样','人生','的','好好','睡觉','好的','都','和','朋友','不','是','回忆','时光','多','读书','看','一些','时候','怎么','去','做家务','上']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  2,
  ARRAY['身体','体魄','知心','乐','知识','还','可','别人','忙碌','完']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  3,
  ARRAY['锻炼','用得着','发牢骚','主要','坏','把','平时','顾','干']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  4,
  ARRAY['度过','低潮期','无论何时','谈天','基本上','传记','增长','顺带','倒霉的','挺过','活儿']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '怎样度过人生的低潮期？好好睡觉，锻炼身体，无论何时好的体魄都用得着；和知心的朋友谈天，基本上不发牢骚，主要是回忆坏乐的时光；多读书， 看一些传记，增长知识，顺带还可瞧瞧别人倒霉的时候是怎么挺过去的；趁机做家务，把平时忙碌顾不上的活儿都干完'),
  5,
  ARRAY['瞧瞧','趁机']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富',
  'shì shàng yǒu yí yàng dōng xī ， bǐ rèn hé bié dōng xī dōu gèng zhōng chéng yú nǐ ， nà jiù shì nǐ de jīng lì 。 nǐ shēng mìng zhòng de rì zǐ ， nǐ zài qí zhōng zāo yù de rén hé shì ， nǐ yīn zhè xiē zāo yù chǎn shēng de bēi huān ， gǎn shòu hé sī kǎo ， zhè yí qiè jǐn jǐn shǔ yú nǐ ， bù kě néng zhuǎn ràng gěi rèn hé bié rén ， nǎ pà shì nǐ zuì qīn jìn de rén 。 zhè shì nǐ zuì zhēn guì de cái fù',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  1,
  ARRAY['有','一样','东西','都','那就','是','你的','你','生命','中的','在其中','的','人和','这些','和','这','一切','不可能','哪怕','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  2,
  ARRAY['比','别','经历','日子','事','因','思考','给','别人','最']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  3,
  ARRAY['世上','更','于你','感受']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  4,
  ARRAY['任何','仅仅','转让','亲近的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  5,
  ARRAY['产生的','悲欢','属于','珍贵的','财富']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  6,
  ARRAY['忠诚','遭遇']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害',
  'yǒu rén kè bó de cháo fěng nǐ ， nǐ mǎ shàng jiān suān dì huí jìng tā ； yǒu rén háo wú lǐ yóu dì kàn bù qǐ nǐ ， nǐ mǎ shàng qīng miè dì bǐ shì tā ； yǒu rén zài nǐ miàn qián dà sì xuàn yào ， nǐ mǎ shàng jiā bèi zhèng míng nǐ gèng lì hài ； yǒu rén duì nǐ lěng mò hū shì ， nǐ mǎ shàng duì tā lěng dàn shū yuǎn 。 kàn ， nǐ tǎo yàn de nà xiē rén ，   qīng yì jiù bǎ nǐ biàn chéng nǐ zì jǐ zuì tǎo yàn de nà zhǒng yàng zi 。 zhè cái shì " dí rén " duì nǐ zuì dà de shāng hài',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害'),
  1,
  ARRAY['有人','你','回敬','他','看不起','在','面前','大肆炫耀','对','冷漠','冷淡','看','那些','人','你自己','那种','样子','这']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害'),
  2,
  ARRAY['就','最','最大的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害'),
  3,
  ARRAY['刻薄的','马上','地','理由','轻蔑地','加倍','更','轻易','把','变成','才是']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害'),
  4,
  ARRAY['证明','厉害','讨厌的','伤害']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害'),
  5,
  ARRAY['毫无','忽视','敌人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有人刻薄的嘲讽你，你马上尖酸地回敬他；有人毫无理由地看不起你，你马上轻蔑地鄙视他；有人在你面前大肆炫耀，你马上加倍证明你更厉害；有人对你冷漠忽视，你马上对他冷淡疏远。看，你讨厌的那些人， 轻易就把你变成你自己最讨厌的那种样子。这才是"敌人"对你最大的伤害'),
  6,
  ARRAY['嘲讽','尖酸','鄙视','疏远']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不懂得感恩的人不值得同情，不懂得尊重的人不值得信任，不懂得珍惜的人不值得付出，不懂得宽容的人不值得交往',
  'bù dǒng de gǎn ēn de rén bù zhí dé tóng qíng ， bù dǒng de zūn zhòng de rén bù zhí dé xìn rèn ， bù dǒng de zhēn xī de rén bù zhí dé fù chū ， bù dǒng de kuān róng de rén bù zhí dé jiāo wǎng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不懂得感恩的人不值得同情，不懂得尊重的人不值得信任，不懂得珍惜的人不值得付出，不懂得宽容的人不值得交往'),
  1,
  ARRAY['不懂','的','人','不值得','同情']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不懂得感恩的人不值得同情，不懂得尊重的人不值得信任，不懂得珍惜的人不值得付出，不懂得宽容的人不值得交往'),
  2,
  ARRAY['得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不懂得感恩的人不值得同情，不懂得尊重的人不值得信任，不懂得珍惜的人不值得付出，不懂得宽容的人不值得交往'),
  3,
  ARRAY['感恩','信任']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不懂得感恩的人不值得同情，不懂得尊重的人不值得信任，不懂得珍惜的人不值得付出，不懂得宽容的人不值得交往'),
  4,
  ARRAY['尊重的','付出','交往']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不懂得感恩的人不值得同情，不懂得尊重的人不值得信任，不懂得珍惜的人不值得付出，不懂得宽容的人不值得交往'),
  5,
  ARRAY['珍惜','宽容的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流',
  'rén shēng bǎi nián ， zhuǎn yǎn chéng kōng 。 xǐ huan le jiù nǔ lì ， yōng yǒu le jiù zhēn xī ， shēng huó zhōng ， hěn duō shí hòu wǒ men dōu yào yǒu nài xīn ， shēng huó zhōng de kǔ nàn ， tā ràng wǒ men xué huì le chéng shòu ， rú guǒ xiǎng ràng shēng huó gèng jiā měi hǎo ， yě ràng zì jǐ gèng jiā měi hǎo de shēng huó ， wǒ men bù fáng jiù bǎ shēng huó kàn zuò shì yì dī líng dòng de shuǐ 。 jiù xiàng tā yí yàng ， yí qiè suí shì shùn yuán ， jìn qíng huān chàng bēn liú',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流'),
  1,
  ARRAY['人生','喜欢','了','生活','中','很多','时候','我们','都','中的','们','学会','想','不妨','看作','是','一滴','的','水','一样','一切','欢畅']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流'),
  2,
  ARRAY['百年','就','要有','它','让我','让','也','就像']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流'),
  3,
  ARRAY['成空','努力','如果','更加','自己','把']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流'),
  4,
  ARRAY['转眼','耐心','苦难','美好','美好的','随','顺','尽情']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流'),
  5,
  ARRAY['拥有','珍惜','承受','灵动','势']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生百年，转眼成空。喜欢了就努力，拥有了就珍惜，生活中，很多时候我们都要有耐心，生活中的苦难，它让我们学会了承受，如果想让生活更加美好，也让自己更加美好的生活，我们不妨就把生活看作是一滴灵动的水。就像它一样，一切随势顺缘，尽情欢畅奔流'),
  6,
  ARRAY['缘','奔流']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的',
  'yě xǔ nǐ de gōng zuò bú gòu hǎo ， yě xǔ nǐ zhèng chù zài kùn jìng zhōng ， yě xǔ nǐ bèi qíng suǒ qì 。 bú lùn shén me yuán yīn ， qǐng nǐ zài chū mén shí ， yí dìng yào bǎ zì jǐ dǎ bàn dé qīng qīng shuǎng shuǎng ， piào piào liang liang ， áng qǐ tóu tǐng qǐ xiōng ， miàn dài wēi xiào ， cóng róng zì ruò dì miàn duì shēng huó 。 zhǐ yào nǐ zì jǐ zhēn zhèng chēng qǐ lái le ， bié rén shì yā bù kuǎ nǐ de',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  1,
  ARRAY['你的','工作','不够好','你','中','不论什么','请','在','出门','时','一定要','打扮','漂漂亮亮','面带微笑','对生','你自己','起来','了','是','不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  2,
  ARRAY['也许','正','情','所','得','从容自若','真正','别人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  3,
  ARRAY['被','把','自己','清清爽爽','头','地面','只要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  4,
  ARRAY['处在','困境','弃','原因','挺起','活','压']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  5,
  ARRAY['胸']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  6,
  ARRAY['昂起','撑']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '也许你的工作不够好，也许你正处在困境中，也许你被情所弃。不论什么原因，请你在出门时，一定要把自己打扮得清清爽爽，漂漂亮亮，昂起头挺起胸，面带微笑，从容自若地面对生活。只要你自己真正撑起来了，别人是压不垮你的'),
  ARRAY['垮']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '生命最有趣的部分，正是它没有剧本，没有彩排，不能重来。生命最有分量的部分，正是我们要做自己，承担所有的责任',
  'shēng mìng zuì yǒu qù de bù fen ， zhèng shì tā méi yǒu jù běn ， méi yǒu cǎi pái ， bù néng chóng lái 。 shēng mìng zuì yǒu fèn liàng de bù fen ， zhèng shì wǒ men yào zuò zì jǐ ， chéng dān suǒ yǒu de zé rèn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命最有趣的部分，正是它没有剧本，没有彩排，不能重来。生命最有分量的部分，正是我们要做自己，承担所有的责任'),
  1,
  ARRAY['生命','有趣','的','没有','不能','有分','我们','做自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命最有趣的部分，正是它没有剧本，没有彩排，不能重来。生命最有分量的部分，正是我们要做自己，承担所有的责任'),
  2,
  ARRAY['最','正是','它','要','所有的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命最有趣的部分，正是它没有剧本，没有彩排，不能重来。生命最有分量的部分，正是我们要做自己，承担所有的责任'),
  3,
  ARRAY['重来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命最有趣的部分，正是它没有剧本，没有彩排，不能重来。生命最有分量的部分，正是我们要做自己，承担所有的责任'),
  4,
  ARRAY['部分','剧本','彩排','量','责任']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '生命最有趣的部分，正是它没有剧本，没有彩排，不能重来。生命最有分量的部分，正是我们要做自己，承担所有的责任'),
  5,
  ARRAY['承担']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你',
  'nǐ céng jiǎn xià zì jǐ de yí duàn qīng chūn shí guāng ， yòng lái fèn bú gù shēn dì cháo zhe yí gè mù biāo kuáng bēn ， nà yǒng gǎn de mú yàng ， rèn hé shí hòu xiǎng qǐ lái dōu jué de jiāo ào 。 xiàng xià rì lǐ rè liè de tài yáng ， xiàng yuán yě lǐ zì yóu de fēng ， xiàng cóng bù céng diē dǎo yí yàng 。 nǐ yǒng yuǎn shēn xìn ， yǒu xiē dōng xī ， dōng tiān cóng nǐ shēn biān dài zǒu le ， chūn tiān huì hái gěi nǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你'),
  1,
  ARRAY['你','下','一段','时光','一个','那','时候','想起来','都','觉得','里','热烈的','太阳','一样','有些','东西','了','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你'),
  2,
  ARRAY['从不','从','身边','还给']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你'),
  3,
  ARRAY['自己的','用来','地','目标','像','夏日','自由的','风','冬天','带走','春天']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你'),
  4,
  ARRAY['奋不顾身','勇敢的','任何','骄傲','原野','永远','深信']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你'),
  5,
  ARRAY['曾','剪','青春','朝着','狂奔','模样']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '你曾剪下自己的一段青春时光，用来奋不顾身地朝着一个目标狂奔，那勇敢的模样，任何时候想起来都觉得骄傲。像夏日里热烈的太阳，像原野里自由的风，像从不曾跌倒一样。你永远深信，有些东西，冬天从你身边带走了，春天会还给你'),
  6,
  ARRAY['跌倒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人',
  'duì yú nà xiē xiǎng yào yí bù dēng tiān de rén lái shuō ， yǔ qí děng dài yí gè piāo miǎo de jī huì ， yí gè bù zhī hé shí dào lái de guì rén ， bù rú gān cuì zuò xiē qīng chūn shí gāi zuò de shì qíng ， zài bú duàn zì wǒ fēng fù yǔ qiáng dà zhōng ， nǐ huì fā xiàn ， zì jǐ yě jiù biàn chéng le nà ge rén shēng zhōng zuì dà de jī huì hé guì rén',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人'),
  1,
  ARRAY['对于','那些','想要','一步登天','的','人','来说','一个','机会','不知','不如','做','些','时','在','不断','中','你','会','了','那个','人生','和']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人'),
  2,
  ARRAY['等待','到来','贵人','事情','也','就','最大的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人'),
  3,
  ARRAY['干脆','该','自我','发现','自己','变成']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人'),
  4,
  ARRAY['与其','何时','丰富','与']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人'),
  5,
  ARRAY['青春','强大']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '对于那些想要一步登天的人来说，与其等待一个缥缈的机会，一个不知何时到来的贵人，不如干脆做些青春时该做的事情，在不断自我丰富与强大中，你会发现，自己也就变成了那个人生中最大的机会和贵人'),
  ARRAY['缥','缈']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚',
  'qīng chūn zhōng jiū huì fēi zǒu ， wǒ men yě yí dìng huì zhú jiàn shuāi lǎo ， dàn nián qīng shí wǒ men duì dài nián qīng de tài dù ， zé huì jué dìng wèi lái wǒ men huì zǒu shàng yì tiáo shén me yàng de lù 。 bǎ qīng chūn hé měi lì zuò wéi bó dé xìng fú chóu mǎ de ， zhōng jiū huì yīn wèi nián lǎo sè shuāi ér shī qù xìng fú ， ér jiāng qīng chūn zuò wéi yì chǎng xiū liàn de ， rén shēng de jī diàn què huì suí zhe shí jiān de liú shì ér zhú jiàn shēn hòu',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚'),
  1,
  ARRAY['会','飞走','我们','一定','年轻时','对待','年轻的','一条','什么样','的','和美','作为','年老','一场','人生','时间的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚'),
  2,
  ARRAY['也','但','走上','路','因为','色']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚'),
  3,
  ARRAY['终究','决定','把','而']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚'),
  4,
  ARRAY['态度','则','丽','博得','幸福','失去','将','修炼','积淀','却','随着','流逝','深厚']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚'),
  5,
  ARRAY['青春','逐渐','未来']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '青春终究会飞走，我们也一定会逐渐衰老，但年轻时我们对待年轻的态度，则会决定未来我们会走上一条什么样的路。把青春和美丽作为博得幸福筹码的，终究会因为年老色衰而失去幸福，而将青春作为一场修炼的，人生的积淀却会随着时间的流逝而逐渐深厚'),
  6,
  ARRAY['衰老','筹码','衰']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '日子不是用来将就的，你表现得越卑微，一些幸福的东西就会离你越远。除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉',
  'rì zǐ bú shì yòng lái jiāng jiù de ， nǐ biǎo xiàn dé yuè bēi wēi ， yì xiē xìng fú de dōng xī jiù huì lí nǐ yuè yuǎn 。 chú le nǐ zì jǐ ， méi yǒu rén huì míng bái nǐ de gù shì lǐ yǒu guò duō shǎo kuài lè huò shāng bēi ， yīn wèi nà zhōng jiū zhǐ shì nǐ yí gè rén de gǎn jué',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子不是用来将就的，你表现得越卑微，一些幸福的东西就会离你越远。除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  1,
  ARRAY['不是','的','你','一些','东西','会','你自己','没有人','明白','你的','里','有','少','那','一个人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子不是用来将就的，你表现得越卑微，一些幸福的东西就会离你越远。除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  2,
  ARRAY['日子','表现','得','就','离','远','过多','快乐','因为']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子不是用来将就的，你表现得越卑微，一些幸福的东西就会离你越远。除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  3,
  ARRAY['用来','越','除了','故事','或','终究','只是','感觉']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子不是用来将就的，你表现得越卑微，一些幸福的东西就会离你越远。除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  4,
  ARRAY['将就','幸福的','伤悲']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '日子不是用来将就的，你表现得越卑微，一些幸福的东西就会离你越远。除了你自己，没有人会明白你的故事里有过多少快乐或伤悲，因为那终究只是你一个人的感觉'),
  6,
  ARRAY['卑微']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富',
  'shì shàng yǒu yí yàng dōng xī ， bǐ rèn hé bié dōng xī dōu gèng zhōng chéng yú nǐ ， nà jiù shì nǐ de jīng lì 。 nǐ shēng mìng zhòng de rì zǐ ， nǐ zài qí zhōng zāo yù de rén hé shì ， nǐ yīn zhè xiē zāo yù chǎn shēng de bēi huān ， gǎn shòu hé sī kǎo ， zhè yí qiè jǐn jǐn shǔ yú nǐ ， bù kě néng zhuǎn ràng gěi rèn hé bié rén ， nǎ pà shì nǐ zuì qīn jìn de rén 。 zhè shì nǐ zuì zhēn guì de cái fù',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  1,
  ARRAY['有','一样','东西','都','那就','是','你的','你','生命','中的','在其中','的','人和','这些','和','这','一切','不可能','哪怕','人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  2,
  ARRAY['比','别','经历','日子','事','因','思考','给','别人','最']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  3,
  ARRAY['世上','更','于你','感受']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  4,
  ARRAY['任何','仅仅','转让','亲近的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  5,
  ARRAY['产生的','悲欢','属于','珍贵的','财富']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '世上有一样东西，比任何别东西都更忠诚于你，那就是你的经历。你生命中的日子，你在其中遭遇的人和事，你因这些遭遇产生的悲欢，感受和思考，这一切仅仅属于你，不可能转让给任何别人，哪怕是你最亲近的人。这是你最珍贵的财富'),
  6,
  ARRAY['忠诚','遭遇']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现',
  'ràng wǒ men hǎo hǎo dì bǎ wò zhù qīng chūn ， xué nà chuān yún pò wù de hǎi yàn qù bó jī fēng yǔ ， xué nà gāo dà tǐng bá de qīng sōng qù jǐng shuāng ào xuě 。 zhǐ yǒu rú cǐ ， cái néng zài zì jǐ de qīng chūn shǐ shàng xiě xià wú yuàn wú huǐ de yí yè 。 bú yào pà shū ， qīng chūn shì yǒng yuǎn bù fú shū de ， zhǐ yào nǐ kěn nǔ lì ， mèng xiǎng zhōng huì shí xiàn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现'),
  1,
  ARRAY['们','好好','住','学','那','的','去','那高','大','在','写下','一页','不要','是','不服输的','你','会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现'),
  2,
  ARRAY['让我','穿','雪']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现'),
  3,
  ARRAY['地','把握','风雨','只有','如此','才能','自己的','史上','怕','只要','努力','终','实现']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现'),
  4,
  ARRAY['云','破','海燕','挺拔','傲','无怨无悔','输','永远','肯','梦想']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现'),
  5,
  ARRAY['青春','雾','青松']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '让我们好好地把握住青春，学那穿云破雾的海燕去搏击风雨，学那高大挺拔的青松去颈霜傲雪。只有如此，才能在自己的青春史上写下无怨无悔的一页。不要怕输，青春是永远不服输的，只要你肯努力，梦想终会实现'),
  6,
  ARRAY['搏击','颈','霜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景',
  'rén shēng de guò chéng bì rán kǎn kě ， kě shì jīng lì běn shēn bì rán ràng nǐ biàn de gèng hǎo 。 nǎ pà jié guǒ bù rú yù xiǎng de ， yě yǒu qí fā shēng de bì rán xìng yuán yīn 。 kě yǐ kěn dìng de shì ， tā yí dìng huì bǐ nǐ běn lái xiǎng de gèng hǎo ， gèng qià dàng ， yě xǔ dāng shí de nǐ hái bù dǒng de ， dàn dāng nǐ dào dá zhōng diǎn shí zhōng jiū huì míng bái yí qiè dōu shì yǒu yì yì de 。 zhǐ yǒu lì jīng zuì yán kù de kǎo yàn ， cái kàn dé dào zuì jí zhì de fēng jǐng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景'),
  1,
  ARRAY['人生','的','本身','你','哪怕','不如','有','是','一定','会','本来','想','不懂','时','明白','一切都','有意义的','看']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景'),
  2,
  ARRAY['过程','可是','经历','让','也','可以','它','比','也许','还','得','但','到达终点','最','得到']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景'),
  3,
  ARRAY['必然','变得更好','结果','其','发生的','必然性','更好','更','当时的','当','终究','只有','历经','才','极致','风景']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景'),
  4,
  ARRAY['预想','原因','肯定的','严酷的考验']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景'),
  6,
  ARRAY['恰当']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生的过程必然坎坷，可是经历本身必然让你变得更好。哪怕结果不如预想的，也有其发生的必然性原因。可以肯定的是，它一定会比你本来想的更好，更恰当，也许当时的你还不懂得，但当你到达终点时终究会明白一切都是有意义的。只有历经最严酷的考验，才看得到最极致的风景'),
  ARRAY['坎','坷']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子',
  'měi gè rén dōu yǒu zì jǐ de huó fǎ ， nǐ méi bì yào qù xiàn mù bié rén de shēng huó 。 yǒu de rén biǎo miàn fēng guāng ， àn dì lǐ què bù zhī liú le duō shǎo yǎn lèi ； yǒu de rén kàn sì shēng huó jiǒng pò ， shí jì shang rén jiā kě néng guò dé xiāo sǎ kuài huó 。 nǐ gēn běn bù zhī dào bié rén zài yòng zěn yàng de shēng huó fāng shì shēng cún zhe ， shōu huí xiàn mù bié rén de mù guāng ， fǎn guān nèi xīn 。 zì jǐ xǐ huan de rì zi ， jiù shì zuì měi de rì zi',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子'),
  1,
  ARRAY['都','有','你','没','去','的','生活','有的','人','不知','了','多少','看似','人家','在','怎样','生活方式','生存','喜欢的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子'),
  2,
  ARRAY['每个人','别人','表面','眼泪','可能','过','得','快活','知道','着','日子','就是','最美']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子'),
  3,
  ARRAY['自己的','法','必要','风光','实际上','根本不','用','目光','自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子'),
  4,
  ARRAY['活','羡慕','却','流','收回','反观','内心']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子'),
  5,
  ARRAY['暗地里','窘迫']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '每个人都有自己的活法，你没必要去羡慕别人的生活。有的人表面风光，暗地里却不知流了多少眼泪；有的人看似生活窘迫，实际上人家可能过得潇洒快活。你根本不知道别人在用怎样的生活方式生存着，收回羡慕别人的目光，反观内心。自己喜欢的日子，就是最美的日子'),
  6,
  ARRAY['潇洒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点',
  'zì jǐ xiǎng yào de dōng xī ， yào me fèn lì zhí zhuī ， yào me gān cuì fàng qì 。 bié zǒng shì féng rén jiù dié dié bù xiū dì biǎo jué xīn huò zhě āi yuàn bú duàn ， zuò bié rén chá yú fàn hòu de xiào diǎn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点'),
  1,
  ARRAY['想要的东西','人','喋喋不休','不断','做','茶余饭后','的','点']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点'),
  2,
  ARRAY['要么','别','就','别人','笑']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点'),
  3,
  ARRAY['自己','直','干脆','放弃','总是','地表','决心','或者']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点'),
  4,
  ARRAY['奋力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点'),
  5,
  ARRAY['追']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '自己想要的东西，要么奋力直追，要么干脆放弃。别总是逢人就喋喋不休地表决心或者哀怨不断，做别人茶余饭后的笑点'),
  6,
  ARRAY['逢','哀怨']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善',
  'yǒu shí hòu wéi yǒu tòng shàng zhè me yì bǎ ， jǐn zhāng nà me yì huí ， cái néng cù shǐ wǒ men zhàn shèng nèi xīn de duò xìng ， yǒu dòng lì bú duàn gǎi zhèng hé wán shàn',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善'),
  1,
  ARRAY['有时候','上','这么','一把','那么','一','回','我们','有','不断','和']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善'),
  2,
  ARRAY['动力','完善']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善'),
  3,
  ARRAY['才能']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善'),
  4,
  ARRAY['紧张','内心的','改正']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善'),
  5,
  ARRAY['唯有','痛','促使','战胜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '有时候唯有痛上这么一把，紧张那么一回，才能促使我们战胜内心的惰性，有动力不断改正和完善'),
  6,
  ARRAY['惰性']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '时间真好，验证了人心，见证了人性，懂得了真的，明白了假的，没有解不开的难题，只有解不开的心结。没有过不去的经历，只有走不出的自己。一开始你总是担心会失去谁，可你却忘了问，又有谁会害怕失去你？人生，努力了，珍惜了，问心无愧，如此，甚好',
  'shí jiān zhēn hǎo ， yàn zhèng le rén xīn ， jiàn zhèng le rén xìng ， dǒng de le zhēn de ， míng bái le jiǎ de ， méi yǒu jiě bù kāi de nán tí ， zhǐ yǒu jiě bù kāi de xīn jié 。 méi yǒu guò bú qù de jīng lì ， zhǐ yǒu zǒu bù chū de zì jǐ 。 yì kāi shǐ nǐ zǒng shì dān xīn huì shī qù shuí ， kě nǐ què wàng le wèn ， yòu yǒu shuí huì hài pà shī qù nǐ ？ rén shēng ， nǔ lì le ， zhēn xī le ， wèn xīn wú kuì ， rú cǐ ， shèn hǎo',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间真好，验证了人心，见证了人性，懂得了真的，明白了假的，没有解不开的难题，只有解不开的心结。没有过不去的经历，只有走不出的自己。一开始你总是担心会失去谁，可你却忘了问，又有谁会害怕失去你？人生，努力了，珍惜了，问心无愧，如此，甚好'),
  1,
  ARRAY['时间','了','人心','见证','人性','明白','没有','没有过','不去','的','不','出','一开始','你','会','谁','有','人生','好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间真好，验证了人心，见证了人性，懂得了真的，明白了假的，没有解不开的难题，只有解不开的心结。没有过不去的经历，只有走不出的自己。一开始你总是担心会失去谁，可你却忘了问，又有谁会害怕失去你？人生，努力了，珍惜了，问心无愧，如此，甚好'),
  2,
  ARRAY['真好','懂得','真的','经历','走','可','问','问心无愧']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间真好，验证了人心，见证了人性，懂得了真的，明白了假的，没有解不开的难题，只有解不开的心结。没有过不去的经历，只有走不出的自己。一开始你总是担心会失去谁，可你却忘了问，又有谁会害怕失去你？人生，努力了，珍惜了，问心无愧，如此，甚好'),
  3,
  ARRAY['假的','解不开的','难题','只有','心','结','自己','总是','担心','忘了','又','害怕','努力','如此']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间真好，验证了人心，见证了人性，懂得了真的，明白了假的，没有解不开的难题，只有解不开的心结。没有过不去的经历，只有走不出的自己。一开始你总是担心会失去谁，可你却忘了问，又有谁会害怕失去你？人生，努力了，珍惜了，问心无愧，如此，甚好'),
  4,
  ARRAY['验证','失去','却','甚']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '时间真好，验证了人心，见证了人性，懂得了真的，明白了假的，没有解不开的难题，只有解不开的心结。没有过不去的经历，只有走不出的自己。一开始你总是担心会失去谁，可你却忘了问，又有谁会害怕失去你？人生，努力了，珍惜了，问心无愧，如此，甚好'),
  5,
  ARRAY['珍惜']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路',
  'rén shēng shì yì chǎng gū lǚ 。 nǐ jiù shì nǐ ， shì shàng zài méi yǒu dì èr gè 。 shì shàng zhǐ yǒu xiāng shì de rén ， méi yǒu wán quán xiāng tóng de rén 。 bú yào qí qiú tài duō ， gèng bú yào yī lài ， yīn wèi jí shǐ shì nǐ de yǐng zǐ ， yě huì xiāo shī zài hēi àn zhōng 。 chú le nǐ ， méi rén néng zǒu wán nǐ xiǎng zǒu de lù',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路'),
  1,
  ARRAY['人生','是','一场','你','再','没有','人','不要','太多','你的','影子','会','中','没人','能','想','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路'),
  2,
  ARRAY['旅','就是','第二个','完全相同的','因为','也','黑暗','走完','走','路']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路'),
  3,
  ARRAY['世上','只有','相似的','祈求','更','除了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路'),
  4,
  ARRAY['即使','消失在']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路'),
  5,
  ARRAY['依赖']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '人生是一场孤旅。你就是你，世上再没有第二个。世上只有相似的人，没有完全相同的人。不要祈求太多，更不要依赖，因为即使是你的影子，也会消失在黑暗中。除了你，没人能走完你想走的路'),
  6,
  ARRAY['孤']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '如果你不快乐，那就出去走走。世界这么大，风景很美，机会很多，当阳光穿过树林，折射出绚烂的彩虹，你会惊叹生活的美好',
  'rú guǒ nǐ bú kuài lè ， nà jiù chū qù zǒu zǒu 。 shì jiè zhè me dà ， fēng jǐng hěn měi ， jī huì hěn duō ， dāng yáng guāng chuān guò shù lín ， zhé shè chū xuàn làn de cǎi hóng ， nǐ huì jīng tàn shēng huó de měi hǎo',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你不快乐，那就出去走走。世界这么大，风景很美，机会很多，当阳光穿过树林，折射出绚烂的彩虹，你会惊叹生活的美好'),
  1,
  ARRAY['你','不快','那就','出去','这么','大','很','机会','很多','出','的','会','生活的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你不快乐，那就出去走走。世界这么大，风景很美，机会很多，当阳光穿过树林，折射出绚烂的彩虹，你会惊叹生活的美好'),
  2,
  ARRAY['乐','走走','穿过']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你不快乐，那就出去走走。世界这么大，风景很美，机会很多，当阳光穿过树林，折射出绚烂的彩虹，你会惊叹生活的美好'),
  3,
  ARRAY['如果','世界','风景','当阳','树林']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你不快乐，那就出去走走。世界这么大，风景很美，机会很多，当阳光穿过树林，折射出绚烂的彩虹，你会惊叹生活的美好'),
  4,
  ARRAY['美','光','折射','彩虹','惊叹','美好']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '如果你不快乐，那就出去走走。世界这么大，风景很美，机会很多，当阳光穿过树林，折射出绚烂的彩虹，你会惊叹生活的美好'),
  5,
  ARRAY['绚烂']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '当你想不出任何理由继续的时候，你就得想出一个重新开始的理由',
  'dāng nǐ xiǎng bù chū rèn hé lǐ yóu jì xù de shí hòu ， nǐ jiù dé xiǎng chū yí gè chóng xīn kāi shǐ de lǐ yóu',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你想不出任何理由继续的时候，你就得想出一个重新开始的理由'),
  1,
  ARRAY['你','想','不','出任','时候','想出','一个','的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你想不出任何理由继续的时候，你就得想出一个重新开始的理由'),
  2,
  ARRAY['就得']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你想不出任何理由继续的时候，你就得想出一个重新开始的理由'),
  3,
  ARRAY['当','理由','重新开始']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '当你想不出任何理由继续的时候，你就得想出一个重新开始的理由'),
  4,
  ARRAY['何','继续的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '不要浪费时间追忆失去的东西，你得朝前看，因为生命不会走回头路',
  'bú yào làng fèi shí jiān zhuī yì shī qù de dōng xī ， nǐ dé cháo qián kàn ， yīn wéi shēng mìng bú huì zǒu huí tóu lù',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要浪费时间追忆失去的东西，你得朝前看，因为生命不会走回头路'),
  1,
  ARRAY['不要','东西','你','看','生命','不会']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要浪费时间追忆失去的东西，你得朝前看，因为生命不会走回头路'),
  2,
  ARRAY['得','因为','走回头路']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要浪费时间追忆失去的东西，你得朝前看，因为生命不会走回头路'),
  4,
  ARRAY['浪费时间','失去的']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '不要浪费时间追忆失去的东西，你得朝前看，因为生命不会走回头路'),
  5,
  ARRAY['追忆','朝前']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦',
  'běn shì bú dà ， pí qì jiù bú yào tài dà ， fǒu zé nǐ huì hěn má fán ； néng lì bú dà ， yù wàng jiù bú yào tài dà ， fǒu zé nǐ huì hěn tòng kǔ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  1,
  ARRAY['本事','不大','不要','太大','你','会','很','能力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  2,
  ARRAY['就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  4,
  ARRAY['脾气','否则','麻烦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  5,
  ARRAY['痛苦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  6,
  ARRAY['欲望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你',
  'chèn zhe nián qīng ， nǐ xū yào duō xiào yì xiē kǔ ， rán hòu cái huì zhēn zhèng qiān gōng 。 bù rán ， nǐ nà zì yǐ wéi shì de cōng ming hé miǎo shì yí qiè de yōu yuè gǎn chí zǎo yào huǐ le nǐ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你'),
  1,
  ARRAY['年轻','你','多','一些','会','不然','那','和','一切的','了']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你'),
  2,
  ARRAY['笑','然后','真正','要']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你'),
  3,
  ARRAY['需要','才','自以为是的','聪明','迟早']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你'),
  4,
  ARRAY['苦','优越感']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你'),
  5,
  ARRAY['趁着','谦恭']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '趁着年轻，你需要多笑一些苦，然后才会真正谦恭。不然，你那自以为是的聪明和藐视一切的优越感迟早要毁了你'),
  6,
  ARRAY['藐视','毁']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '命运如一壶翻滚的沸水，我们是一撮生命的清茶。没有水的浸泡，茶只能蜷伏一隅；没有命运的冲刷，人生只会索然寡味。茶在沉浮之中散发出馥郁的清香，生命在挫折之中绽放出礼赞的光芒',
  'mìng yùn rú yī hú fān gǔn de fèi shuǐ ， wǒ men shì yì cuō shēng mìng de qīng chá 。 méi yǒu shuǐ de jìn pào ， chá zhǐ néng quán fú yì yú ； méi yǒu mìng yùn de chōng shuā ， rén shēng zhī huì suǒ rán guǎ wèi 。 chá zài chén fú zhī zhōng sàn fā chū fù yù de qīng xiāng ， shēng mìng zài cuò zhé zhī zhōng zhàn fàng chū lǐ zàn de guāng máng',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '命运如一壶翻滚的沸水，我们是一撮生命的清茶。没有水的浸泡，茶只能蜷伏一隅；没有命运的冲刷，人生只会索然寡味。茶在沉浮之中散发出馥郁的清香，生命在挫折之中绽放出礼赞的光芒'),
  1,
  ARRAY['的','我们','是','一撮','生命的','没有','水的','茶','一隅','人生','会','在','生命','出']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '命运如一壶翻滚的沸水，我们是一撮生命的清茶。没有水的浸泡，茶只能蜷伏一隅；没有命运的冲刷，人生只会索然寡味。茶在沉浮之中散发出馥郁的清香，生命在挫折之中绽放出礼赞的光芒'),
  3,
  ARRAY['如一','清茶','只能','只','清香','绽放','礼赞']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '命运如一壶翻滚的沸水，我们是一撮生命的清茶。没有水的浸泡，茶只能蜷伏一隅；没有命运的冲刷，人生只会索然寡味。茶在沉浮之中散发出馥郁的清香，生命在挫折之中绽放出礼赞的光芒'),
  4,
  ARRAY['命运','翻滚','之中','散发出','光芒']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '命运如一壶翻滚的沸水，我们是一撮生命的清茶。没有水的浸泡，茶只能蜷伏一隅；没有命运的冲刷，人生只会索然寡味。茶在沉浮之中散发出馥郁的清香，生命在挫折之中绽放出礼赞的光芒'),
  5,
  ARRAY['壶','冲刷','索然寡味','沉浮']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '命运如一壶翻滚的沸水，我们是一撮生命的清茶。没有水的浸泡，茶只能蜷伏一隅；没有命运的冲刷，人生只会索然寡味。茶在沉浮之中散发出馥郁的清香，生命在挫折之中绽放出礼赞的光芒'),
  6,
  ARRAY['沸水','浸泡','蜷伏','馥郁的','挫折']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活',
  'zhēn zhèng cháng dé piào liang de rén hěn shǎo fā zì pāi ， zhēn zhèng yǒu qián de rén jī běn bù zěn me xuàn fù ， zhēn zhèng ēn ài de qíng lǚ yòng bù zhe zěn yàng xiù ēn ài fā jié tú ， zhēn zhèng wán dé yú kuài de shí hòu shì méi yǒu duō shǎo shí jiān chuán zhào piàn de ， zhēn zhèng guò dé jīng cǎi de rén bìng bù xū yào kè yì dì xiàng bié rén qù xuàn yào zì jǐ de shēng huó',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活'),
  1,
  ARRAY['漂亮的人','很少','有钱','的','人','不怎么','怎样','爱','时候','是','没有','多少','时间','去','生活']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活'),
  2,
  ARRAY['真正','长','得','情侣','玩','过','别人']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活'),
  3,
  ARRAY['发自','用不着','发','图','照片','需要','刻意','地','向']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活'),
  4,
  ARRAY['基本','秀恩','愉快的','传','精彩的','并不']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活'),
  5,
  ARRAY['拍']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '真正长得漂亮的人很少发自拍，真正有钱的人基本不怎么炫富，真正恩爱的情侣用不着怎样秀恩爱发截图，真正玩得愉快的时候是没有多少时间传照片的，真正过得精彩的人并不需要刻意地向别人去炫耀自己的生活'),
  6,
  ARRAY['炫富','恩爱','截','炫耀自己']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦',
  'běn shì bú dà ， pí qì jiù bú yào tài dà ， fǒu zé nǐ huì hěn má fán ； néng lì bú dà ， yù wàng jiù bú yào tài dà ， fǒu zé nǐ huì hěn tòng kǔ',
  NULL,
  (SELECT id FROM categories WHERE name = 'life'),
  (SELECT id FROM sources WHERE name = '999 letters to yourself')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  1,
  ARRAY['本事','不大','不要','太大','你','会','很','能力']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  2,
  ARRAY['就']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  4,
  ARRAY['脾气','否则','麻烦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  5,
  ARRAY['痛苦']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;


INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '本事不大，脾气就不要太大，否则你会很麻烦；能力不大，欲望就不要太大，否则你会很痛苦'),
  6,
  ARRAY['欲望']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;