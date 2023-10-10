import 'package:flutter/material.dart';
import 'package:flutter_drag_drop/auth_service.dart';
import 'package:flutter_drag_drop/cloud_service.dart';
import 'user.dart';
import 'dart:math';

// Random number generator
int randRange(int min, int max) => min + Random().nextInt(max - min);

// User page at app startup
class UserPage extends StatefulWidget {
  UserPage({super.key, required this.user});

  final MyUser user;
  final GlobalKey _draggableKey = GlobalKey();

  @override
  State<UserPage> createState() => _UserPage();
}

// Builder
class _UserPage extends State<UserPage> {

  // Call logout
  void _logout() {
    AuthService.logout(context);
    Navigator.pop(context);
  }

  // Pad grid with null for all map keys in between
  void _padGrid({required int upTo}) {
    if (widget.user.shapeMap.isNotEmpty) {
      for (int i = 0; i < upTo; i++) {
        if (!widget.user.shapeMap.containsKey(i)) {
          widget.user.shapeMap[i] = null;
        }
      }
    }
  }

  // Check next available spot
  int _getNextAvailable() {
    int? emptySpot;
    if (widget.user.shapeMap.isNotEmpty) {
      for (int key = 0; key < widget.user.shapeMap.keys.last; key++) {
        if (widget.user.shapeMap[key] == null) {
          emptySpot = key;
          break;
        }
      }
    }
    return emptySpot ?? widget.user.shapeMap.length;
  }

  // Generate new random shape
  void _addShape() {
    int coord = _getNextAvailable();
    int id = randRange(0, numShapes);
    var item = ShapeItem(id: id.toString(), position: coord);
    setState(() {
      widget.user.shapeMap[coord] = item;
      CloudService.update(widget.user);
    });
  }

  // Move shape to target
  void _shapeDroppedOnTarget({
    required int newPosition,
    required ShapeItem item,
  }) {
    setState(() {
      _padGrid(upTo: newPosition);
      widget.user.shapeMap[newPosition] = item;
      widget.user.shapeMap[item.position] = null;
      item.position = newPosition;
      CloudService.update(widget.user);
    });
  }

  // Draw the shape
  Widget _buildDraggableItem({
    required int position,
    required ShapeItem item,
  }) {
    var imgProvider = AssetImage('assets/img${item.id}.png');
    return LongPressDraggable<ShapeItem>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingGridItem(
        dragKey: widget._draggableKey,
        photoProvider: imgProvider,
      ),
      child: GridItem(
        pos: position,
        photoProvider: imgProvider,
      ),
    );
  }

  // Draw a white square
  Widget _buildDragTarget({
    required int position,
  }) {
    return DragTarget<ShapeItem>(
      builder: (context, candidateItems, rejectedItems) {
        return GridItem(pos: position);
      },
      onAccept: (item) {
        _shapeDroppedOnTarget(
          newPosition: position,
          item: item,
        );
      },
    );
  }

  // Called every build call
  Widget _buildGridItem({
      required int index,
      required ShapeItem? item,
  }) {
    if (item != null) {
      // Insert a shape
      return _buildDraggableItem(
        position: index,
        item: item,
      );
    } else {
      // Insert a target
      return _buildDragTarget(
        position: index,
      );
    }
  }

  // Called every build call
  List<Widget> _displayGrid() {
    return List.generate(maxGrid, (index) => _buildGridItem(
        index: index,
        item: widget.user.shapeMap[index],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    String? title = widget.user.displayName;
    title ??= 'Anonymous';

    return MaterialApp(
      title: title,
      home: Scaffold(
        backgroundColor: const Color(0xffe3d4ff),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(title),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
              child: IconButton(
                icon: const Icon(Icons.logout,size: 32.0),
                onPressed: _logout,
                tooltip: 'Log out',
              ),
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 5,
          // Display grid
          children: _displayGrid(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addShape,
          // foregroundColor: ,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------------------
// Basic item
class ShapeItem {
  ShapeItem({
    required this.id,
    required this.position,
  });

  final String id;
  int position;
}

//-------------------------------------------------------------------------------------------------
// Grid item
class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.pos,
    this.photoProvider,
  });

  final int pos;
  final ImageProvider? photoProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.2 * shapeWidth,
      height: 1.2 * shapeHeight,
      child: Center(
        child: Image(
          image: photoProvider ?? const AssetImage('assets/empty.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------------------
// Dragging behavior
class DraggingGridItem extends StatelessWidget {
  const DraggingGridItem({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 1.2 * shapeHeight,
          width: 1.2 * shapeWidth,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}