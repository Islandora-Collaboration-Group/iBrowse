README.txt
Drupal 7 module name: icg_browse.module "Repository Browser"

INSTALLATION INSTRUCTIONS:

Store the module files in a folder called "custom" at "/sites/all/modules/custom".
This path is hardcoded into the icg_browse.module file, so if this path isn't right for your server setup, 
you will have to edit this path wherever it appears in the file "icg_browse.module" to
reflect exactly where you put the "icg_ibrowse" module folder.

Go to Drupal's Modules menu to see if the module's name appears there.
If it's there, enable it by checking the box next to the module's name.
Ensure also that the "Path" module (part of Drupal core) is also enabled.

ASSOCIATING THIS MODULE WITH A NODE:

Create a new Drupal node and give it a URL name alias of "icg-browse" so it can be 
accessed as "http://<your_server>/icg-browse".
node/[your_node]/edit > URL path settings > URL alias: "icg-browse".

Then associate the icg_ibrowse module with that node by following these instructions.
- Access Drupal: Administrion > Structure > Blocks, find the module name and move it to 
"Content", click "configure" > "Pages" check "Only the listed pages" and 
enter the name of the node you created and select "Roles" > "Administrators" if you want to set it so only 
administrators will see it.

ASSOCIATION THIS NODE WITH A MENU TAB:

To associate that node with a particular Drupal menu (tab) ...
- Access Drupal: Administration > Menu > Main Menu > Add link, give the menu link a title and 
in "Path" put the name "node/icg-browse" which you just associated with the module.

FINAL STEPS:

There is a hardcoded path in the file "icg_repo_stats.module", namely,
http://'.$_SERVER["SERVER_NAME"].'/icg-browse".
If you need to point to a different node, you'll have to edit this reference 
wherever it appears in "icg_repo_stats.module.

Now you should see a tab in the main menu that only administrators will see.

To report problems or to get assistance, please contact me:
Peter MacDonald
petermacdonald88@gmail.com
