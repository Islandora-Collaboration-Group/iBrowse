<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myRelation"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myLabel"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myCol1"/>
	<xsl:param name="myCol2"/>
	<xsl:param name="myCol3"/>
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
					<p>Full Form: &lt;dc:<xsl:value-of select="$myTerm"/>&gt;</p>
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
						<th class="col_400">
							<xsl:text>Fedora Object PID</xsl:text>
						</th>
						<th class="col_100">
							<xsl:text>DC Field</xsl:text>
						</th>
						<th class="col_500">
							<xsl:text>Value</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<!-- might need switch for whether to sort on object, target, data-type, or count and ascending (text) or descending (numbers)-->
						<!-- <xsl:sort select="s:k0" data-type="number" order="descending"/> -->
						<xsl:if test="contains(s:relation/@uri, $myTerm)">
							<xsl:variable name="relation">
								<xsl:value-of select="substring-after(s:relation/@uri, '#')"/>
							</xsl:variable>
							<tr>
								<td class="col_400">
									<!-- strip 'info:fedora/' from string -->
									<xsl:variable name="pid">
										<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
									</xsl:variable>
									<!--							<xsl:variable name="dsLabel">
								<xsl:value-of select="substring-after($pid, '/')"/>
							</xsl:variable>
							<xsl:variable name="pid2">
								<xsl:value-of select="substring-before($pid, '/')"/>
								<xsl:text>/datastreams/</xsl:text>
							</xsl:variable>
-->
									<a>
										<xsl:attribute name="href">
											<xsl:value-of select="$myServer"/>
											<xsl:text>/fedora/objects/</xsl:text>
											<xsl:value-of select="$pid"/>
										</xsl:attribute>
										<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
									</a>
									<br/>
									<span style="margin-left:20px;font-size:.8em">
										<xsl:value-of select="substring(s:title, 0, 50)"/>
										<xsl:text>...</xsl:text>
									</span>
								</td>
								<td class="col_100">
									<xsl:value-of select="substring-after(substring-after(substring-after(s:relation/@uri, '.'), '.'), '/')"/>
									<!--
									<xsl:value-of select="substring-after(substring-after(substring-after(substring-after(substring-after(s:relation/@uri, '/'), '/'), '/'), '/'), '/')"/>
-->
								</td>
								<td class="col_500">
									<xsl:choose>
										<xsl:when test="contains(s:target/@uri, '#')">
											<xsl:value-of select="substring-after(s:target/@uri, '#')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="s:target/@uri != ''">
													<!-- strip 'info:fedora/' from string -->
													<xsl:variable name="pid2">
														<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
													</xsl:variable>
													<xsl:variable name="pid3">
														<xsl:value-of select="substring-before($pid2, '/')"/>
													</xsl:variable>
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$myServer"/>
															<xsl:text>/fedora/objects/</xsl:text>
															<xsl:value-of select="$pid3"/>
														</xsl:attribute>
														<xsl:attribute name="target">_blank</xsl:attribute>
														<xsl:value-of select="$pid3"/>
														<!--
										<xsl:value-of
											select="substring(substring-after(s:target/@uri, '/'),0,50)"
										/>
-->
													</a>
												</xsl:when>
												<!-- when there is no uri just display the target value -->
												<xsl:when test="s:target != ''">
													<span style="font-size:.8em">
														<xsl:value-of select="substring(s:target, 0, 300)"/>
													</span>
												</xsl:when>
												<xsl:otherwise>[blank]</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>
				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_dublin_core.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>
</xsl:stylesheet>
