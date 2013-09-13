<?php
###############
# icg_repo_stats module
# A Drupal 7 module to compile statistics from an Islandora/Fedora repository
# Developed for the Islandora Collaboration Group
# Updated: 2013-06-21, Peter MacDonald, pmacdona@hamilton.edu
###############

/* IT MAY HELP WHEN DEBUGGING, TO ENABLE THE NEXT TWO LINES TO GET VERBOSE PHP ERROR/WARNING MESSAGES */
//ini_set('display_errors',1);

/* CONFIGURATION
ADD YOUR SERVER TO THE FOLLOWING LIST, OR USE ONE OF THOSE PROVIDED.
THE FOLLOWING SERVERS RETURN RESULTS WITH THIS MODULE - SOME BETTER THAN OTHERS
Not all Fedora repositories are set up at port 8080 and may use difference domain names for Fedora and for the public repository.
ENABLE ONLY ONE AT A TIME
*/
// Fedora Commons Registry https://docs.google.com/spreadsheet/ccc?key=0AnXLMjeiSH_KdElwYi11dGhQTURMZmR1eEdXbDFZMHc&hl=en_US#gid=0
// SITES STILL TO BE TESTED

//define('SERVER_ADDRESS', 'http://collections.dhinitiative.org:8080'); // Hamilton College

//define('SERVER_ADDRESS', 'http://137.149.200.34:8080'); // Islandora Sandbox (Returns results, but blocks viewing objects and datastreams)
//define('SERVER_ADDRESS', 'http://137.149.200.14:8080'); // islandarchives.ca, islandimagined.ca
//define('SERVER_ADDRESS', 'http://digital.grinnell.edu:8080'); // islandarchives.ca, islandimagined.ca
//define('SERVER_ADDRESS', 'http://137.149.200.109:8080'); // UPEI disseminationType searches don't work
//define('SERVER_ADDRESS', 'http://repository.mcmaster.ca'); // McMaster
//define('SERVER_ADDRESS', 'http://dg02.vassar.edu:8080'); // dg02.vassar.edu
//define('SERVER_ADDRESS', 'http://repository.library.brown.edu:8080'); // Brown

// Colorado College : Digital Archives of Colorado College - no collections come up but isMemberOf works
// Uses custom relationships as in coal:hasThumbnail, coal:hasJP2, coal:hasSWF
// COAL uses a PremisEvent datastream; some records need HTTP authentication
//define('SERVER_ADDRESS', 'http://129.19.154.191:80');

//define('SERVER_ADDRESS', 'http://dar.aucegypt.edu:8080'); // http://dar.aucegypt.edu:8080/jspui/handle/10526/52

// North Texas State: uses info:fedora/fedora-system:def/view#isVolatile, no custom ontology
//define('SERVER_ADDRESS', 'http://txcdk-v17.unt.edu:8080'); // North Texas State (viewing datasteams is blocked)
// no define('SERVER_ADDRESS', 'http://fedora.ats.msu.edu');
// no define('SERVER_ADDRESS', 'http://fedora-prod02.lib.virginia.edu:8080');
// no define('SERVER_ADDRESS', 'http://mirc.sc.edu:8080'); // U-So.Carolina - Moving Image Research Collection
// no define('SERVER_ADDRESS', 'http://syn.lib.umanitoba.ca:8080'); // Umanitoba
// no define('SERVER_ADDRESS', 'http://dl.tufts.edu:8080'); //Tufts Digital Library
// x define('SERVER_ADDRESS', 'http://oreo.grainger.uiuc.edu:8080'); // University of Illinois Urbana-Champaign
// x define('SERVER_ADDRESS', 'http://digital.unh.edu:8080');  // New Hampshire
// No define('SERVER_ADDRESS', 'http://openvault.wgbh.org:8080'); // WGBH
//define('SERVER_ADDRESS', 'http://62.204.194.45:8080'); // Repositorio de la UNED (large db, no collection objects)
// So so define('SERVER_ADDRESS', 'http://150.145.48.41:80'); // BESS

// CREATE VARIABLES FROM URL PARAMETERS
if(isset($_GET["icg_submit"])) {
	$icg_submit = strtolower($_GET['icg_submit']);
} else {
	$icg_submit = "itql";
}
if(isset($_GET['icg_stype'])) $icg_type = $_GET['icg_stype'];
if(isset($_GET['icg_sterm'])) $icg_term = $_GET['icg_sterm'];
if(isset($_GET['icg_sdate'])) $icg_date = $_GET['icg_sdate'].'T00:00:00Z';
if(isset($_GET['icg_starget'])) $icg_target = $_GET['icg_starget'];
if(isset($_GET['icg_server'])) $icg_server = $_GET['icg_server'];
if(isset($_GET['icg_limit'])) {
			$icg_limit = $_GET['icg_limit'];
		} else {
			$icg_limit = "20000";
		}

/* DEFINE PHP CONSTANTS */

// Define the path to your custom modules folder
define('CUSTOM_MODULE_PATH', '/sites/all/modules/custom/');

