<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myServer"/>
	
	<xsl:template match="/">
		<xsl:apply-imports/>

		<div id="icg_instructions">
			<xsl:if test="$myTitle">
				<h3>
					<xsl:value-of select="$myTitle"/>
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
						<th class="col_800">
							<xsl:text>MIME Type</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<xsl:sort select="s:k0" data-type="number" order="descending"/>
						<xsl:variable name="pid">
							<!-- strip 'info:fedora/' from string -->
							<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
						</xsl:variable>
						<tr>
							<td class="col_100 count">
								<xsl:choose>
									<xsl:when test="s:target = 'application/rdf+xml'">
										<xsl:variable name="target_url">
											<xsl:text>application%2Frdf%2Bxml</xsl:text>
										</xsl:variable>
										<a href="/sites/all/modules/custom/icg_browse/includes/icg_make_query.php?icg_sterm={$target_url}&amp;icg_stype=mtype_inc&amp;icg_server={$myServer}&amp;submit=Submit">
											<xsl:value-of select="s:k0"/>
										</a>
									</xsl:when>
									<xsl:when test="s:target = 'application/tei+xml'">
										<xsl:variable name="target_url">
											<xsl:text>application%2Ftei%2Bxml</xsl:text>
										</xsl:variable>
										<a href="/sites/all/modules/custom/icg_browse/includes/icg_make_query.php?icg_sterm={$target_url}&amp;icg_stype=mtype_inc&amp;icg_server={$myServer}&amp;submit=Submit">
											<xsl:value-of select="s:k0"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="/sites/all/modules/custom/icg_browse/includes/icg_make_query.php?icg_sterm={s:target}&amp;icg_stype=mtype_inc&amp;icg_server={$myServer}&amp;submit=Submit">
											<xsl:value-of select="s:k0"/>
										</a>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="col_800">
								<xsl:value-of select="s:target"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_mime_types.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
