// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import 'dart:core';
import 'package:meta/meta.dart' as prefix4;
import 'package:smbc_reader/models/comic.dart' as prefix1;
import 'package:smbc_reader/models/comic_data.dart' as prefix2;
import 'package:smbc_reader/models/comic_order.dart' as prefix3;
import 'package:smbc_reader/models/model_annotations.dart' as prefix0;

// ignore_for_file: prefer_adjacent_string_concatenation
// ignore_for_file: prefer_collection_literals
// ignore_for_file: unnecessary_const
// ignore_for_file: implementation_imports

// ignore:unused_import
import 'package:reflectable/mirrors.dart' as m;
// ignore:unused_import
import 'package:reflectable/src/reflectable_builder_based.dart' as r;
// ignore:unused_import
import 'package:reflectable/reflectable.dart' as r show Reflectable;

final _data = <r.Reflectable, r.ReflectorData>{
  const prefix0.DataReflectable(): r.ReflectorData(
      <m.TypeMirror>[
        r.NonGenericClassMirrorImpl(
            r'Comic',
            r'.Comic',
            7,
            0,
            const prefix0.DataReflectable(),
            const <int>[0, 1, 2, 13, 14],
            const <int>[15, 16, 17, 18, 19, 20, 21, 22, 23, 10, 11, 12, 13],
            const <int>[],
            -1,
            {},
            {},
            {
              r'': (b) => ({name, publishDate, isRead = false}) => b
                  ? prefix1.Comic(
                      isRead: isRead, name: name, publishDate: publishDate)
                  : null
            },
            -1,
            -1,
            const <int>[-1],
            const <Object>[
              prefix0.dataReflectable,
              const prefix0.Table(name: 'comics')
            ],
            null),
        r.NonGenericClassMirrorImpl(
            r'ComicData',
            r'.ComicData',
            7,
            1,
            const prefix0.DataReflectable(),
            const <int>[3, 4, 5, 6, 28, 29],
            const <int>[15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28],
            const <int>[],
            -1,
            {},
            {},
            {
              r'': (b) => ({name, altText, comicImageUrl, afterImageUrl}) => b
                  ? prefix2.ComicData(
                      afterImageUrl: afterImageUrl,
                      altText: altText,
                      comicImageUrl: comicImageUrl,
                      name: name)
                  : null
            },
            -1,
            -1,
            const <int>[-1],
            const <Object>[
              prefix0.dataReflectable,
              const prefix0.Table(name: 'comic_data')
            ],
            null),
        r.NonGenericClassMirrorImpl(
            r'ComicOrder',
            r'.ComicOrder',
            7,
            2,
            const prefix0.DataReflectable(),
            const <int>[7, 8, 9, 33, 34],
            const <int>[15, 16, 17, 18, 19, 20, 21, 22, 23, 30, 31, 32, 33],
            const <int>[],
            -1,
            {},
            {},
            {
              r'': (b) => ({name, nextName, previousName}) => b
                  ? prefix3.ComicOrder(
                      name: name,
                      nextName: nextName,
                      previousName: previousName)
                  : null
            },
            -1,
            -1,
            const <int>[-1],
            const <Object>[
              prefix0.dataReflectable,
              const prefix0.Table(name: 'comic_order')
            ],
            null)
      ],
      <m.DeclarationMirror>[
        r.VariableMirrorImpl(r'name', 33797, 0, const prefix0.DataReflectable(),
            -1, 3, 3, null, const <Object>[
          const prefix0.Column(name: 'name', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'publishDate', 33797, 0,
            const prefix0.DataReflectable(), -1, 4, 4, null, const <Object>[
          const prefix0.Column(
              name: 'publish_date', type: prefix0.ColumnType.Integer)
        ]),
        r.VariableMirrorImpl(r'isRead', 33797, 0,
            const prefix0.DataReflectable(), -1, 5, 5, null, const <Object>[
          const prefix0.Column(
              name: 'is_read', type: prefix0.ColumnType.Integer)
        ]),
        r.VariableMirrorImpl(r'name', 33797, 1, const prefix0.DataReflectable(),
            -1, 3, 3, null, const <Object>[
          const prefix0.Column(name: 'name', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'altText', 33797, 1,
            const prefix0.DataReflectable(), -1, 3, 3, null, const <Object>[
          const prefix0.Column(name: 'alt_text', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'comicImageUrl', 33797, 1,
            const prefix0.DataReflectable(), -1, 3, 3, null, const <Object>[
          const prefix0.Column(
              name: 'comic_image_url', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'afterImageUrl', 33797, 1,
            const prefix0.DataReflectable(), -1, 3, 3, null, const <Object>[
          const prefix0.Column(
              name: 'after_image_url', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'name', 33797, 2, const prefix0.DataReflectable(),
            -1, 3, 3, null, const <Object>[
          const prefix0.Column(name: 'name', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'nextName', 33797, 2,
            const prefix0.DataReflectable(), -1, 3, 3, null, const <Object>[
          const prefix0.Column(name: 'next_name', type: prefix0.ColumnType.Text)
        ]),
        r.VariableMirrorImpl(r'previousName', 33797, 2,
            const prefix0.DataReflectable(), -1, 3, 3, null, const <Object>[
          const prefix0.Column(
              name: 'previous_name', type: prefix0.ColumnType.Text)
        ]),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 0, 10),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 1, 11),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 2, 12),
        r.MethodMirrorImpl(r'props', 4325379, 0, -1, 6, 7, null, const <int>[],
            const prefix0.DataReflectable(), const <Object>[override]),
        r.MethodMirrorImpl(r'', 128, 0, -1, 0, 0, null, const <int>[0, 1, 2],
            const prefix0.DataReflectable(), const []),
        r.MethodMirrorImpl(r'==', 131074, null, -1, 5, 5, null, const <int>[3],
            const prefix0.DataReflectable(), const <Object>[override]),
        r.MethodMirrorImpl(
            r'toString',
            131074,
            null,
            -1,
            3,
            3,
            null,
            const <int>[],
            const prefix0.DataReflectable(),
            const <Object>[override]),
        r.MethodMirrorImpl(r'noSuchMethod', 65538, null, null, null, null, null,
            const <int>[4], const prefix0.DataReflectable(), const []),
        r.MethodMirrorImpl(
            r'hashCode',
            131075,
            null,
            -1,
            8,
            8,
            null,
            const <int>[],
            const prefix0.DataReflectable(),
            const <Object>[override]),
        r.MethodMirrorImpl(r'runtimeType', 131075, null, -1, 9, 9, null,
            const <int>[], const prefix0.DataReflectable(), const []),
        r.MethodMirrorImpl(r'stringify', 131075, null, -1, 5, 5, null,
            const <int>[], const prefix0.DataReflectable(), const []),
        r.MethodMirrorImpl(r'getTableName', 131074, null, -1, 3, 3, null,
            const <int>[], const prefix0.DataReflectable(), const []),
        r.MethodMirrorImpl(r'getColumnNames', 4325378, null, -1, 10, 11, null,
            const <int>[], const prefix0.DataReflectable(), const []),
        r.MethodMirrorImpl(r'toMap', 4325378, null, -1, 12, 13, null,
            const <int>[], const prefix0.DataReflectable(), const []),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 3, 24),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 4, 25),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 5, 26),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 6, 27),
        r.MethodMirrorImpl(r'props', 4325379, 1, -1, 6, 7, null, const <int>[],
            const prefix0.DataReflectable(), const <Object>[override]),
        r.MethodMirrorImpl(r'', 128, 1, -1, 1, 1, null, const <int>[5, 6, 7, 8],
            const prefix0.DataReflectable(), const []),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 7, 30),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 8, 31),
        r.ImplicitGetterMirrorImpl(const prefix0.DataReflectable(), 9, 32),
        r.MethodMirrorImpl(r'props', 4325379, 2, -1, 6, 7, null, const <int>[],
            const prefix0.DataReflectable(), const <Object>[override]),
        r.MethodMirrorImpl(r'', 128, 2, -1, 2, 2, null, const <int>[9, 10, 11],
            const prefix0.DataReflectable(), const [])
      ],
      <m.ParameterMirror>[
        r.ParameterMirrorImpl(
            r'name',
            45062,
            14,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #name),
        r.ParameterMirrorImpl(
            r'publishDate',
            45062,
            14,
            const prefix0.DataReflectable(),
            -1,
            4,
            4,
            null,
            const <Object>[prefix4.required],
            null,
            #publishDate),
        r.ParameterMirrorImpl(
            r'isRead',
            47110,
            14,
            const prefix0.DataReflectable(),
            -1,
            5,
            5,
            null,
            const [],
            false,
            #isRead),
        r.ParameterMirrorImpl(
            r'other',
            32774,
            15,
            const prefix0.DataReflectable(),
            -1,
            14,
            14,
            null,
            const [],
            null,
            null),
        r.ParameterMirrorImpl(
            r'invocation',
            32774,
            17,
            const prefix0.DataReflectable(),
            -1,
            15,
            15,
            null,
            const [],
            null,
            null),
        r.ParameterMirrorImpl(
            r'name',
            45062,
            29,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #name),
        r.ParameterMirrorImpl(
            r'altText',
            45062,
            29,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #altText),
        r.ParameterMirrorImpl(
            r'comicImageUrl',
            45062,
            29,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #comicImageUrl),
        r.ParameterMirrorImpl(
            r'afterImageUrl',
            45062,
            29,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #afterImageUrl),
        r.ParameterMirrorImpl(
            r'name',
            45062,
            34,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #name),
        r.ParameterMirrorImpl(
            r'nextName',
            45062,
            34,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #nextName),
        r.ParameterMirrorImpl(
            r'previousName',
            45062,
            34,
            const prefix0.DataReflectable(),
            -1,
            3,
            3,
            null,
            const <Object>[prefix4.required],
            null,
            #previousName)
      ],
      <Type>[
        prefix1.Comic,
        prefix2.ComicData,
        prefix3.ComicOrder,
        String,
        DateTime,
        bool,
        const m.TypeValue<List<Object>>().type,
        List,
        int,
        Type,
        const m.TypeValue<List<String>>().type,
        List,
        const m.TypeValue<Map<String, dynamic>>().type,
        Map,
        Object,
        Invocation
      ],
      3,
      {
        r'==': (dynamic instance) => (x) => instance == x,
        r'toString': (dynamic instance) => instance.toString,
        r'noSuchMethod': (dynamic instance) => instance.noSuchMethod,
        r'hashCode': (dynamic instance) => instance.hashCode,
        r'runtimeType': (dynamic instance) => instance.runtimeType,
        r'stringify': (dynamic instance) => instance.stringify,
        r'getTableName': (dynamic instance) => instance.getTableName,
        r'getColumnNames': (dynamic instance) => instance.getColumnNames,
        r'toMap': (dynamic instance) => instance.toMap,
        r'name': (dynamic instance) => instance.name,
        r'publishDate': (dynamic instance) => instance.publishDate,
        r'isRead': (dynamic instance) => instance.isRead,
        r'props': (dynamic instance) => instance.props,
        r'altText': (dynamic instance) => instance.altText,
        r'comicImageUrl': (dynamic instance) => instance.comicImageUrl,
        r'afterImageUrl': (dynamic instance) => instance.afterImageUrl,
        r'nextName': (dynamic instance) => instance.nextName,
        r'previousName': (dynamic instance) => instance.previousName
      },
      {},
      null,
      [])
};

final _memberSymbolMap = null;

void initializeReflectable() {
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
