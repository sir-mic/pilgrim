/// The mic drop verse library.
///
/// Bible verses grouped by distinction (hope, temptation, peace, …). The pool
/// is kept generous so a notification rarely repeats: with every category
/// enabled and an hourly interval, a verse won't come around again for days.
///
/// Verses are from the King James Version, public domain. Wording is quoted
/// straight from the text; an ellipsis marks where a passage was trimmed.
library;

import 'models.dart';

/// One verse: [text] plus its [reference].
class VerseEntry {
  const VerseEntry(this.text, this.reference);

  final String text;
  final String reference;
}

/// The full verse library, keyed by category id.
const Map<String, List<VerseEntry>> verseLibrary = {
  'hope': [
    VerseEntry(
      'Now the God of hope fill you with all joy and peace in believing, that '
          'ye may abound in hope, through the power of the Holy Ghost.',
      'Romans 15:13',
    ),
    VerseEntry(
      'For I know the thoughts that I think toward you, saith the LORD, '
          'thoughts of peace, and not of evil, to give you an expected end.',
      'Jeremiah 29:11',
    ),
    VerseEntry(
      'Why art thou cast down, O my soul? and why art thou disquieted within '
          'me? hope thou in God: for I shall yet praise him, who is the health '
          'of my countenance, and my God.',
      'Psalm 42:11',
    ),
    VerseEntry(
      'Which hope we have as an anchor of the soul, both sure and stedfast.',
      'Hebrews 6:19',
    ),
    VerseEntry(
      'I wait for the LORD, my soul doth wait, and in his word do I hope.',
      'Psalm 130:5',
    ),
    VerseEntry(
      'It is of the LORD\'s mercies that we are not consumed, because his '
          'compassions fail not. They are new every morning: great is thy '
          'faithfulness.',
      'Lamentations 3:22–23',
    ),
    VerseEntry(
      'For surely there is an end; and thine expectation shall not be cut off.',
      'Proverbs 23:18',
    ),
    VerseEntry(
      'For we are saved by hope: but hope that is seen is not hope: for what a '
          'man seeth, why doth he yet hope for? But if we hope for that we see '
          'not, then do we with patience wait for it.',
      'Romans 8:24–25',
    ),
    VerseEntry(
      'But I will hope continually, and will yet praise thee more and more.',
      'Psalm 71:14',
    ),
    VerseEntry(
      'But they that wait upon the LORD shall renew their strength; they shall '
          'mount up with wings as eagles; they shall run, and not be weary; and '
          'they shall walk, and not faint.',
      'Isaiah 40:31',
    ),
  ],

  'temptation': [
    VerseEntry(
      'There hath no temptation taken you but such as is common to man: but '
          'God is faithful, who will not suffer you to be tempted above that ye '
          'are able; but will with the temptation also make a way to escape, '
          'that ye may be able to bear it.',
      '1 Corinthians 10:13',
    ),
    VerseEntry(
      'Submit yourselves therefore to God. Resist the devil, and he will flee '
          'from you.',
      'James 4:7',
    ),
    VerseEntry(
      'Blessed is the man that endureth temptation: for when he is tried, he '
          'shall receive the crown of life, which the Lord hath promised to '
          'them that love him.',
      'James 1:12',
    ),
    VerseEntry(
      'Watch and pray, that ye enter not into temptation: the spirit indeed is '
          'willing, but the flesh is weak.',
      'Matthew 26:41',
    ),
    VerseEntry(
      'Thy word have I hid in mine heart, that I might not sin against thee.',
      'Psalm 119:11',
    ),
    VerseEntry(
      'Put on the whole armour of God, that ye may be able to stand against '
          'the wiles of the devil.',
      'Ephesians 6:11',
    ),
    VerseEntry(
      'Flee also youthful lusts: but follow righteousness, faith, charity, '
          'peace, with them that call on the Lord out of a pure heart.',
      '2 Timothy 2:22',
    ),
    VerseEntry(
      'This I say then, Walk in the Spirit, and ye shall not fulfil the lust '
          'of the flesh.',
      'Galatians 5:16',
    ),
    VerseEntry(
      'For in that he himself hath suffered being tempted, he is able to '
          'succour them that are tempted.',
      'Hebrews 2:18',
    ),
    VerseEntry(
      'Enter not into the path of the wicked, and go not in the way of evil '
          'men. Avoid it, pass not by it, turn from it, and pass away.',
      'Proverbs 4:14–15',
    ),
  ],

  'peace': [
    VerseEntry(
      'Peace I leave with you, my peace I give unto you: not as the world '
          'giveth, give I unto you. Let not your heart be troubled, neither let '
          'it be afraid.',
      'John 14:27',
    ),
    VerseEntry(
      'Be careful for nothing; but in every thing by prayer and supplication '
          'with thanksgiving let your requests be made known unto God. And the '
          'peace of God, which passeth all understanding, shall keep your '
          'hearts and minds through Christ Jesus.',
      'Philippians 4:6–7',
    ),
    VerseEntry(
      'Be still, and know that I am God: I will be exalted among the heathen, '
          'I will be exalted in the earth.',
      'Psalm 46:10',
    ),
    VerseEntry(
      'Thou wilt keep him in perfect peace, whose mind is stayed on thee: '
          'because he trusteth in thee.',
      'Isaiah 26:3',
    ),
    VerseEntry(
      'Come unto me, all ye that labour and are heavy laden, and I will give '
          'you rest.',
      'Matthew 11:28',
    ),
    VerseEntry(
      'Cast thy burden upon the LORD, and he shall sustain thee: he shall '
          'never suffer the righteous to be moved.',
      'Psalm 55:22',
    ),
    VerseEntry(
      'Now the Lord of peace himself give you peace always by all means. The '
          'Lord be with you all.',
      '2 Thessalonians 3:16',
    ),
    VerseEntry(
      'I sought the LORD, and he heard me, and delivered me from all my fears.',
      'Psalm 34:4',
    ),
    VerseEntry(
      'Casting all your care upon him; for he careth for you.',
      '1 Peter 5:7',
    ),
    VerseEntry(
      'The LORD bless thee, and keep thee: The LORD make his face shine upon '
          'thee, and be gracious unto thee: The LORD lift up his countenance '
          'upon thee, and give thee peace.',
      'Numbers 6:24–26',
    ),
  ],

  'courage': [
    VerseEntry(
      'Have not I commanded thee? Be strong and of a good courage; be not '
          'afraid, neither be thou dismayed: for the LORD thy God is with thee '
          'whithersoever thou goest.',
      'Joshua 1:9',
    ),
    VerseEntry(
      'Fear thou not; for I am with thee: be not dismayed; for I am thy God: I '
          'will strengthen thee; yea, I will help thee; yea, I will uphold thee '
          'with the right hand of my righteousness.',
      'Isaiah 41:10',
    ),
    VerseEntry(
      'The LORD is my light and my salvation; whom shall I fear? the LORD is '
          'the strength of my life; of whom shall I be afraid?',
      'Psalm 27:1',
    ),
    VerseEntry(
      'Be strong and of a good courage, fear not, nor be afraid of them: for '
          'the LORD thy God, he it is that doth go with thee; he will not fail '
          'thee, nor forsake thee.',
      'Deuteronomy 31:6',
    ),
    VerseEntry(
      'Yea, though I walk through the valley of the shadow of death, I will '
          'fear no evil: for thou art with me; thy rod and thy staff they '
          'comfort me.',
      'Psalm 23:4',
    ),
    VerseEntry(
      'For God hath not given us the spirit of fear; but of power, and of '
          'love, and of a sound mind.',
      '2 Timothy 1:7',
    ),
    VerseEntry(
      'What time I am afraid, I will trust in thee.',
      'Psalm 56:3',
    ),
    VerseEntry(
      'Yet now be strong, O Zerubbabel, saith the LORD; and be strong, O '
          'Joshua, son of Josedech, the high priest; and be strong, all ye '
          'people of the land, saith the LORD, and work: for I am with you, '
          'saith the LORD of hosts.',
      'Haggai 2:4',
    ),
    VerseEntry(
      'Fear not: for I have redeemed thee, I have called thee by thy name; '
          'thou art mine. When thou passest through the waters, I will be with '
          'thee; and through the rivers, they shall not overflow thee.',
      'Isaiah 43:1–2',
    ),
    VerseEntry(
      'The LORD is on my side; I will not fear: what can man do unto me?',
      'Psalm 118:6',
    ),
  ],

  'gratitude': [
    VerseEntry(
      'In every thing give thanks: for this is the will of God in Christ Jesus '
          'concerning you.',
      '1 Thessalonians 5:18',
    ),
    VerseEntry(
      'Enter into his gates with thanksgiving, and into his courts with '
          'praise: be thankful unto him, and bless his name.',
      'Psalm 100:4',
    ),
    VerseEntry(
      'O give thanks unto the LORD, for he is good: for his mercy endureth for '
          'ever.',
      'Psalm 107:1',
    ),
    VerseEntry(
      'Let the peace of God rule in your hearts, to the which also ye are '
          'called in one body; and be ye thankful.',
      'Colossians 3:15',
    ),
    VerseEntry(
      'This is the day which the LORD hath made; we will rejoice and be glad '
          'in it.',
      'Psalm 118:24',
    ),
    VerseEntry(
      'Every good gift and every perfect gift is from above, and cometh down '
          'from the Father of lights, with whom is no variableness, neither '
          'shadow of turning.',
      'James 1:17',
    ),
    VerseEntry(
      'Bless the LORD, O my soul, and forget not all his benefits.',
      'Psalm 103:2',
    ),
    VerseEntry(
      'Giving thanks always for all things unto God and the Father in the name '
          'of our Lord Jesus Christ.',
      'Ephesians 5:20',
    ),
    VerseEntry(
      'Let us come before his presence with thanksgiving, and make a joyful '
          'noise unto him with psalms.',
      'Psalm 95:2',
    ),
    VerseEntry(
      'Thanks be unto God for his unspeakable gift.',
      '2 Corinthians 9:15',
    ),
  ],

  'patience': [
    VerseEntry(
      'Rejoicing in hope; patient in tribulation; continuing instant in '
          'prayer.',
      'Romans 12:12',
    ),
    VerseEntry(
      'Be patient therefore, brethren, unto the coming of the Lord. Behold, '
          'the husbandman waiteth for the precious fruit of the earth, and hath '
          'long patience for it. Be ye also patient; stablish your hearts: for '
          'the coming of the Lord draweth nigh.',
      'James 5:7–8',
    ),
    VerseEntry(
      'Wait on the LORD: be of good courage, and he shall strengthen thine '
          'heart: wait, I say, on the LORD.',
      'Psalm 27:14',
    ),
    VerseEntry(
      'But if we hope for that we see not, then do we with patience wait for '
          'it.',
      'Romans 8:25',
    ),
    VerseEntry(
      'For ye have need of patience, that, after ye have done the will of God, '
          'ye might receive the promise.',
      'Hebrews 10:36',
    ),
    VerseEntry(
      'And let us not be weary in well doing: for in due season we shall reap, '
          'if we faint not.',
      'Galatians 6:9',
    ),
    VerseEntry(
      'Rest in the LORD, and wait patiently for him: fret not thyself because '
          'of him who prospereth in his way.',
      'Psalm 37:7',
    ),
    VerseEntry(
      'To every thing there is a season, and a time to every purpose under the '
          'heaven.',
      'Ecclesiastes 3:1',
    ),
    VerseEntry(
      'It is good that a man should both hope and quietly wait for the '
          'salvation of the LORD.',
      'Lamentations 3:26',
    ),
    VerseEntry(
      'And not only so, but we glory in tribulations also: knowing that '
          'tribulation worketh patience; And patience, experience; and '
          'experience, hope.',
      'Romans 5:3–4',
    ),
  ],

  'strength': [
    VerseEntry(
      'I can do all things through Christ which strengtheneth me.',
      'Philippians 4:13',
    ),
    VerseEntry(
      'He giveth power to the faint; and to them that have no might he '
          'increaseth strength.',
      'Isaiah 40:29',
    ),
    VerseEntry(
      'God is our refuge and strength, a very present help in trouble.',
      'Psalm 46:1',
    ),
    VerseEntry(
      'And he said unto me, My grace is sufficient for thee: for my strength '
          'is made perfect in weakness. For when I am weak, then am I strong.',
      '2 Corinthians 12:9–10',
    ),
    VerseEntry(
      'My flesh and my heart faileth: but God is the strength of my heart, and '
          'my portion for ever.',
      'Psalm 73:26',
    ),
    VerseEntry(
      'For the joy of the LORD is your strength.',
      'Nehemiah 8:10',
    ),
    VerseEntry(
      'Finally, my brethren, be strong in the Lord, and in the power of his '
          'might.',
      'Ephesians 6:10',
    ),
    VerseEntry(
      'The LORD is my strength and my shield; my heart trusted in him, and I '
          'am helped: therefore my heart greatly rejoiceth; and with my song '
          'will I praise him.',
      'Psalm 28:7',
    ),
    VerseEntry(
      'The LORD God is my strength, and he will make my feet like hinds\' '
          'feet, and he will make me to walk upon mine high places.',
      'Habakkuk 3:19',
    ),
    VerseEntry(
      'It is God that girdeth me with strength, and maketh my way perfect.',
      'Psalm 18:32',
    ),
  ],

  'guidance': [
    VerseEntry(
      'Trust in the LORD with all thine heart; and lean not unto thine own '
          'understanding. In all thy ways acknowledge him, and he shall direct '
          'thy paths.',
      'Proverbs 3:5–6',
    ),
    VerseEntry(
      'I will instruct thee and teach thee in the way which thou shalt go: I '
          'will guide thee with mine eye.',
      'Psalm 32:8',
    ),
    VerseEntry(
      'Thy word is a lamp unto my feet, and a light unto my path.',
      'Psalm 119:105',
    ),
    VerseEntry(
      'And thine ears shall hear a word behind thee, saying, This is the way, '
          'walk ye in it, when ye turn to the right hand, and when ye turn to '
          'the left.',
      'Isaiah 30:21',
    ),
    VerseEntry(
      'Shew me thy ways, O LORD; teach me thy paths. Lead me in thy truth, and '
          'teach me: for thou art the God of my salvation; on thee do I wait '
          'all the day.',
      'Psalm 25:4–5',
    ),
    VerseEntry(
      'If any of you lack wisdom, let him ask of God, that giveth to all men '
          'liberally, and upbraideth not; and it shall be given him.',
      'James 1:5',
    ),
    VerseEntry(
      'O LORD, I know that the way of man is not in himself: it is not in man '
          'that walketh to direct his steps.',
      'Jeremiah 10:23',
    ),
    VerseEntry(
      'The steps of a good man are ordered by the LORD: and he delighteth in '
          'his way.',
      'Psalm 37:23',
    ),
    VerseEntry(
      'A man\'s heart deviseth his way: but the LORD directeth his steps.',
      'Proverbs 16:9',
    ),
    VerseEntry(
      'Cause me to hear thy lovingkindness in the morning; for in thee do I '
          'trust: cause me to know the way wherein I should walk; for I lift up '
          'my soul unto thee.',
      'Psalm 143:8',
    ),
  ],

  'comfort': [
    VerseEntry(
      'The LORD is nigh unto them that are of a broken heart; and saveth such '
          'as be of a contrite spirit.',
      'Psalm 34:18',
    ),
    VerseEntry(
      'Blessed are they that mourn: for they shall be comforted.',
      'Matthew 5:4',
    ),
    VerseEntry(
      'He healeth the broken in heart, and bindeth up their wounds.',
      'Psalm 147:3',
    ),
    VerseEntry(
      'Blessed be God, even the Father of our Lord Jesus Christ, the Father of '
          'mercies, and the God of all comfort; Who comforteth us in all our '
          'tribulation.',
      '2 Corinthians 1:3–4',
    ),
    VerseEntry(
      'And God shall wipe away all tears from their eyes; and there shall be '
          'no more death, neither sorrow, nor crying, neither shall there be '
          'any more pain: for the former things are passed away.',
      'Revelation 21:4',
    ),
    VerseEntry(
      'As one whom his mother comforteth, so will I comfort you.',
      'Isaiah 66:13',
    ),
    VerseEntry(
      'Weeping may endure for a night, but joy cometh in the morning.',
      'Psalm 30:5',
    ),
    VerseEntry(
      'The LORD is good, a strong hold in the day of trouble; and he knoweth '
          'them that trust in him.',
      'Nahum 1:7',
    ),
    VerseEntry(
      'The LORD is my shepherd; I shall not want.',
      'Psalm 23:1',
    ),
    VerseEntry(
      'These things I have spoken unto you, that in me ye might have peace. In '
          'the world ye shall have tribulation: but be of good cheer; I have '
          'overcome the world.',
      'John 16:33',
    ),
  ],

  'faith': [
    VerseEntry(
      'Now faith is the substance of things hoped for, the evidence of things '
          'not seen.',
      'Hebrews 11:1',
    ),
    VerseEntry(
      'For we walk by faith, not by sight.',
      '2 Corinthians 5:7',
    ),
    VerseEntry(
      'Jesus said unto him, If thou canst believe, all things are possible to '
          'him that believeth.',
      'Mark 9:23',
    ),
    VerseEntry(
      'But without faith it is impossible to please him: for he that cometh to '
          'God must believe that he is, and that he is a rewarder of them that '
          'diligently seek him.',
      'Hebrews 11:6',
    ),
    VerseEntry(
      'If ye have faith as a grain of mustard seed, ye shall say unto this '
          'mountain, Remove hence to yonder place; and it shall remove; and '
          'nothing shall be impossible unto you.',
      'Matthew 17:20',
    ),
    VerseEntry(
      'So then faith cometh by hearing, and hearing by the word of God.',
      'Romans 10:17',
    ),
    VerseEntry(
      'In God I will praise his word, in God I have put my trust; I will not '
          'fear what flesh can do unto me.',
      'Psalm 56:4',
    ),
    VerseEntry(
      'Jesus saith unto him, Thomas, because thou hast seen me, thou hast '
          'believed: blessed are they that have not seen, and yet have '
          'believed.',
      'John 20:29',
    ),
    VerseEntry(
      'By faith Abraham, when he was called to go out into a place which he '
          'should after receive for an inheritance, obeyed; and he went out, '
          'not knowing whither he went.',
      'Hebrews 11:8',
    ),
    VerseEntry(
      'I have fought a good fight, I have finished my course, I have kept the '
          'faith.',
      '2 Timothy 4:7',
    ),
  ],

  'forgiveness': [
    VerseEntry(
      'If we confess our sins, he is faithful and just to forgive us our sins, '
          'and to cleanse us from all unrighteousness.',
      '1 John 1:9',
    ),
    VerseEntry(
      'As far as the east is from the west, so far hath he removed our '
          'transgressions from us.',
      'Psalm 103:12',
    ),
    VerseEntry(
      'For if ye forgive men their trespasses, your heavenly Father will also '
          'forgive you.',
      'Matthew 6:14',
    ),
    VerseEntry(
      'Forbearing one another, and forgiving one another, if any man have a '
          'quarrel against any: even as Christ forgave you, so also do ye.',
      'Colossians 3:13',
    ),
    VerseEntry(
      'Come now, and let us reason together, saith the LORD: though your sins '
          'be as scarlet, they shall be as white as snow; though they be red '
          'like crimson, they shall be as wool.',
      'Isaiah 1:18',
    ),
    VerseEntry(
      'And be ye kind one to another, tenderhearted, forgiving one another, '
          'even as God for Christ\'s sake hath forgiven you.',
      'Ephesians 4:32',
    ),
    VerseEntry(
      'He will turn again, he will have compassion upon us; he will subdue our '
          'iniquities; and thou wilt cast all their sins into the depths of the '
          'sea.',
      'Micah 7:19',
    ),
    VerseEntry(
      'For thou, Lord, art good, and ready to forgive; and plenteous in mercy '
          'unto all them that call upon thee.',
      'Psalm 86:5',
    ),
    VerseEntry(
      'Then came Peter to him, and said, Lord, how oft shall my brother sin '
          'against me, and I forgive him? till seven times? Jesus saith unto '
          'him, I say not unto thee, Until seven times: but, Until seventy '
          'times seven.',
      'Matthew 18:21–22',
    ),
    VerseEntry(
      'Judge not, and ye shall not be judged: condemn not, and ye shall not be '
          'condemned: forgive, and ye shall be forgiven.',
      'Luke 6:37',
    ),
  ],

  'wisdom': [
    VerseEntry(
      'For the LORD giveth wisdom: and out of his mouth cometh knowledge and '
          'understanding.',
      'Proverbs 2:6',
    ),
    VerseEntry(
      'But the wisdom that is from above is first pure, then peaceable, '
          'gentle, and easy to be intreated, full of mercy and good fruits, '
          'without partiality, and without hypocrisy.',
      'James 3:17',
    ),
    VerseEntry(
      'Wisdom is the principal thing; therefore get wisdom: and with all thy '
          'getting get understanding.',
      'Proverbs 4:7',
    ),
    VerseEntry(
      'Happy is the man that findeth wisdom, and the man that getteth '
          'understanding.',
      'Proverbs 3:13',
    ),
    VerseEntry(
      'For wisdom is a defence, and money is a defence: but the excellency of '
          'knowledge is, that wisdom giveth life to them that have it.',
      'Ecclesiastes 7:12',
    ),
    VerseEntry(
      'The fear of the LORD is the beginning of wisdom: a good understanding '
          'have all they that do his commandments: his praise endureth for '
          'ever.',
      'Psalm 111:10',
    ),
    VerseEntry(
      'He that walketh with wise men shall be wise: but a companion of fools '
          'shall be destroyed.',
      'Proverbs 13:20',
    ),
    VerseEntry(
      'In whom are hid all the treasures of wisdom and knowledge.',
      'Colossians 2:3',
    ),
    VerseEntry(
      'The fear of the LORD is the beginning of wisdom: and the knowledge of '
          'the holy is understanding.',
      'Proverbs 9:10',
    ),
    VerseEntry(
      'Daniel answered and said, Blessed be the name of God for ever and ever: '
          'for wisdom and might are his.',
      'Daniel 2:20',
    ),
  ],

  'joy': [
    VerseEntry(
      'Thou wilt shew me the path of life: in thy presence is fulness of joy; '
          'at thy right hand there are pleasures for evermore.',
      'Psalm 16:11',
    ),
    VerseEntry(
      'Thou hast turned for me my mourning into dancing: thou hast put off my '
          'sackcloth, and girded me with gladness.',
      'Psalm 30:11',
    ),
    VerseEntry(
      'Rejoice in the Lord alway: and again I say, Rejoice.',
      'Philippians 4:4',
    ),
    VerseEntry(
      'These things have I spoken unto you, that my joy might remain in you, '
          'and that your joy might be full.',
      'John 15:11',
    ),
    VerseEntry(
      'Whom having not seen, ye love; in whom, though now ye see him not, yet '
          'believing, ye rejoice with joy unspeakable and full of glory.',
      '1 Peter 1:8',
    ),
    VerseEntry(
      'Yet I will rejoice in the LORD, I will joy in the God of my salvation.',
      'Habakkuk 3:18',
    ),
    VerseEntry(
      'But let all those that put their trust in thee rejoice: let them ever '
          'shout for joy, because thou defendest them: let them also that love '
          'thy name be joyful in thee.',
      'Psalm 5:11',
    ),
    VerseEntry(
      'Therefore with joy shall ye draw water out of the wells of salvation.',
      'Isaiah 12:3',
    ),
    VerseEntry(
      'Thou hast put gladness in my heart, more than in the time that their '
          'corn and their wine increased.',
      'Psalm 4:7',
    ),
    VerseEntry(
      'My brethren, count it all joy when ye fall into divers temptations.',
      'James 1:2',
    ),
  ],

  'love': [
    VerseEntry(
      'For God so loved the world, that he gave his only begotten Son, that '
          'whosoever believeth in him should not perish, but have everlasting '
          'life.',
      'John 3:16',
    ),
    VerseEntry(
      'For I am persuaded, that neither death, nor life, nor angels, nor '
          'principalities, nor powers, nor things present, nor things to come, '
          'nor height, nor depth, nor any other creature, shall be able to '
          'separate us from the love of God, which is in Christ Jesus our Lord.',
      'Romans 8:38–39',
    ),
    VerseEntry(
      'We love him, because he first loved us.',
      '1 John 4:19',
    ),
    VerseEntry(
      'A new commandment I give unto you, That ye love one another; as I have '
          'loved you, that ye also love one another.',
      'John 13:34',
    ),
    VerseEntry(
      'Beloved, let us love one another: for love is of God; and every one '
          'that loveth is born of God, and knoweth God. He that loveth not '
          'knoweth not God; for God is love.',
      '1 John 4:7–8',
    ),
    VerseEntry(
      'That Christ may dwell in your hearts by faith; that ye, being rooted '
          'and grounded in love, may be able to comprehend with all saints what '
          'is the breadth, and length, and depth, and height; and to know the '
          'love of Christ, which passeth knowledge.',
      'Ephesians 3:17–19',
    ),
    VerseEntry(
      'But the fruit of the Spirit is love, joy, peace, longsuffering, '
          'gentleness, goodness, faith.',
      'Galatians 5:22',
    ),
    VerseEntry(
      'And above all things have fervent charity among yourselves: for charity '
          'shall cover the multitude of sins.',
      '1 Peter 4:8',
    ),
    VerseEntry(
      'Know therefore that the LORD thy God, he is God, the faithful God, '
          'which keepeth covenant and mercy with them that love him and keep '
          'his commandments to a thousand generations.',
      'Deuteronomy 7:9',
    ),
    VerseEntry(
      'Charity suffereth long, and is kind; charity envieth not; charity '
          'vaunteth not itself, is not puffed up, seeketh not her own, is not '
          'easily provoked, thinketh no evil.',
      '1 Corinthians 13:4–5',
    ),
  ],
};

/// Flattens [verseLibrary] into the ordered list of [VerseNudge]s shipped in
/// content bundles.
List<VerseNudge> buildDefaultVerseNudges() {
  final result = <VerseNudge>[];
  for (final entry in verseLibrary.entries) {
    for (final verse in entry.value) {
      result.add(VerseNudge(
        category: entry.key,
        text: verse.text,
        reference: verse.reference,
      ));
    }
  }
  return result;
}
