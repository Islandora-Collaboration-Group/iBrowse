<?php
echo "1";

// URL: http://collections-dev.dhinitiative.org/sites/all/modules/custom/includes/icg_tuque.php
error_reporting(~0);
ini_set('display_errors', 1);

/* -----------------------------------------------------------------------------
* Implementation of hook_init( ).
*
*/
require_once "../../../../../includes/common.inc";
include_once "../../islandora/includes/tuque.inc";
echo "2";

$fedoraUrl = "http://collections.dhinitiative.org:8080/fedora";
$username = "fedoraAdmin";
$password = "Fed0r@@dmin";
?>

$connection = new RepositoryConnection($fedoraUrl, $username, $password);
  if ( !$connection )
    echo "Connection to the Fedora repo at $alias failed!";
//		echo $fedoraUrl.$username.$password;
  else {
  	echo "connection to repo made";
$connection->reuseConnection = TRUE;
$repository = new FedoraRepository(
       new FedoraApi($connection),
       new SimpleCache());
}
module_load_include('inc', 'islandora', 'includes/IslandoraTuque');
$my_islandora_tuque = new IslandoraTuque();
$repository = $my_islandora_tuque->repository; 
     if ( !$repository ) {
  	echo "repository ok";
     	echo "An attempt to open the $alias Fedora repo has failed!";
  }     
?>
/* -----------------------------------------------------------------------------
 * Connect to Fedora repo.
 * This function connects to the DG repo and returns a $repository object when successful.
 *
 */


$connection = new RepositoryConnection( $fedoraUrl, $username, $password );
//echo $fedoraUrl, $username, $password;exit;
  if ( !$connection )
    drupal_set_message( "Connection to the Fedora repo at $alias failed!", 'error' );
  else {
    drupal_set_message( "Connection to the Fedora repo at $alias was a success!" );
    $connection->reuseConnection = TRUE;
    $repository = new FedoraRepository( new FedoraApi( $connection ),
       new SimpleCache( ));
    if ( !$repository ) drupal_set_message( "An attempt to open the $alias Fedora repo has failed!", 'error' );
  }

/* -----------------------------------------------------------------------------
 * Write RDF relationships to the appropriate $fedora_objects.
 *
 */

// This is the array of OBJECT_FILENAME + RELATION + TARGET_FILENAME
// This array can be hand-built from an Excel spreadsheet created by the project team before ingest or after ingest.
// If this list can be extracted from the MODS records after ingest,
// <mods:identifier> + <mods:relatedItem/@displayLabel> + <mods:relatedItem/mods:location/mods:url>
// perhaps crosswalk it also to DC as in <dc:relation>hamilton:15|isStillOf|shahid-poe010</dc:relation>
// then you could grab the PID instead of the relationItem/@displayLabel.

$array1 = array("shahid-ess001-010","isClipOf","shahid-man009");
$array2 = array("shahid-ess001-004","isOCROf","shahid-man009-001");
$array3 = array("shahid-ess001-009","isStillOf","shahid-man009-008");

// Looks up the filenames from the MODS record and changes the FILENAMES to PIDS

$array1 = array("hamilton:10","isClipOf","hamilton:22");
$array2 = array("hamilton:11","isOCROf","hamilton:24");
$array3 = array("hamilton:13","isStillOf","hamilton:25");

$together = array( $array1, $array2, $array3 );

$collectionNs = "hamilton";
$relationNs = "hamilton";

$i=0;

foreach ($together as $v) {
	$object_PID = $together[$i][0];
	$relation = $together[$i][1];
	$target_PID = $together[$i][2];
	echo "&lt;".$collectionNs."&lt; &gt;".$together[$i][0]."&gt;<br />";
	echo "&lt;".$relationNs."&lt; &gt;".$together[$i][1]."&gt;<br />";
	echo "&lt;".$collectionNs."&lt; &gt;".$together[$i][2]."&gt;<br />";
    	$i++;
}
echo "done";

/*
$namespace = "hamilton";
$collection = $connection->repository->constructObject($object_PID);
$collection->relationships->add(FEDORA_RELS_EXT_URI, $relation, $target_PID);
*/

// Solr can now search the relatedItem/@displayLabel and relatedItem/location/url
// Export the FoxML files (using curl?) and do the following on them
/* pseudo code
Use Solr to
search mods.relatedItemDisplayLabel for object_filename
	if mods.relatedItemDisplayLabel = object_filename in array
	change array value of object_filename to current_PID

	if mods.mods.relatedItemLocationUrl = target_filename in array
	change array value of target_filename to current_PID

possible pattern for Solr search:
http://dora.hpc.hamilton.edu:8080/solr/select?indent=on&version=2.2&q=
rels.fedora\%3AisMemberOf%3Ahamilton* AND mods.relatedItemDisplayLabel=shahid-ess001-010
&fq=&start=0&rows=10&fl=&qt=standard&wt=standard&explainOther=&hl.fl=
*/

/* new procedure
- Export the MODS files you need to process.
- - Use RIsearch to generate a list of PIDS of records that you want to export.
- - Run cURL to export the MODS files
- Run XSLT on exported MODS files to extract fields you need:
- - PID, relatedItem/@displayLabel, relatedItem/location/url
- Add the relationships to the RELS-EXT of the records in Fedora
*/
// This is the final array of OBJECT_PID + RELATION + TARGET_PID


?>
