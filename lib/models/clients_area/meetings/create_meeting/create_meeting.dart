import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';

import 'components/form_add_meeting.dart';


class AddMeeting extends StatelessWidget {
  const AddMeeting({required this.order,super.key});

    final String order;


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SuperAppBar(area: "none"),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Text(
              "\nCrea Appuntamento",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 300,
                child: FormAddMeeting()
                ),
                  ],
                ),
          )),
    );
  }
}