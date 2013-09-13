<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myCol1"/>
	<xsl:param name="myCol3"/>
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
			<!--			<p>Total Found: <xsl:value-of select="format-number(sum(//s:k0), '###,###')"/></p> -->
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
						<th class="col_500">
							<xsl:text>Fedora Object PID</xsl:text>
						</th>
						<th class="col_500">
							<xsl:text>Datastream ID</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<!-- might need switch for whether to sort on object, target, data-type, or count and ascending (text) or descending (numbers)-->
						<!-- <xsl:sort select="s:k0" data-type="number" order="descending"/> -->
						<xsl:choose>
							<xsl:when test="contains(s:target/@uri, $myTerm) or contains(s:target, $myTerm)">
								<!-- <xsl:if test="s:target/@uri !=''"> -->
								<tr>
									<td class="col_500">
										<!-- strip 'info:fedora/' from string -->
										<xsl:variable name="pid">
											<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
										</xsl:variable>
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="$myServer"/>
												<xsl:text>/fedora/objects/</xsl:text>
												<xsl:value-of select="$pid"/>
												<xsl:text>/datastreams</xsl:text>
											</xsl:attribute>
											<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
										</a>
									</td>
									<td class="col_500">
										<xsl:value-of select="$myTerm"/>
									</td>
								</tr>
								<!--								</xsl:if> -->
							</xsl:when>
							<xsl:otherwise>
								<!--								<br/>myTerm: <xsl:value-of select="$myTerm"/>
								<br/>object: <xsl:value-of select="s:object/@uri"/>
								<p>target: <xsl:value-of select="s:target/@uri"/></p>
-->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_dissemination_types_inc.xsl<br/> CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
