String toComicSlug(String comicName) {
  return comicName.toLowerCase().replaceAll(' ', '-');
}

/// Calculates the proper and unique name of the comic for use within this app.
///
/// Some comic names repeat, however the comic slug (the name in the url) must be unique.
/// One example is that the comics with slugs 'computer' and 'computer-2' are both named 'Computer'.
/// This function takes both the comic's name and slug and creates a unique name while still
/// trying to stay as true to the original comic name as possible.
String getCompleteComicName(String comicName, String comicSlug) {
  // If we can convert the comic name to the comic slug, the we can use the standard name.
  if (toComicSlug(comicName) == comicSlug)
    return comicName;

  final mismatchIndex = _findMismatch(comicName.toLowerCase(), comicSlug);

  // If the comic's name and slug don't have one (case insensitive) character in common,
  // play it safe and just use the slug.
  if (mismatchIndex == 0)
    return _prettifyComicSlug(comicSlug);

  // Build the final name by taking as much as possible from the non-unique name,
  // then appending the slug value. We also remove the dash, if it exists, from between the two strings.
  // This will hopefully give an accurate comic name that is still convertible to its appropriate slug.
  var finalName = comicName.substring(0, mismatchIndex);
  var slugSuffix = comicSlug.substring(mismatchIndex);
  if (slugSuffix.startsWith('-'))
    slugSuffix = slugSuffix.replaceFirst('-', ' ');

  finalName += slugSuffix;

  // If our final name doesn't convert back to the comic slug, just use the comic slug.
  if (toComicSlug(finalName) != comicSlug)
    return _prettifyComicSlug(comicSlug);

  return finalName;
}

/// Returns the first index where two strings differ.
int _findMismatch(String s1, String s2) {
  int index = 0;

  while (index < s1.length && index < s2.length) {
    if (!_specialCharEquals(s1[index], s2[index]))
      return index;

    index++;
  }

  return index;
}

/// Normal character equals rules, except the characters ' ' and '-' are considered equal.
bool _specialCharEquals(String s1, String s2) {
  assert(s1.length == 1 && s2.length == 1);

  if (s1 == s2)
    return true;

  if (s1 == ' ' || s1 == '-') {
    if (s2 == ' ' || s2 == '-') {
      return true;
    }
  }

  return false;
}

/// Capitalizes each word in the comic slug, but doesn't attempt to remove dashes.
/// The result of this function should always be convertible back to the comic slug.
String _prettifyComicSlug(String slug) {
  return slug.replaceAllMapped(RegExp(r'\b([a-z])'), (m)=> m[1].toUpperCase());
}