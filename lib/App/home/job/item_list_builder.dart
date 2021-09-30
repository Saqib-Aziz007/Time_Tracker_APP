import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/App/home/job/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ItemListBuilder<T> extends StatelessWidget {
  const ItemListBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? item = snapshot.data;
      return _buildList(item);
    } else {
      if (snapshot.hasError) {
        return const EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t add items right now!',
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildList(List<T>? item) {
    return ListView.separated(
      itemCount: item!.length + 2,
      separatorBuilder: (context, index) => const Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) {
        if (index == 0 || index == item.length + 1) {
          return Container();
        }
        return itemBuilder(context, item[index - 1]);
      },
    );
  }
}
