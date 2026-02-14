import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/calendarioJogosUi.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/detalhesJogosUi.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class AgendaUi extends StatelessWidget {
  const AgendaUi({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the controller
    final Controller c = Get.put(Controller());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Visibility(visible: false, child: Text(c.artilheiros.length.toString())),
          actions: [
            FloatingActionButton.small(
                heroTag: null,
                elevation: 3,
                onPressed: () {
                  cadastro(context);
                },
                child: const Icon(CupertinoIcons.add)),
            SizedBox(width: 8),
          ],
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              flex: 3,
              child: SfCalendarTheme(
                data: SfCalendarThemeData.raw(
                  headerBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  trailingDatesBackgroundColor: context.theme.highlightColor,
                  leadingDatesBackgroundColor: context.theme.highlightColor,
                ),
                child: SfCalendar(
                  allowedViews: const <CalendarView>[
                    CalendarView.day,
                    CalendarView.month,
                    CalendarView.schedule
                  ],
                  appointmentTimeTextFormat: 'HH:mm',
                  // appointmentBuilder: appointmentBuilder,
                  maxDate: DateTime.now().add(const Duration(days: 365)),
                  showDatePickerButton: true,
                  initialDisplayDate: DateTime.now(),
                  showTodayButton: true,
                  showNavigationArrow: true,
                  allowAppointmentResize: true,
                  onTap: (calendarTapDetails) {
                    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
                      JogosData jogosData = calendarTapDetails.appointments?.first;
                      Get.dialog(AlertDialog(
                          title: Text(jogosData.adversario ?? ''),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(jogosData.local ?? ''),
                              Text(
                                  "Sport: ${jogosData.placarLocal} x ${jogosData.placarAdversario} ${jogosData.adversario} "),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.to(() => DetalhesJogosUi(), arguments: jogosData);
                                },
                                child: const Text('Detalhes')),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Fechar')),
                          ]));
                    }
                  },
                  view: CalendarView.month,
                  monthViewSettings:
                      const MonthViewSettings(showAgenda: true, showTrailingAndLeadingDates: false),
                  firstDayOfWeek: 7,
                  initialSelectedDate: DateTime.now(),
                  dataSource: MeetingDataSource(c.jogos),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<JogosData> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    JogosData jogosData = appointments![index];
    return DateTime(
      jogosData.data!.year,
      jogosData.data!.month,
      jogosData.data!.day,
      jogosData.hora!.hour,
      jogosData.hora!.minute,
    );
  }

  @override
  DateTime getEndTime(int index) {
    JogosData jogosData = appointments![index];
    return DateTime(
      jogosData.data!.year,
      jogosData.data!.month,
      jogosData.data!.day,
      jogosData.hora!.hour,
      jogosData.hora!.minute,
    ).add(Duration(hours: 2));
  }

  @override
  String getSubject(int index) {
    JogosData jogosData = appointments![index];

    return "${jogosData.adversario} - ${(jogosData.emCasa ?? true) ? 'Casa' : 'Fora'} (${jogosData.placarLocal} x ${jogosData.placarAdversario})";
  }

  @override
  Color getColor(int index) {
    JogosData jogosData = appointments![index];

    return (jogosData.placarLocal ?? 0) > (jogosData.placarAdversario ?? 0)
        ? Colors.green.shade600
        : (jogosData.placarLocal ?? 0) == (jogosData.placarAdversario ?? 0)
            ? Get.theme.colorScheme.secondary
            : Get.theme.colorScheme.error;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
