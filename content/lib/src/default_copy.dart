/// The shipped reflection prompts and notification messages.
///
/// The admin tool lets a maintainer override these per bundle version; when it
/// has no edits it falls back to these defaults, matching the CLI build.
const List<String> defaultReflectionPrompts = [
  'What stood out today?',
  'What challenged you?',
  'What encouraged you?',
  'What did you learn about God?',
  'How can you apply today\'s reading?',
  'Write a one-sentence prayer.',
  'What verse do you remember?',
  'Summarize today\'s reading in one sentence.',
];

const List<String> defaultNotificationMessages = [
  'The Word is waiting.',
  'Grace and peace.',
  'Ready for today\'s reading?',
  'Welcome back.',
  'Let\'s continue.',
  'Begin with prayer.',
];
