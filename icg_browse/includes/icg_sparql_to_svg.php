<?php
function sparql_to_svg ($type, $term, $title, $xsl_file, $server, $command, $query) {

// FORMAT AND ESCAPE THE URL + QUERY
$search_url_final = $server.$command.urlencode($query);

// EXECUTE THE iTQL QUERY
$results = file_get_contents($search_url_final);

// DEBUGGING : WHEN ENABLED, THE FOLLOWING WILL DUMP THE XML RESULTS SO YOU CAN SEE THE SPARQL XML RESULTS
//	$results2 = str_replace('<', '&lt;', $results);
//	$results2 = str_replace('>', '&gt;<br/>', $results2);
//     echo "Sparql = [". $results2."]";
    
    // ENABLE THE FOLLOWING LINE -- INSTEAD OF THE PREVIOUS ONE -- IF YOU WANT TO SEE JUST THE FIRST 50000 HITS
    // echo "Sparql = [". substr($results2, 0, 50000)."]";
    
    // STORE THE SPARQL XML RESULTS IN Xml_file
    $Xml_file = "$results";
    
    // STORE THE SPECIFIED XSL FILE NAME IN Xsl_file
    $Xsl_file = "../xsltChart/". $xsl_file;
    
    // INITIALIZE A NEW XML OBJECT IN PHP
    $XML = new DOMDocument();
    
    // LOAD THE SPARQL XML RESULTS FILE IN THE XML OBJECT
    $XML->loadXML( $Xml_file );
    
    // INITIALIZE A NEW XSLT PROCESSOR
    $xslt = new XSLTProcessor();
    
		// SET VARIABLES TO BE AVAILABLE TO THE XSLT
		$xslt->setParameter('','myType',$type);
		$xslt->setParameter('','myTitle',$title);
		$xslt->setParameter('','myTerm',$term);

    // TRANSFORM THE XML WITH XSLT
    $XSL = new DOMDocument();
    $XSL->load( $Xsl_file);
    $xslt->importStylesheet( $XSL );
    
    // RETURN THE OUTPUT IN XHTML TO THE PROGRAM THAT CALLED IT FOR FURTHER PROCESSING
    $chart_xml = $xslt->transformToXML( $XML );
    return $chart_xml;
}

// CONVERT THE SPARQL XML RESULTS TO THE XML FORMAT REQUIRED BY xsltChart/chart.xslt

function transform($Xml_file) {
	$Xsl_file = "../xsltChart/chart.xslt";
/*
$Xml_file = '
<chart xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" type="bar">
<title>
iBrowse Chart</title>
<labels>
<label>
Video MIME Types</label>
</labels>
<data name="quicktime">
<value>
14</value>
</data>
<data name="ogg">
<value>
13</value>
</data>
<data name="mp4">
<value>
1</value>
</data>
<data name="x-matroska">
<value>
1</value>
</data>
</chart>';
*/
    
  if (!file_exists($Xsl_file)) {
    echo "The file $Xsl_file does not exist";
	}
//	echo $Xml_file;
  $XML = new DOMDocument();
  $XML->loadXML( $Xml_file );
  $xslt = new XSLTProcessor();

	$xslt->setParameter('','myType',$type);
	$xslt->setParameter('','myTitle',$title);
	$xslt->setParameter('','myTerm',$term);

  $XSL = new DOMDocument();
  $XSL->load( $Xsl_file);
  $xslt->importStylesheet( $XSL );
  print $xslt->transformToXML( $XML );
}
