import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/pages/view_report_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/rescued_reports_list_model.dart';

import 'item_report.dart';

class RescuedReportsList extends StatelessWidget {
  const RescuedReportsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: locator<RescuedReportsListModel>().getRescued(),
      shrinkWrap: true,
      defaultChild: Center(child: CircularProgressIndicator()),
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, DataSnapshot snapshot,
      Animation animation, int index) {
    final report = Report.fromSnapshot(snapshot);

    return InkWell(
      onTap: () {
        final result = Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewReportPage(
                      report: report,
                    )));

        // Navigate back to home page if a report has been selected
        result.then((report) {
          if (report != null) Navigator.pop(context, report);
        });
      },
      child: ReportItem(
        report: report,
      ),
    );
  }
}
