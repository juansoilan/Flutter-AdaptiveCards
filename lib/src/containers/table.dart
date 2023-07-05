///
/// https://adaptivecards.io/explorer/ColumnSet.html
///
/// This is a placeholder implementation that only shows an empty table
/// Has no error handling
///
/// Reasonable test schema is https://raw.githubusercontent.com/microsoft/AdaptiveCards/main/samples/v1.5/Scenarios/FlightUpdateTable.json
///
import 'dart:developer';
import 'package:format/format.dart';
import 'package:flutter/material.dart';

import '../base.dart';
import '../utils.dart';
import 'container.dart';

class AdaptiveTable extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveTable(
      {super.key, required this.adaptiveMap, required this.supportMarkdown});

  final Map<String, dynamic> adaptiveMap;
  final bool supportMarkdown;

  @override
  _AdaptiveTableState createState() => _AdaptiveTableState();
}

class _AdaptiveTableState extends State<AdaptiveTable>
    with AdaptiveElementMixin {
  late List<Map<String, dynamic>> columns;
  late List<Map<String, dynamic>> rows;
  late List<TableRow> tableRows;
  late MainAxisAlignment horizontalAlignment;

  @override
  void initState() {
    super.initState();
    columns = List<Map<String, dynamic>>.from(adaptiveMap["columns"] ?? []);

    // Shold all be Table Rows
    rows = List<Map<String, dynamic>>.from(adaptiveMap["rows"] ?? []);

    // print(format("Table: columns: {} rows: {}", columns.length, rows.length));
    // TODO: Need to create widgets/adaptivecards for all the items in each TableCell
    // Contents of TableCell will be a widget that can hold any number of rendeing widgets

    tableRows = List<TableRow>.generate(rows.length, (rowNum) {
      // this row out of all the rows
      Map<String, dynamic> row = rows[rowNum];
      //print(format("Row: num:{} - {})", rowNum, row.toString()));

      // All the table cells in this row [cell, cell, cell]
      List<Map<String, dynamic>> rowTableCells =
          List<Map<String, dynamic>>.from(rows[rowNum]["cells"]);
      //print(format("rowTableCells: row:{} length:{} - {} ", rowNum,
      //    rowTableCells.length, rowTableCells.toString()));

      // all of the expected widgets in this row [cell[widget], cell[widget]]
      List<List<dynamic>> rowCellItems =
          List<List<dynamic>>.generate(rowTableCells.length, (rowNum) {
        return rowTableCells[rowNum]["items"];
      });
      // print(format("rowCellItems: row:{} length:{} - {}", rowNum,
      //    rowCellItems.length, rowCellItems.toString()));

      List<TableCell> tableCells =
          List<TableCell>.generate(rowCellItems.length, (col) {
        List<Map<String, dynamic>> oneCellItems =
            List<Map<String, dynamic>>.from(rowCellItems[col]);
        // print(format("oneCellItems: row:{} col:{} widgets in cell:{} - {}",
        //     rowNum, col, oneCellItems.length, oneCellItems.toString()));
        return TableCell(
            child: Scrollbar(
                child: Wrap(
                    children: List<Widget>.generate(oneCellItems.length,
                        (widgetIndex) {
          //print(oneCellItems[widgetIndex]);
          return widgetState.cardRegistry.getElement(oneCellItems[widgetIndex]);
        }).toList())));
      }).toList();

      // print(format("cell children: {}", tableCellChildren));
      // return TableRow(children: [tableCellChildren]);
      return TableRow(children: tableCells);
    });

    //horizontalAlignment = loadHorizontalAlignment();
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        getBackgroundColorIfNoBackgroundImageAndNoDefaultStyle(
      resolver: resolver,
      adaptiveMap: adaptiveMap,
      approximateDarkThemeColors: widgetState.widget.approximateDarkThemeColors,
      brightness: Theme.of(context).brightness,
    );

    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: FlexColumnWidth(),
      // columnWidths: const <int, TableColumnWidth>{
      //   1: FlexColumnWidth(),
      //   2: FlexColumnWidth(),
      //   3: FlexColumnWidth(),
      // },
      children: tableRows,
    );
  }

  MainAxisAlignment loadHorizontalAlignment() {
    String horizontalAlignment =
        adaptiveMap["horizontalCellContentAlignment"]?.toLowerCase() ?? "left";

    switch (horizontalAlignment) {
      case "left":
        return MainAxisAlignment.start;
      case "center":
        return MainAxisAlignment.center;
      case "right":
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.start;
    }
  }
}
