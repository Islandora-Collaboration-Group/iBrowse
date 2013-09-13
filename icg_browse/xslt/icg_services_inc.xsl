<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTarget"/>
	<xsl:param name="myLabel"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myServer"/>

	<xsl:template match="/">
		<xsl:apply-imports/>

		<div id="icg_instructions">
			<xsl:if test="$myTitle">
				<h3>
					<xsl:value-of select="substring-after($myTitle, '#')"/>
				</h3>
			</xsl:if>
			<xsl:if test="$myTerm">
				<div>
					<p>Triple: Object &lt;<xsl:value-of select="$myTerm"/>&gt; &lt;<xsl:value-of select="$myTarget"/>&gt;</p>
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
						<xsl:value-of select="$myCount"/>
					</p>
				</div>
			</xsl:if>
		</div>

		<div id="icg_content">


			<table id="icg_table" class="tablesorter" cellspacing="1">
				<thead>
					<tr>
						<th class="col_400">
							<xsl:text>Source Object PID</xsl:text>
						</th>
						<th class="col_200">
							<xsl:text>Relationship</xsl:text>
						</th>
						<th class="col_400">
							<xsl:text>Target Object PID</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<!-- might need switch for whether to sort on object, target, data-type, or count and ascending (text) or descending (numbers)-->
						<!-- <xsl:sort select="s:k0" data-type="number" order="descending"/> -->
						<xsl:choose>
							<!--							<xsl:when test="contains(s:relation/@uri,'hasService') and s:target/@uri = $myTarget"> -->
							<xsl:when test="s:target/@uri = $myTarget">
								<tr>
									<td class="col_400">
										<!-- strip 'info:fedora/' from string -->
										<xsl:variable name="pid">
											<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
										</xsl:variable>
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="$myServer"/>
												<xsl:text>/fedora/objects/</xsl:text>
												<xsl:value-of select="$pid"/>
											</xsl:attribute>
											<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
										</a>
									</td>
									<td class="col_200">
										<xsl:variable name="relation">
											<xsl:value-of select="substring-after(s:relation/@uri, '#')"/>
										</xsl:variable>
										<xsl:value-of select="$relation"/>
									</td>

									<td class="col_400">
										<xsl:choose>
											<xsl:when test="s:target/@uri != ''">
												<!-- strip 'info:fedora/' from string -->
												<xsl:variable name="pid">
													<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
												</xsl:variable>
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$myServer"/>
														<xsl:text>/fedora/objects/</xsl:text>
														<xsl:value-of select="$pid"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="contains(s:target/@uri, '/')">
															<xsl:variable name="pid2">
																<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
															</xsl:variable>
															<xsl:value-of select="$pid2"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$pid"/>
														</xsl:otherwise>
													</xsl:choose>
												</a>
											</xsl:when>
											<!-- when there is no uri just display the target value -->
											<xsl:when test="s:target != ''">
												<xsl:value-of select="substring(s:target, 0, 80)"/>
											</xsl:when>
											<xsl:otherwise>nothing to print</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</xsl:for-each>
				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_services_inc.xsl<br/> CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
