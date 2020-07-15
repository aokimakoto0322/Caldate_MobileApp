import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'models.g.dart';


@SqfEntityBuilder(todoDBModel)
const todoDBModel = SqfEntityModel(
  modelName: 'TodoDbModel',
  databaseName: 'savedata.db',
  databaseTables: [todo],
  bundledDatabasePath: null
);

const todo = SqfEntityTable(
  tableName: 'todo',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('cal', DbType.integer),
    SqfEntityField('date', DbType.text),
    SqfEntityField('year', DbType.text),
  ]
);