// If $submit is not "submit" use its value as the query language parameter
if($icg_submit == "submit") {
	define('SEARCH_COMMAND', '/fedora/risearch?type=tuples&flush=true&lang=itql&format=sparql&query=');
} else {
	define('SEARCH_COMMAND', '/fedora/risearch?type=tuples&flush=true&lang='.$icg_submit.'&format=sparql&query=');
}

// Define the statement that generates a count in the iTQL query language
define('MULGARA_COUNT', '$k0 <http://mulgara.org/mulgara#occursMoreThan> \'0.0\'^^<http://www.w3.org/2001/XMLSchema#double>');

include 'icg_sparql_to_html.php';

// BYPASS icg_server variable FOR ADDITIONAL SERVER ADDRESS TESTING
//$icg_server = SERVER_ADDRESS;

switch ($icg_type) {

case "collection" :
$icg_relation = "isMemberOfCollection";
$icg_term = "info:fedora/fedora-system:def/relations-external#isMemberOfCollection";
$icg_title = "Top-level Collections (using \"".$icg_relation."\" relationship)";
$icg_notes = "<ul>
				<li>Collection Objects = Object - isMemberOfCollection - islandora:root</li>
				<li>Child Objects = Object - isMemberOfCollection - a Collection Object</li>
				<li>Constituents = Data Object - isMemberOf - Data Object</li>
			</ul>";
$icg_count = "Hyperlinked columns: \"Collection Objects\" and \"# of Child Objects\"";
$icg_xsl_file = "icg_is_member_of_collection.xsl";
$icg_query = '
select $collCModel $colltitle
count(
	select $objectPID
	from <#ri>
	where walk($objectPID <'.$icg_term.'> $collCModel
		and $work <'.$icg_term.'> $objectPID)
	and $work <fedora-rels-ext:isMemberOf> $collCModel)
count(
	select $work
	from <#ri>
	where walk($objectPID <'.$icg_term.'> $collCModel
		and $work <fedora-rels-ext:isMemberOfCollection> $objectPID))
count(
	select $part
	from <#ri>
	where walk($objectPID <'.$icg_term.'> $collCModel
	and $work <fedora-rels-ext:isMemberOfCollection> $objectPID)
	and $part <fedora-rels-ext:isMemberOf> $work)
from <#ri>
where ($collCModel <'.$icg_term.'> <info:fedora/islandora:root>
and $collCModel <dc:title> $colltitle
and $collCModel <fedora-model:state> <fedora-model:Active>)
order by $colltitle
';
break;

case "collection_inc" :
$icg_title = "Child Objects of \"".$icg_target."\"";
$icg_notes = "The \"isMemberOfCollection\" relationship is used to assert that a Fedora Object is a direct child of a specific collection.<br/>
Warning: Not all Source Objects will have constitutent Parts.";
//$icg_term = "fedora-rels-ext:isMemberOfCollection";
//$icg_target = "info:fedora/hamilton:shahid";
$icg_count = "Hyperlinked columns: \"Source Object PID\" and \"Target Object PID\".<br/>
Click \"Related Parts\" to see all Fedora Objects that are constituent parts of the PID to its left.";
$icg_xsl_file = "icg_is_member_of_collection_inc.xsl";
$icg_query = '
select $object $relation $target $title
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> <'.$icg_target.'>
and $object <dc:title> $title
order by $object
';
break;

case "collection2" :
$icg_relation = "isMemberOf";
$icg_term = "info:fedora/fedora-system:def/relations-external#isMemberOf";
$icg_title = "Top-level Collections (a depricated use of \"".$icg_relation."\")";
$icg_notes = "DEPRICATED USAGE: This use of the \"isMemberOf\" relationship to relate top-level Collection Objects to &lt;islandora:root&gt; was once common practice, but it is now preferred to use the relationship \"isMemberOfCollection\" for this purpose. Fortunately, Islandora 7 continues to recognize both.<br/>
PREFERRED USAGE: The relationship \"isMemberOf\" should be used only to relate one Data Object to another Data Object. (See \"Compound Objects\".)";
$icg_count = "Hyperlinked columns: \"Source Object PID\" and \"Target Object PID\".";
$icg_xsl_file = "icg_is_member_of.xsl";
$icg_query = '
select $collCModel $colltitle
count(
	select $objectPID
	from <#ri>
	where walk($objectPID <fedora-rels-ext:isMemberOfCollection> $collCModel
		and $work <fedora-rels-ext:isMemberOfCollection> $objectPID)
	and $work <'.$icg_term.'> $collCModel)
count(
	select $work
	from <#ri>
	where walk($objectPID <'.$icg_term.'> $collCModel
		and $work <'.$icg_term.'> $objectPID)
	and $work <'.$icg_term.'> $collCModel)
count(
	select $part
	from <#ri>
	where walk($objectPID <'.$icg_term.'>  $collCModel
	and $work <'.$icg_term.'>  $objectPID)
	and $part <'.$icg_term.'> $work)
from <#ri>
where ($collCModel <'.$icg_term.'> <info:fedora/islandora:root>
and $collCModel <dc:title> $colltitle
and $collCModel <fedora-model:state> <fedora-model:Active>)
order by $colltitle
limit '.$icg_limit.'
offset 0
';
break;

case "collection2_inc" :
$icg_title = "isMemberOf";
$icg_notes = "The relationship \"isMemberOf\" should be used only to relate one Data Object to another Data Object.<br/>
DEPRICATED USAGE: The use of the \"isMemberOf\" relationship for top-level Collection Objects has been depricated, but because it was once common practice, backward compatibility has been retained by Islandora (as of Islandora 7).";
$icg_count = "Hyperlinked columns: \"Subject Object PID\" and \"Target Object PID\".";
//$icg_term = [comes from URL]
//$icg_target =  [comes from URL]
$icg_xsl_file = "icg_is_member_of_inc.xsl";
$icg_query = '
select $object $relation $target $title
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> <'.$icg_target.'>
and $object <dc:title> $title
order by $object
';
break;

case "member" :
$icg_relation = "isMemberOf";
$icg_term = "info:fedora/fedora-system:def/relations-external#isMemberOf";
$icg_title = "Compound Objects (using the \"isMemberOf\" Relationship)";
$icg_notes = "This is a list of the \"isMemberOf\" relationships used in this repository and how many Fedora Objects subscribe to each one.<br/>
\"isMemberOf\" is a refinement of the generic part/whole relationship that defines a set membership relationship between fedora objects. The subject is a fedora object representing a member of a set and the predicate is a fedora object representing a whole set of which the subject is a member.  The member can be separated from the set and still stand alone as an object in its own right.";
$icg_count = "Hyperlinks: Click on the number in the \"Count\" column to see the Fedora Objects using this relationship.";
$icg_xsl_file = "icg_relations.xsl";
$icg_query = '
select $target $relation $title
count(
select $object
from <#ri>
where $object <'.$icg_term.'> $target
or $object $relation $target)
from <#ri>
where $object $relation $target
and $target <dc:title> $title
having '.MULGARA_COUNT.'
';
break;

case "member_inc" :
$icg_title = "isMemberOf";
$icg_notes = "The relationship \"isMemberOf\" should be used only to relate one Data Object to another Data Object.<br/>
DEPRICATED USAGE: The use of the \"isMemberOf\" relationship for top-level Collection Objects has been depricated, but because it was once common practice, backward compatibility has been retained by Islandora (as of Islandora 7).";
$icg_count = "Hyperlinked columns: \"Subject Object PID\" and \"Target Object PID\".";
//$icg_term = [comes from URL]
//$icg_target =  [comes from URL]
$icg_xsl_file = "icg_is_member_of_inc.xsl";
$icg_query = '
select $object $relation $target $title
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> <'.$icg_target.'>
and $object <dc:title> $title
order by $object
';
break;

case "cmodel" :
$icg_relation = "hasModel";
$icg_term = "info:fedora/fedora-system:def/model#hasModel";
$icg_title = "Content Models  : \"".$icg_relation."\" relationship";
$icg_notes = "This is a list of the Content Models used in this repository and how many Fedora Objects subscribe to each one.<br/><br/>
DEFINITION: Content models represent classes of objects from individual media objects to aggregations of content. A content model describes...
<ul>
<li>datastream composition, including numbers and kinds of files that make up an object, allowable formats of those files, where the files are required or optional, if the datastreams have cardinality constraints, and what kind of semantic identifiers are used for each datastream; </li>
<li>relationships to other content models, such as parent/child relationships between models; and</li>
<li>optional linkages to behaviors, if used. Fedora objects assert a relationship to a CModel object from which it will acquire the compatible services mentioned above</li>
</ul>";
$icg_count = "Hyperlinked Columns: \"Count\" and \"Content Model PID\".";
$icg_xsl_file = "icg_has_model.xsl";
$icg_query = '
select $target $title
count(
select $object
from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where $object <'.$icg_term.'> $target
and $target <dc:title> $title
having '.MULGARA_COUNT.'
';
break;

case "cmodel_inc":
//$icg_term = [comes from the URL]
//$icg_target = [comes from the URL]
$icg_title = "Content Model : \"".$icg_target."\"";
$icg_notes = "This table shows all Fedora Objects that subscribe to the \"".$icg_target."\" Content Model.";
$icg_count = "Hyperlinked Columns: \"Fedora Object PID\".";
$icg_xsl_file = "icg_has_model_inc.xsl";
$icg_query = 'select $object $relation $target
from <#ri>
where $object <fedora-model:hasModel> <info:fedora/'.$icg_target.'>
and $object $relation $target';
break;
/*
$icg_query = 'select $object $relation $target $title $tartitle
from <#ri>
where $object <fedora-model:hasModel> <info:fedora/'.$icg_target.'>
and $object $relation $target
and $object <dc:title> $title
and $target <dc:title> $tartitle
order by $title';
*/
case "service" :
$icg_relation = "hasService";
$icg_term = "info:fedora/fedora-system:def/model#hasService";
$icg_title = "hasService";
//$icg_notes = "When a Content Model (CModel) asserts this relationship to a Service Definition (SDef) it is saying that the operations defined in the SDef apply to all Fedora objects that subscribe to that CModel. (Triple: CModel > hasService > SDef) ";
$icg_notes = '<p style="font-weight:bold">Description of Fedora Service Relationships:</p>
				<ol>
					<li><b>hasService</b> = When a Content Model (CModel) asserts this relationship
						to a Service Definition (SDef) it is saying that the operations defined in
						the SDef apply to all Fedora objects that subscribe to that CModel. (Triple:
						CModel > hasService > SDef) </li>
					<li><b>isContractorOf</b> = When a Fedora Service Definition (SDef) asserts this
						relationship to a Content Model (CModel) it is saying that the operations
						the SDef defines will apply to all Fedora objects that subscribe to that
						CModel. (Triple: SDef > isContractorof > CModel) </li>
					<li><b>isDeploymentOf</b> = When a Service Deployment Object (sDep) asserts this
						relationship to a Service Definitions (SDef) it is saying that it is able to
						perform the service methods described by that SDef. An SDep object is
						related to a SDef in the sense that it defines a particular concrete
						implementation of the abstract operations defined in a SDef object. (Triple:
						SDep > isDeploymentOf > SDef) </li>
				</ol>';
$icg_count = "Hyperlinked Column: \"Count.\"";
$icg_xsl_file = "icg_relations.xsl";
$icg_query = '
select $target $relation $title
count(
select $object
from <#ri>
where $object <fedora-rels-ext:isMemberOfCollection> $target
or $object $relation $target)
from <#ri>
where $object $relation $target
and $target <dc:title> $title
having '.MULGARA_COUNT.'
order by $relation
';
break;

case "contractor" :
$icg_relation = "isContractorOf";
$icg_term = "info:fedora/fedora-system:def/model#isContractorOf";
$icg_title = "isContractorOf";
$icg_notes = '<p style="font-weight:bold">Description of Fedora Service Relationships:</p>
				<ol>
					<li><b>hasService</b> = When a Content Model (CModel) asserts this relationship
						to a Service Definition (SDef) it is saying that the operations defined in
						the SDef apply to all Fedora objects that subscribe to that CModel. (Triple:
						CModel > hasService > SDef) </li>
					<li><b>isContractorOf</b> = When a Fedora Service Definition (SDef) asserts this
						relationship to a Content Model (CModel) it is saying that the operations
						the SDef defines will apply to all Fedora objects that subscribe to that
						CModel. (Triple: SDef > isContractorof > CModel) </li>
					<li><b>isDeploymentOf</b> = When a Service Deployment Object (sDep) asserts this
						relationship to a Service Definitions (SDef) it is saying that it is able to
						perform the service methods described by that SDef. An SDep object is
						related to a SDef in the sense that it defines a particular concrete
						implementation of the abstract operations defined in a SDef object. (Triple:
						SDep > isDeploymentOf > SDef) </li>
				</ol>';
$icg_count = "Hyperlinked Column: \"Count.\"";
$icg_xsl_file = "icg_relations.xsl";
$icg_query = '
select $target $relation $title
count(
select $object
from <#ri>
where $object <fedora-rels-ext:isMemberOfCollection> $target
or $object $relation $target)
from <#ri>
where $object $relation $target
and $target <dc:title> $title
having '.MULGARA_COUNT.'
order by $relation
';
break;

case "deployment" :
$icg_relation = "isDeploymentOf";
$icg_term = "info:fedora/fedora-system:def/model#isDeploymentOf";
$icg_title = "isDeploymentOf";
$icg_notes = '<p style="font-weight:bold">Description of Fedora Service Relationships:</p>
				<ol>
					<li><b>hasService</b> = When a Content Model (CModel) asserts this relationship
						to a Service Definition (SDef) it is saying that the operations defined in
						the SDef apply to all Fedora objects that subscribe to that CModel. (Triple:
						CModel > hasService > SDef) </li>
					<li><b>isContractorOf</b> = When a Fedora Service Definition (SDef) asserts this
						relationship to a Content Model (CModel) it is saying that the operations
						the SDef defines will apply to all Fedora objects that subscribe to that
						CModel. (Triple: SDef > isContractorof > CModel) </li>
					<li><b>isDeploymentOf</b> = When a Service Deployment Object (sDep) asserts this
						relationship to a Service Definitions (SDef) it is saying that it is able to
						perform the service methods described by that SDef. An SDep object is
						related to a SDef in the sense that it defines a particular concrete
						implementation of the abstract operations defined in a SDef object. (Triple:
						SDep > isDeploymentOf > SDef) </li>
				</ol>';
$icg_count = "Hyperlinked Column: \"Count.\"";
$icg_xsl_file = "icg_relations.xsl";
$icg_query = '
select $target $relation $title
count(
select $object
from <#ri>
where $object <fedora-rels-ext:isMemberOfCollection> $target
or $object $relation $target)
from <#ri>
where $object $relation $target
and $target <dc:title> $title
having '.MULGARA_COUNT.'
order by $relation
';
break;

case "services_inc" :
$icg_title = $icg_term;
$icg_notes = '<p style="font-weight:bold">Description of Fedora Service Relationships:</p>
				<ol>
					<li><b>hasService</b> = When a Content Model (CModel) asserts this relationship
						to a Service Definition (SDef) it is saying that the operations defined in
						the SDef apply to all Fedora objects that subscribe to that CModel. (Triple:
						CModel > hasService > SDef) </li>
					<li><b>isContractorOf</b> = When a Fedora Service Definition (SDef) asserts this
						relationship to a Content Model (CModel) it is saying that the operations
						the SDef defines will apply to all Fedora objects that subscribe to that
						CModel. (Triple: SDef > isContractorof > CModel) </li>
					<li><b>isDeploymentOf</b> = When a Service Deployment Object (sDep) asserts this
						relationship to a Service Definitions (SDef) it is saying that it is able to
						perform the service methods described by that SDef. An SDep object is
						related to a SDef in the sense that it defines a particular concrete
						implementation of the abstract operations defined in a SDef object. (Triple:
						SDep > isDeploymentOf > SDef) </li>
				</ol>';
$icg_count = "Hyperlinked Columns: \"Source Object PID\" and \"Target Object PID.\"";
$icg_xsl_file = "icg_services_inc.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> <'.$icg_target.'>
order by $object
';
break;

case "method" :
$icg_relation= "definesMethod";
$icg_term = "info:fedora/fedora-system:def/model#definesMethod";
$icg_title = $icg_relation;
$icg_notes = "The \"definesMethod\" relationships is followed by a literal value representing a method used by that Fedora Object.";
$icg_count = "Hyperlinked Columns: \"Fedora Object.\"";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where  $object $relation $target
and $object <'.$icg_term.'> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;

case "page" :
$icg_relation = "isPageNumber";
$icg_term = "info:fedora/fedora-system:def/relations-external#isPageNumber";
$icg_title = $icg_relation;
$icg_notes = "The \"isPageNumber\" relationships is followed by a literal value representing the page number of that Fedora Object.";
$icg_count = "Hyperlinked Columns: \"Fedora Object.\"";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where  $object $relation $target
and $object <'.$icg_term.'> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;

case "rel_all" :
$icg_title = "All Fedora Relationships";
$icg_notes = 'Fedora has certain built-in Relationships to relate objects to each other, content models, or services.';
$icg_count = "To view all instances of a particular Relationship, click it.";
$icg_xsl_file = "icg_rel_all.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:state> <fedora-model:Active>
and $object $relation $target
order by $relation
';
break;

case "rel_fed_rels_int" :
$icg_title = "Fedora RELS-INT Relationships";
$icg_notes = 'Fedora has certain built-in Relationships to relate objects to each other, content models, or services.';
$icg_count = "To view all instances of a particular Relationship, click it.";
$icg_xsl_file = "icg_relations_internal.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:state> <fedora-model:Active>
and $object $relation $target
order by $relation
limit '.$icg_limit.'
offset 0
';
break;
/* reduce the "limit" parameter to improve performance */

case "fedora-view" :
$icg_title = "Fedora View Relationships";
$icg_notes = 'Fedora has certain built-in Relationships to relate objects to each other, content models, or services.';
$icg_count = "To view all instances of a particular Relationship, click it.";
$icg_xsl_file = "icg_fedora-view.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:state> <fedora-model:Active>
and $object $relation $target
order by $relation
limit '.$icg_limit.'
offset 0
';
break;
/* reduce the "limit" parameter to improve performance */

/* working but fragile
case "rel_islandora" :
$icg_title = "Islandora Relationships";
$icg_notes = 'Islandora has added some Relationships to provide more fine-grain relationships between objects, permissions and processes.';
$icg_count = "To view all instances of a particular Relationship, click it.";
$icg_xsl_file = "icg_relations_islandora.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:state> <fedora-model:Active>
and $object $relation $target
order by $relation
limit '.$icg_limit.'
offset 20000
';
break;
*/

/* reduce the "limit" parameter to improve performance */

case "rel_islandora" :
$icg_title = "Islandora Relationship: ".$icg_term;
$icg_term = "http://islandora.ca/ontology/relsext#".$icg_term;
$icg_notes = "Islandora has added some Relationships to provide more fine-grain relationships between objects, permissions and processes.)";
$icg_count = "The Object column shows the PID of the Fedora Object and the Target column shows the value of the <dc:identifier> element(s).";
//$icg_xsl_file = "icg_relations_islandora.xsl";
$icg_xsl_file = "icg_relations_inc.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;

case "rel_local" :
$icg_title = "Discover all Hamilton College Custom Relationships";
$icg_notes = 'An Islandora Repository can be set up to use ontologies of relationships beyond those provided by Fedora or Islandora.';
$icg_count = "Hyperlinked column: To view all instances of a particular Relationship, click its name";
$icg_xsl_file = "icg_relations_local.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:state> <fedora-model:Active>
and $object $relation $target
order by $relation
limit '.$icg_limit.'
offset 0
';
break;
/* reduce the "limit" parameter to improve performance */

case "rel_custom" :
$icg_title = "Custom Relationships";
$icg_notes = 'An Islandora Repository can be set up to use ontologies of relationships beyond those provided by Fedora or Islandora.';
$icg_count = "Hyperlinked column: To view all instances of a particular Relationship, click its name";
$icg_xsl_file = "icg_relations_custom.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:state> <fedora-model:Active>
and $object $relation $target
order by $relation
limit '.$icg_limit.'
offset 0
';
break;
/* reduce the "limit" parameter to improve performance */

case "mtype" :
$icg_relation = "mimeType";
$icg_term = "info:fedora/fedora-system:def/view#mimeType";
$icg_title = $icg_relation;
$icg_notes = "This table is a list of the MIME Types (media types) used in this repository and the number of datastreams that use each one. (Every datastream must specify a MIME Type for its content.)";
$icg_count = "Hyperlinked Column: \"Instances.\"";
$icg_xsl_file = "icg_mime_types.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where $object <'.$icg_term.'> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "mtype_image" :
include 'icg_sparql_to_svg.php';
$icg_term = "image";
$icg_title = "Image MIME Types";
$icg_notes = "notes?";
$icg_count = "To view all datastreams that assert the MIME Type named in the \"MIME Media Types\" column, click the number in the \"Count\" column.";
$icg_xsl_file = "icg_sparql_to_svg.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <fedora-view:mimeType> $target)
from <#ri>
where $object <fedora-view:mimeType> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "mtype_video" :
include 'icg_sparql_to_svg.php';
$icg_term = "video";
$icg_title = "Video MIME Types";
$icg_notes = "notes?";
$icg_count = "To view all datastreams that assert the MIME Type named in the \"MIME Media Types\" column, click the number in the \"Count\" column.";
$icg_xsl_file = "icg_sparql_to_svg.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <fedora-view:mimeType> $target)
from <#ri>
where $object <fedora-view:mimeType> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "mtype_audio" :
include 'icg_sparql_to_svg.php';
$icg_term = "audio";
$icg_title = "Audio MIME Types";
$icg_notes = "notes?";
$icg_count = "To view all datastreams that assert the MIME Type named in the \"MIME Media Types\" column, click the number in the \"Count\" column.";
$icg_xsl_file = "icg_sparql_to_svg.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <fedora-view:mimeType> $target)
from <#ri>
where $object <fedora-view:mimeType> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "mtype_application" :
include 'icg_sparql_to_svg.php';
$icg_term = "application";
$icg_title = "Application MIME Types";
$icg_notes = "notes?";
$icg_count = "To view all datastreams that assert the MIME Type named in the \"MIME Media Types\" column, click the number in the \"Count\" column.";
$icg_xsl_file = "icg_sparql_to_svg.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <fedora-view:mimeType> $target)
from <#ri>
where $object <fedora-view:mimeType> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "mtype_text" :
include 'icg_sparql_to_svg.php';
$icg_title = "Text MIME Types";
$icg_term = "text";
$icg_notes = " (excludes all XML datastreams): \"".$icg_type."\"";
$icg_count = "To view all datastreams that assert the MIME Type named in the \"MIME Media Types\" column, click the number in the \"Count\" column.";
$icg_xsl_file = "icg_sparql_to_svg.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <fedora-view:mimeType> $target)
from <#ri>
where $object <fedora-view:mimeType> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "mtype_inc" :
$icg_title = "MIME Type : \"".$icg_term."\"";
$icg_notes = "Every datastream in a Fedora Object must be associated with a MIME Type (also known as a Media Type).";
$icg_count = "Hyperlinked Column: The \"Fedora Object PID\" column has links to objects with at least one datastream with the MIME Media Type \"".$icg_term.".\"";
$icg_xsl_file = "icg_mime_types_inc.xsl";
$icg_query = '
select $object $relation $target
count(select $object
from <#ri>
where $object <fedora-view:mimeType> \''.$icg_term.'\')
from <#ri>
where $object <fedora-view:mimeType> $target
and $object $relation \''.$icg_term.'\'
having '.MULGARA_COUNT.'
order by $object asc
';
break;

case "dtype" :
$icg_relation = "disseminationType";
$icg_term = "info:fedora/fedora-system:def/view#disseminationType";
$icg_title = "Datastream IDs : \"".$icg_type."\"";
$icg_notes = "Every Datastream must have an ID. This table is a list of all the Datastream IDs (DsIDs) used in this repository and the number of datastreams that use each one.";
$icg_count = "Hyperlinked Column: \"Instances.\"";
$icg_xsl_file = "icg_dissemination_types.xsl";
$icg_query = '
select $target
count(select $object
from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where $object <'.$icg_term.'> $target
having '.MULGARA_COUNT.'
order by $target
';
break;

case "dtype_inc" :
//$icg_term = "fedora-view:disseminationType";
$icg_title = "All \"".$icg_term."\" Datastreams.";
$icg_notes = "Column 1 gives the PID of Fedora Objects that have at least one \"".$icg_term."\" datastream.";
$icg_count = "Hyperlinked Column: Click on the \"Fedora Object PID\" to see all its datastreams.";
$icg_xsl_file = "icg_dissemination_types_inc.xsl";
$icg_query = '
select $object $relation $target
from <#ri>
where $object <fedora-model:hasModel> <info:fedora/fedora-system:FedoraObject-3.0>
and $object $relation $target
and $object <fedora-model:state> <fedora-model:Active>
order by $object';
break;

case "relations_inc" :
//$icg_term = "info:fedora/fedora-system:def/model#ownerId";
$icg_title = "All instances of \"".$icg_term."\".";
$icg_xsl_file = "icg_relations_inc.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where  $object $relation $target
and $object <'.$icg_term.'> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;

/* suppressed - if used unsuppress it
case "properties" :
$icg_title = "1es. Fedora Properties search";
$icg_notes = "A Fedora object may have an ownerID, but it is not required";
$icg_count = "The Objects in the Object column have the ownerId specified in the Target column.";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <'.$icg_term.'> $target)
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;
*/

/* suppressed - if used unsuppress it
case "properties_inc" :
$icg_title = "properties_inc. Fedora Properties secondary search";
$icg_notes = "A Fedora object may have an ownerID, but it is not required";
$icg_count = "The Objects in the Object column have the ownerId specified in the Target column.";
$icg_xsl_file = "icg_properties.xsl";
//$icg_target = '003';
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <'.$icg_term.'> \''.$icg_target.'\')
from <#ri>
where $object $relation $target
and $object <'.$icg_term.'> \''.$icg_target.'\'
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;
*/

case "inactive" :
$icg_relation = "inactive";
$icg_term = "fedora-model:inactive";
$icg_title = $icg_relation;
$icg_notes = 'The state a Fedora Object can be "Active" or "Inactive" or "Deleted"';
$icg_count = "The Datastreams in the Object column are all in Fedora Objects that are set as \"Inactive.\"";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target
count(select $object from <#ri>
where $object <fedora-model:state> <fedora-model:Inactive>)
from <#ri>
where $object <fedora-model:state> $target
and $object $relation <fedora-model:Inactive>
having '.MULGARA_COUNT.'
order by $object
';
break;

case "deleted" :
$icg_relation = "deleted";
$icg_term = "fedora-model:deleted";
$icg_title = $icg_relation;
$icg_notes = 'The state of a Fedora Object can be "Active" or "Inactive" or "Deleted"';
$icg_count = "The Datastreams in the Object column are all in Fedora Objects that are set as \"Deleted.\"";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <fedora-model:state> $target
and $object <fedora-model:state> <fedora-model:Deleted>)
from <#ri>
where $object <fedora-model:state> $target
and $object  $relation <fedora-model:Deleted>
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $object
';
break;

case "label" :
$icg_relation = "label";
$icg_term = "fedora-model:label";
$icg_title = $icg_relation;
$icg_notes = "Fedora Objects have a system property named \"label\" whose value is a literal (i.e., a text string) that identifies the object. It is usually created at the time of ingest but can be edited later.";
$icg_count = "To see the Fedora Object, click its PID in the first column. [NOTES: Some duplication of PIDs is normal. Also, some labels may be empty. ]";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
from <#ri>
where $object $relation $target
and $object <fedora-model:label> $target
and $object <dc:title> $title
order by $target
limit '.$icg_limit.'
offset 0
';
break;

case "owner" :
$icg_relation = "ownerId";
$icg_term = "fedora-model:ownerId";
$icg_title = $icg_relation;
$icg_notes = "The ownerID is a property of a Fedora digital object which identifies the 'owner' of the object for security purposes. At present an object can have only a single owner though it is hoped that future versions of Fedora will support multiple, simultaneous owners. The ownerID may be created at the time of ingest but can be edited later.";
$icg_count = "To see the Fedora Object, click its PID in the first column. [NOTES: Some ownerIds may be empty, since they are optional. ]";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
from <#ri>
where $object $relation $target
and $object <fedora-model:ownerId> $target
and $object <dc:title> $title
order by $target
limit '.$icg_limit.'
offset 0
';
break;

/* with count() which is not really needed - it slows it way down
select $object $relation $target $title
count(select $object from <#ri>
where $object <fedora-model:ownerId> $target)
from <#ri>
where $object $relation $target
and $object <fedora-model:ownerId> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
limit '.$icg_limit.'
offset 0
';

*/

/*  not even close to working yet */
case "lastPID" :
$icg_term = 'fedora-model:???lastPID';
$icg_title = $icg_relation;
$icg_term = "lastPID";
$icg_notes = "The ownerID is a property of a Fedora digital object which identifies the 'owner' of the object for security purposes. At present an object can have only a single owner though it is hoped that future versions of Fedora will support multiple, simultaneous owners. The ownerID may be created at the time of ingest but can be edited later.";
$icg_count = "To see the Fedora Object, click its PID in the first column. [NOTES: Some ownerIds may be empty, since they are optional. ]";
$icg_xsl_file = "icg_properties.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <fedora-model:PID> $target)
from <#ri>
where $object $relation $target
and $object <fedora-model:PI> $target
and $object <dc:title> $title
having '.MULGARA_COUNT.'
order by $target
';
break;

case "cdate" :
$icg_relation = "createdDate";
$icg_term = "fedora-view:createdDate";
$icg_title = "createdDate after";
$icg_notes = "Fedora Objects are stamped with the date they were created.";
$icg_count = "Hyperlinked Column: \"Fedora Object PID.\"";
$icg_xsl_file = "icg_properties.xsl";
//$icg_term = "createdDate";
//$icg_date = "2012-04-01T02:18:59.979Z";
$icg_query = '
select $object $relation $title $target
from <#ri>
where $object <fedora-model:createdDate> $target
and $target <mulgara:after> \'' . $icg_date .'\'^^<xml-schema:dateTime> in <#xsd>
and $object $relation $target
and $object <dc:title> $title
order by $target
';
break;

case "mdate" :
$icg_relation = "lastModifiedDate";
$icg_term = "fedora-view:lastModifiedDate";
$icg_title = "lastModifiedDate after";
$icg_notes = "Fedora Objects are stamped with the most recent date that any of its datastreams was modified.";
$icg_count = "Hyperlinked Column: \"Fedora Object PID.\"";
if($icg_submit == "submit") {
$icg_xsl_file = "icg_dates.xsl";
$icg_query = '
select $object $date $title
count(select $object $date from <#ri>
where $object <fedora-view:lastModifiedDate> $date
and $date <mulgara:after> \'' . $icg_date .'\'^^<xml-schema:dateTime> in <#xsd>)
from <#ri>
where $object <fedora-view:lastModifiedDate> $date
and $date <mulgara:after> \'' . $icg_date .'\'^^<xml-schema:dateTime> in <#xsd>
and $object <dc:title> $title
having '.MULGARA_COUNT;
} elseif ($icg_submit == "sparql") {
$icg_xsl_file = "icg_dates.xsl";
$icg_query = '
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX fedora-view: <info:fedora/fedora-system:def/view#>
PREFIX fedora-model: <info:fedora/fedora-system:def/model#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT ?object ?date ?title
FROM <#ri>
WHERE {
	?object dc:title ?title .
	?object fedora-view:lastModifiedDate ?date .
	FILTER(?date > xsd:dateTime("'.$icg_date.'"))
}';
} else { echo "bad icg_submit";}
break;

/*
select $object $relation $title $target
from <#ri>
where $object <fedora-view:lastModifiedDate> $target
and $target <mulgara:after> \'' . $icg_date .'\'^^<xml-schema:dateTime> in <#xsd>
and $object $relation $target
and $object <dc:title> $title
order by $target
';
*/

case "dublin_core" :
$icg_title = $icg_term;
//$icg_term =
$icg_notes = "Simple Dublin Core is used mostly for Fedora internal management purposes.<br/>
The DC elements are often populated at ingest by a crosswalk process from another metadata datastream, e.g., MODS.";
$icg_count = "Hyperlinked Column: \"Fedora Object PID\"";
$icg_xsl_file = "icg_dublin_core.xsl";
$icg_query = '
select $object $relation $target $title
count(select $object from <#ri>
where $object <dc:'.$icg_term.'> $target)
from <#ri>
where $object <dc:'.$icg_term.'> $target
and $object <dc:title> $title
and $object $relation $target
having '.MULGARA_COUNT.'
order by $target
';
break;

default:
echo "bad query";
echo "bad icg_url = [". $icg_query . "]";
break;
}

/*
echo "myDescription = [".$icg_notes."]<br />";
*/

/* DURING DEBUGGING, ENABLE ALL OR SOME OF THE FOLLOWING */
/*
echo "<br/>myType = [".$icg_type."]<br/><br />";
echo "myTitle = [".$icg_title."]<br/><br />";
echo "myTerm = [".$icg_term."]<br/><br />";
echo "myDate = [".$icg_date."]<br/><br />";
echo "myTarget = [".$icg_target."]<br/><br/>";
echo "myXSL = [".$icg_xsl_file."]<br/><br />";
*/
/*
echo "myDate = [".$icg_date."]<br/><br />";
echo "icg_notes = [".$icg_notes."]<br/><br />";
echo "icg_ds = [".$icg_dsLabel."]<br/><br />";
*/

/*
	$icg_query_raw = str_replace('<', '&lt;', $icg_query);
	$icg_query_raw2 = str_replace('>', '&gt;<br/>', $icg_query_raw);
  echo "Query = [".$icg_query_raw2."]";
*/
/* RUN THE sparql_to_html FUNCTION WHICH IS DEFINED IN icg_sparql_to_html.php */
sparql_to_html ($icg_type, $icg_relation, $icg_term, $icg_title, $icg_target, $icg_notes, $icg_count, $icg_date, $icg_dsLabel, $icg_xsl_file, $icg_server, CUSTOM_MODULE_PATH, SEARCH_COMMAND, $icg_query );

/* RUN THE sparql_to_svg FUNCTION WHICH IS DEFINED IN icg_sparql_to_svg.php */
/* TRANSFORMS THE SPARQL RESULTS TO XML THAT IS READABLE BY chart.xslt */

switch ($icg_type) {
	case "mtype_image" :
	case "mtype_video" :
	case "mtype_audio" :
	case "mtype_application" :
	case "mtype_text" :

$chart_xml = sparql_to_svg ($icg_type, $icg_term, $icg_title, $icg_xsl_file, $icg_server, SEARCH_COMMAND, $icg_query );

// DEBUGGING : WHEN ENABLED, THE FOLLOWING WILL DUMP THE XML RESULTS SO YOU CAN SEE THE SPARQL XML RESULTS
//	$chart_xml2 = str_replace('<', '&lt;', $chart_xml);
//	$chart_xml2 = str_replace('>', '&gt;<br/>', $chart_xml2);
//    echo "chart_xml2 = [". $chart_xml2."]";

/* TRANSFORM THE CHART.XML TO A CHART */

transform($chart_xml);
break;

default:
//echo "icg_type = NOT SVG";exit;

}

?>
