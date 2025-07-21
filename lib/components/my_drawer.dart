import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/screens/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(){
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            //logo
            DrawerHeader(
              child: Center(
                child: Icon(Icons.person),
              )
            ),
            //home list title
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: ListTile(
                title: Text("H O M E"),
                leading: const Icon(Icons.home),
                onTap: (){
                  //pop the drawer
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: ListTile(
                title: Text("S E T T I N G S"),
                leading: const Icon(Icons.settings),
                onTap: (){
                  //pop the drawer
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage()
                    )
                  );
                },
              ),
            ),
          ],
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 25),
            child: ListTile(
              title: Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,
          ),
          ),
        ],
      )
    );
  }
}