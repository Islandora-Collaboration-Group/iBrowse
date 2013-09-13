<?php
function sparql_to_html ($type, $relation, $term, $title, $target, $notes, $count, $date, $dsLabel, $xsl_file, $server, $path, $command, $query) {

	// FORMAT AND ESCAPE THE URL + QUERY
	$search_url_final = $server.$command.urlencode($query);

	// EXECUTE THE iTQL QUERY
	$results = file_get_contents($search_url_final);

// DEBUGGING : WHEN ENABLED, THE FOLLOWING WILL DUMP THE XML RESULTS SO YOU CAN SEE THE SPARQL XML RESULTS
	$results2 = str_replace('<', '&lt;', $results);
	$results2 = str_replace('>', '&gt;<br/>', $results2);
//  echo "Sparql = [". $results2."]";

// ENABLE THE FOLLOWING LINE -- INSTEAD OF THE PREVIOUS ONE -- IF YOU WANT TO SEE JUST THE FIRST 50000 HITS
// echo "Sparql = [". substr($results2, 0, 50000)."]";

	// STORE THE XML RESULTS IN Xml_file
	$Xml_file = "$results";

	// STORE THE XSL FILE NAME IN Xsl_file
	$Xsl_file = "../xslt/". $xsl_file;

	// INITIALIZE A NEW XML OBJECT IN PHP
	$XML = new DOMDocument();

	// LOAD THE XML RESULTS FILE IN THE XML OBJECT
	$XML->loadXML( $Xml_file );

	// INITIALIZE A NEW XSLT PROCESSOR
	$xslt = new XSLTProcessor();

	// SET VARIABLES TO BE AVAILABLD TO THE XSLT
	$xslt->setParameter('','myType',$type);
	$xslt->setParameter('','myRelation',$relation);
	$xslt->setParameter('','myTerm',$term);
	$xslt->setParameter('','myTitle',$title);
	$xslt->setParameter('','myTarget',$target);
	$xslt->setParameter('','myNotes',$notes);
	$xslt->setParameter('','myCount',$count);
	$xslt->setParameter('','myDate',$date);
	$xslt->setParameter('','myDs',$dsLabel);
	$xslt->setParameter('','myServer',$server);
	$xslt->setParameter('','myCustomPath',$path);
	$xslt->setParameter('','myCommand',$command);
	$xslt->setParameter('','myQuery',$query);

	// TRANSFORM THE XML WITH XSLT
	$XSL = new DOMDocument();
	$XSL->load( $Xsl_file);
	$xslt->importStylesheet( $XSL );

	// PRINT THE OUTPUT IN XHTML
	print $xslt->transformToXML( $XML );
}
