<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:param name="myQuery"/>
    <xsl:param name="myServer"/>
    <xsl:param name="myServerName"/>

    <xsl:template match="/">
        <script type="text/javascript" src="/sites/all/modules/custom/icg_browse/js/jquery.tablesorter/jquery-latest.js"/>
    	<script type="text/javascript" src="/sites/all/modules/custom/icg_browse/js/jquery.tablesorter/jquery.tablesorter"/>
    	<script type="text/javascript" src="/sites/all/modules/custom/icg_browse/js/icg_show_hide.js"/>
        <link rel="stylesheet" type="text/css" href="../css/icg_results.css"/>
        <link id="" media="print, projection, screen" type="text/css" href="../js/jquery.tablesorter/themes/blue/style.css" rel="stylesheet"/>

        <!-- Give jquery ready command -->
        <script type="text/javascript" id="js">
        $(document).ready(function() {
          //  $("#icg_table").tablesorter({sortForce: [[0,1]]});
            $("#icg_table").tablesorter();
        }); 
        </script>

        <p style="font-size:40px;margin:0"><span style="color:brown">i</span>Browse</p>

        <p id="icg_toolbar" style="margin:0;">
            <input type="button" value="Back" onclick="window.history.back()"/><input type="button" value="Toggle Query" onclick="showhide('icg_query')"/>
        </p>

        <div id="icg_query">
            <pre><xsl:value-of select="$myQuery"/></pre>
        </div>
        <p> Fedora Server: <span style="text-decoration:underline"><xsl:value-of select="$myServer"/></span>
            <xsl:if test="$myServerName">
                <xsl:value-of select="$myServer"/>
            </xsl:if>
        </p>

    </xsl:template>

</xsl:stylesheet>
