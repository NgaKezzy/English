// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_cn.dart' as messages_cn;
import 'messages_en.dart' as messages_en;
import 'messages_es.dart' as messages_es;
import 'messages_hi.dart' as messages_hi;
import 'messages_jp.dart' as messages_jp;
import 'messages_ru.dart' as messages_ru;
import 'messages_vi.dart' as messages_vi;
import 'messages_br.dart' as messages_br;
import 'messages_id.dart' as messages_id;
import 'messages_th.dart' as messages_th;
import 'messages_tr.dart' as messages_tr;
import 'messages_my.dart' as messages_my;
import 'messages_ar.dart' as messages_sa;
import 'messages_it.dart' as messages_it;
import 'messages_de.dart' as messages_de;
import 'messages_gr.dart' as messages_gr;
import 'messages_nl.dart' as messages_nl;
import 'messages_pl.dart' as messages_pl;
import 'messages_kr.dart' as messages_kr;
import 'messages_kz.dart' as messages_kz;
import 'messages_bd.dart' as messages_bd;
import 'messages_ro.dart' as messages_ro;
import 'messages_ua.dart' as messages_ua;
import 'messages_uz.dart' as messages_uz;
import 'messages_nam.dart' as messages_nam;
import 'messages_az.dart' as messages_az;
import 'messages_pk.dart' as messages_pk;
import 'messages_ba.dart' as messages_ba;
import 'messages_bg.dart' as messages_bg;
import 'messages_hr.dart' as messages_hr;
import 'messages_cz.dart' as messages_cz;
import 'messages_dk.dart' as messages_dk;
import 'messages_fi.dart' as messages_fi;
import 'messages_ht.dart' as messages_ht;
import 'messages_cre.dart' as messages_cre;
import 'messages_he.dart' as messages_he;
import 'messages_hu.dart' as messages_hu;
import 'messages_lv.dart' as messages_lv;
import 'messages_no.dart' as messages_no;
import 'messages_rs.dart' as messages_rs;
import 'messages_sk.dart' as messages_sk;
import 'messages_sl.dart' as messages_sl;
import 'messages_tw.dart' as messages_tw;
import 'messages_fr.dart' as messages_fr;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'zh': () => new Future.value(null),
  'en': () => new Future.value(null),
  'es': () => new Future.value(null),
  'hi': () => new Future.value(null),
  'ja': () => new Future.value(null),
  'ru': () => new Future.value(null),
  'vi': () => new Future.value(null),
  'pt': () => new Future.value(null),
  'id': () => new Future.value(null),
  'th': () => new Future.value(null),
  'tr': () => new Future.value(null),
  'ms': () => new Future.value(null),
  'ar': () => new Future.value(null),
  'it': () => new Future.value(null),
  'de': () => new Future.value(null),
  'el': () => new Future.value(null),
  'nl': () => new Future.value(null),
  'pl': () => new Future.value(null),
  'ko': () => new Future.value(null),
  'kk': () => new Future.value(null),
  'bn': () => new Future.value(null),
  'ro': () => new Future.value(null),
  'uk': () => new Future.value(null),
  'uz': () => new Future.value(null),
  'af': () => new Future.value(null),
  'az': () => new Future.value(null),
  'ur': () => new Future.value(null),
  'bs': () => new Future.value(null),
  'bg': () => new Future.value(null),
  'hr': () => new Future.value(null),
  'cs': () => new Future.value(null),
  'da': () => new Future.value(null),
  'fi': () => new Future.value(null),
  'ht': () => new Future.value(null),
  'cre': () => new Future.value(null),
  'he': () => new Future.value(null),
  'hu': () => new Future.value(null),
  'lv': () => new Future.value(null),
  'no': () => new Future.value(null),
  'sr': () => new Future.value(null),
  'sk': () => new Future.value(null),
  'sl': () => new Future.value(null),
  'zh_Hant_TW': () => new Future.value(null),
  'fr': () => new Future.value(null),
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'zh':
      return messages_cn.messages;
    case 'en':
      return messages_en.messages;
    case 'es':
      return messages_es.messages;
    case 'hi':
      return messages_hi.messages;
    case 'ja':
      return messages_jp.messages;
    case 'ru':
      return messages_ru.messages;
    case 'vi':
      return messages_vi.messages;
    case 'pt':
      return messages_br.messages;
    case 'id':
      return messages_id.messages;
    case 'th':
      return messages_th.messages;
    case 'tr':
      return messages_tr.messages;
    case 'ms':
      return messages_my.messages;
    case 'ar':
      return messages_sa.messages;
    case 'it':
      return messages_it.messages;
    case 'de':
      return messages_de.messages;
    case 'el':
      return messages_gr.messages;
    case 'nl':
      return messages_nl.messages;
    case 'pl':
      return messages_pl.messages;
    case 'ko':
      return messages_kr.messages;
    case 'kk':
      return messages_kz.messages;
    case 'bn':
      return messages_bd.messages;
    case 'ro':
      return messages_ro.messages;
    case 'uk':
      return messages_ua.messages;
    case 'uz':
      return messages_uz.messages;
    case 'af':
      return messages_nam.messages;
    case 'az':
      return messages_az.messages;
    case 'ur':
      return messages_pk.messages;
    case 'bs':
      return messages_ba.messages;
    case 'bg':
      return messages_bg.messages;
    case 'hr':
      return messages_hr.messages;
    case 'cs':
      return messages_cz.messages;
    case 'da':
      return messages_dk.messages;
    case 'fi':
      return messages_fi.messages;
    case 'ht':
      return messages_ht.messages;
    case 'cre':
      return messages_cre.messages;
    case 'he':
      return messages_he.messages;
    case 'hu':
      return messages_hu.messages;
    case 'lv':
      return messages_lv.messages;
    case 'no':
      return messages_no.messages;
    case 'sr':
      return messages_rs.messages;
    case 'sk':
      return messages_sk.messages;
    case 'sl':
      return messages_sl.messages;
    case 'zh_Hant_TW':
      return messages_tw.messages;
    case 'fr':
      return messages_fr.messages;

    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? new Future.value(false) : lib());
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale =
      Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
