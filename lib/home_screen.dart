import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'activity.dart';
import 'graph_screen.dart';
import 'credits_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Activity> goodDopamineActivities = [];
  List<Activity> badDopamineActivities = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    goodDopamineActivities = await dbHelper.getActivities(true);
    badDopamineActivities = await dbHelper.getActivities(false);
    setState(() {});
  }

  void addNewDopamine(String activityName, bool isGoodDopamine) async {
    await dbHelper.insertActivity(activityName, isGoodDopamine, false);
    loadActivities();
  }

  void updateDopamineStatus(Activity activity, bool isCompleted) async {
    await dbHelper.updateActivityStatus(activity, isCompleted);
    loadActivities(); 
  }

  void deleteActivity(Activity activity) async {
    await dbHelper.deleteActivity(activity.name);
    loadActivities();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    switch (_selectedIndex) {
      case 0:
        currentScreen = buildActivityScreen(); 
        break;
      case 1:
        currentScreen = const GraphScreen(); 
        break;
      case 2:
        currentScreen = const CreditsScreen(); 
        break;
      default:
        currentScreen = buildActivityScreen(); 
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC1D2DA),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2_outlined),
            label: 'Credits',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildActivityScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40), 
          const Center(
            child: Text(
              'Detox Diary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          buildDopamineActivityColumn('Bad Dopamine Activities', badDopamineActivities),
          const SizedBox(height: 16),
          buildDopamineActivityColumn('Good Dopamine Activities', goodDopamineActivities),
        ],
      ),
    );
  }

  Widget buildDopamineActivityColumn(String title, List<Activity> activities) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showAddDopamineDialog(title == 'Good Dopamine Activities');
                  },
                ),
              ],
            ),
            Divider(color: Colors.grey.withOpacity(0.5)),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(activities[index].name),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteActivity(activities[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${activities[index].name} deleted')),
                      );
                    },
                    child: ListTile(
                      title: Text(activities[index].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.check,
                              color: activities[index].isCompleted ? Colors.green : Colors.green.withOpacity(0.4),
                            ),
                            onPressed: () {
                              updateDopamineStatus(activities[index], true);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: !activities[index].isCompleted ? Colors.red : Colors.red.withOpacity(0.4),
                            ),
                            onPressed: () {
                              updateDopamineStatus(activities[index], false);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddDopamineDialog(bool isGoodDopamine) {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Add ${isGoodDopamine ? "Good" : "Bad"} Dopamine Activity',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black), 
                  decoration: InputDecoration(
                    filled: true, 
                    fillColor: Colors.grey[200], 
                    labelText: 'Activity Name',
                    labelStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      addNewDopamine(value, isGoodDopamine);
                      Navigator.of(context).pop(); 
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      addNewDopamine(_controller.text, isGoodDopamine);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an activity name.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGoodDopamine ? Colors.green : Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
