<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myRelation"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myServer"/>
	
	<xsl:template match="/">
		<xsl:apply-imports/>

		<div id="icg_instructions">
			<xsl:if test="$myRelation">
				<h3>
					<xsl:value-of select="$myRelation"/>
				</h3>
			</xsl:if>
			<xsl:if test="$myTerm">
				<div>
					<p>Full Form: &lt;<xsl:value-of select="$myTerm"/>&gt;</p>
				</div>
			</xsl:if>
			<xsl:if test="$myNotes">
				<div id="icg_notes">
					<p>
						<xsl:value-of select="$myNotes" disable-output-escaping="yes"/>
					</p>
				</div>
			</xsl:if>
			<p>Total Found: <xsl:value-of select="format-number(sum(//s:k0), '###,###')"/></p>
			<xsl:if test="$myCount">
				<div>
					<p>
						<xsl:value-of select="$myCount" disable-output-escaping="yes"/>
					</p>
				</div>
			</xsl:if>
		</div>

		<div id="icg_content">

			<table id="icg_table" class="tablesorter" cellspacing="1">
				<thead>
					<tr>
						<th class="col_100">
							<xsl:text>Count</xsl:text>
						</th>
						<th class="col_500">
							<xsl:text>MIME Media Types</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<xsl:sort select="s:k0" data-type="number" order="descending"/>
						<tr>
							<td class="col_100 count">
								<xsl:variable name="dsTerm">
									<xsl:value-of select="substring-after(s:target/@uri, '/*/')"/>
								</xsl:variable>
								<a href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype=dtype_inc&amp;icg_sterm={$dsTerm}&amp;icg_server={$myServer}&amp;submit=Submit">
									<xsl:value-of select="s:k0"/>
								</a>
							</td>
							<td class="col_500">
								<xsl:value-of select="substring-after(s:target/@uri, '/*/')"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_dissemination_types.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
