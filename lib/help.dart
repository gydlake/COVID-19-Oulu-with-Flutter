// To show some related links when the info button is clicked.

import 'package:flutter_covid_oulu/hyperlink.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Information:"),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  "COVID-19 in Pohjois-Pohjanmaa (Oulu)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: '*. App source code: ',
                        style: Theme.of(context).textTheme.bodyText2,
                        children: <TextSpan>[
                          Hyperlink(
                            'in Github.',
                            'https://github.com/gydlake/COVID-19-Oulu-with-Flutter',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                      softWrap: true,
                      text: TextSpan(
                        text: '*. Open data source: ',
                        style: Theme.of(context).textTheme.bodyText2,
                        children: <TextSpan>[
                          Hyperlink(
                            'Helsingin Sanomat data desk.',
                            'https://github.com/HS-Datadesk/koronavirus-avoindata',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                      softWrap: true,
                      text: TextSpan(
                        text: '*. References: ',
                        style: Theme.of(context).textTheme.bodyText2,
                        children: <TextSpan>[
                          Hyperlink(
                            'The hyperlink in this information page uses the code in covid_stats_finland.',
                            'https://github.com/secretwpn/covid_stats_finland',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
