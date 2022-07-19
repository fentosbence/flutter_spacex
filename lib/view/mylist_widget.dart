import 'package:flutter/material.dart';
import 'package:flutter_spacex/data_model.dart';
import 'package:flutter_spacex/view/details_page.dart';
import 'package:flutter_spacex/view/payload_details.dart';

import 'package:flutter_spacex/payload.dart';

class MyListWidget extends StatefulWidget {
  final List<Launch> launches;
  final List<PayloadViewModel> payloads;
  final ValueChanged<int> onLaunchDetailsExpanded;

  const MyListWidget(
      {required this.launches, required this.onLaunchDetailsExpanded, Key? key, required this.payloads})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MyListState();
}

class MyListState extends State<MyListWidget> {
  late Map<String, bool> isFavourite;

  @override
  void initState() {
    isFavourite = {for (var item in widget.launches) item.id: false};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.launches.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4),
          child: ExpansionTile(
            key: PageStorageKey<int>(index),
            onExpansionChanged: (expanded) {
              if (expanded) {
                widget.onLaunchDetailsExpanded(index);
              }
            },
            title: _buildHeaderRow(widget.launches[index]),
            children: [
              SizedBox(
                child: Column(
                  children: [
                    PayloadDetails(
                      key: PageStorageKey<int>(index),
                      payloadModel: widget.payloads[index],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              title: widget.launches[index].name,
                              payloadModel: widget.payloads[index],
                            ),
                          ),
                        );
                      },
                      child: const Text("Open details"),
                    ),
                  ],
                ),
              ),
              // _buildExpandedContent(widget.payloads[launches[index].id]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow(Launch launch) {
    return Row(
      children: [
        SizedBox(
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: Image.network(launch.smallImageUrl.toString()),
              ),
            )),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                launch.name,
              ),
              Text(launch.date.toString()),
            ],
          ),
        ),
        IconButton(
          icon: isFavourite[launch.id] ?? false
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: () {
            setState(() {
              isFavourite[launch.id] =
                  isFavourite[launch.id] == false ? true : false;
            });
          },
        ),
      ],
    );
  }
}
