<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTarget"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myLabel"/>
	<xsl:param name="myCount"/>
	<xsl:param name="mySort"/>
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
						<th class="col_600">
							<xsl:text>Collection Objects</xsl:text>
						</th>
						<th class="col_200">
							<xsl:text># of Child Objects</xsl:text>
						</th>
						<th class="col_200">
							<xsl:text># of Constituents</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<tr>
							<td class="col_600">
								<xsl:variable name="pid">
									<xsl:value-of select="substring-after(s:collCModel/@uri, '/')"/>
								</xsl:variable>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="$myServer"/>
										<xsl:text>/fedora/objects/</xsl:text>
										<xsl:value-of select="$pid"/>
									</xsl:attribute>
									<xsl:attribute name="title">View Collection Object </xsl:attribute>
									<xsl:value-of select="s:colltitle"/>
								</a>
							</td>
							<td class="col_100 count">
								<xsl:variable name="pid">
									<xsl:value-of select="substring-after(s:collCModel/@uri, '/')"/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="s:k1 > 0">
										<!-- make urls here -->
										<a
											href="../includes/icg_make_query.php?icg_stype=collection_inc&amp;icg_sterm=info:fedora/fedora-system:def/relations-external%23isMemberOfCollection&amp;icg_starget=info:fedora/{$pid}&amp;icg_server={$myServer}&amp;submit=Submit">
											<xsl:attribute name="title">
												<xsl:value-of select="s:k1"/>
											</xsl:attribute>
											<xsl:value-of select="s:k1"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="s:k1"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="col_100 count">
								<xsl:value-of select="s:k2"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_is_member_of_collection.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
