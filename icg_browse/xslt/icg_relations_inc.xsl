<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myDefinition"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myLabel"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myDs"/>
	<xsl:param name="myServer"/>

	<xsl:template match="/">
		<xsl:apply-imports/>

		<div id="icg_instructions">
			<h3>
				<xsl:value-of select="$myTitle"/>
			</h3>
			<!--
			<p>Fedora Definition: <xsl:value-of select="$myDefinition"/></p>
			<p>Comments: <xsl:value-of select="$myNotes"/></p>
			<p>Table: <xsl:value-of select="$myCount"/></p>
-->
		</div>

		<div id="icg_content">

			<table id="icg_table" class="tablesorter" cellspacing="1">
				<thead>
					<tr>
						<th class="col_400">
							<xsl:text>Fedora Object PID)</xsl:text>
						</th>
						<th class="col_300">
							<xsl:text>Relationship (or Property)</xsl:text>
						</th>
						<th class="col_300">
							<xsl:text>Fedora PID (or Value)</xsl:text>
						</th>
					</tr>
				</thead>
				<tbody>

					<xsl:for-each select="/s:sparql/s:results/s:result">
						<!-- might need switch for whether to sort on object, target, data-type, or count and ascending (text) or descending (numbers)-->
						<!-- <xsl:sort select="s:k0" data-type="number" order="descending"/> -->
						<xsl:if test="contains(s:relation/@uri, $myDs)">
							<!-- ensure that s:relation/@uri matches the searchTerm before you go further -->
							<xsl:if test="s:relation/@uri = $myTerm">
								<!-- ensure that s:relation/@uri is not the Fedora Base Object PID -->
								<xsl:if test="not(contains(s:target/@uri, 'FedoraObject'))">
									<xsl:choose>
										<!-- if the s:target has a uri attribute -->
										<!-- ensure that s:relation/@uri is not the Fedora Base Object PID -->
										<xsl:when test="s:target/@uri !='' and not(contains(s:relation/@uri, '#state'))">
											<tr>
												<td class="col_400">
													<!-- strip 'info:fedora/' from string -->
													<xsl:variable name="pid">
														<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
													</xsl:variable>

													<xsl:choose>
														<xsl:when test="contains($pid, '/')">
															<a>
																<xsl:attribute name="href">
																	<xsl:value-of select="$myServer"/>
																	<xsl:text>/fedora/objects/</xsl:text>
																	<xsl:value-of select="substring-before($pid, '/')"/>
																	<xsl:text>/datastreams/</xsl:text>
																	<xsl:value-of select="substring-after($pid, '/')"/>
																</xsl:attribute> 1<xsl:value-of select="$pid"/>
															</a>
															<br/>
															<span style="margin-left:20px;font-size:.8em">
																<xsl:value-of select="substring(s:title, 0, 60)"/>
																<xsl:text>...</xsl:text>
															</span>
														</xsl:when>

														<xsl:otherwise>
															<a>
																<xsl:attribute name="href">
																	<xsl:value-of select="$myServer"/>
																	<xsl:text>/fedora/objects/</xsl:text>
																	<xsl:value-of select="$pid"/>
																</xsl:attribute>
																<xsl:value-of select="$pid"/>
																<xsl:text/>
															</a>
															<br/>
															<span style="margin-left:20px;font-size:.8em">
																<xsl:value-of select="substring(s:title, 0, 50)"/>
																<xsl:text>...</xsl:text>
															</span>
														</xsl:otherwise>

													</xsl:choose>
													<!-- 
												<a>
												<xsl:attribute name="href">
												<xsl:value-of select="$myUrl"/>
												<xsl:value-of select="$pid"/>
												<xsl:text>/datastreams</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="$pid"/>
												<xsl:text/>
												</a>
 -->
												</td>
												<td class="col_300">
													<xsl:value-of select="s:relation/@uri"/>
												</td>
												<td class="col_300">
													<xsl:variable name="pid">
														<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
													</xsl:variable>
													<!-- obsolete ?
												<a>
												<xsl:attribute name="href">
												<xsl:value-of select="$myUrl"/>
												<xsl:value-of select="$pid"/>
												</xsl:attribute>
												<xsl:value-of select="$pid"/>
												</a>
-->
													<!-- check to see if you need to add /datastreams/ to the pid -->
													<xsl:choose>
														<xsl:when test="contains($pid, '/')">
															<a>
																<xsl:attribute name="href">
																	<xsl:value-of select="$myServer"/>
																	<xsl:text>/fedora/objects/</xsl:text>
																	<xsl:value-of select="substring-before($pid, '/')"/>
																	<xsl:text>/datastreams/</xsl:text>
																	<xsl:value-of select="substring-after($pid, '/')"/>
																</xsl:attribute>
																<xsl:value-of select="$pid"/>
															</a>
														</xsl:when>
														<xsl:otherwise>
															<a>
																<xsl:attribute name="href">
																	<xsl:value-of select="$myServer"/>
																	<xsl:text>/fedora/objects/</xsl:text>
																	<xsl:value-of select="$pid"/>
																</xsl:attribute>
																<xsl:value-of select="$pid"/>
															</a>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
										</xsl:when>
										<!-- if the s:target has no uri attribute, don't make it into a hyperlink-->
										<xsl:otherwise>
											<tr>
												<td class="col_400">
													<!-- strip 'info:fedora/' from string -->
													<xsl:variable name="pid">
														<xsl:value-of select="substring-after(s:object/@uri, '/')"/>
													</xsl:variable>

													<xsl:choose>
														<xsl:when test="contains($pid, '/')">
															<a>
																<xsl:attribute name="href">
																	<xsl:value-of select="$myServer"/>
																	<xsl:text>/fedora/objects/</xsl:text>
																	<xsl:value-of select="substring-before($pid, '/')"/>
																	<xsl:text>/datastreams/</xsl:text>
																	<xsl:value-of select="substring-after($pid, '/')"/>
																</xsl:attribute>
																<xsl:value-of select="$pid"/>
															</a>
															<br/>
															<span style="margin-left:20px;font-size:.8em">
																<xsl:value-of select="substring(s:title, 0, 60)"/>
																<xsl:text>...</xsl:text>
															</span>
														</xsl:when>
														<xsl:otherwise>
															<a>
																<xsl:attribute name="href">
																	<xsl:value-of select="$myServer"/>
																	<xsl:text>/fedora/objects/</xsl:text>
																	<xsl:value-of select="$pid"/>
																</xsl:attribute>
																<xsl:value-of select="$pid"/>
															</a>
															<br/>
															<span style="margin-left:20px;font-size:.8em">
																<xsl:value-of select="substring(s:title, 0, 60)"/>
																<xsl:text>...</xsl:text>
															</span>
														</xsl:otherwise>
													</xsl:choose>

													<!--												<a>
												<xsl:attribute name="href">
												<xsl:value-of select="$myUrl"/>
												<xsl:value-of select="$pid"/>

												<xsl:text>/datastreams</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="$pid"/>
												<xsl:text/>
												</a>
  -->
												</td>
												<td class="col_300">
													<xsl:choose>
														<xsl:when test="contains(s:relation/@uri, '#')">
															<xsl:value-of select="substring-after(s:relation/@uri, '#')"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="s:relation/@uri"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td class="col_300">
													<!--											<xsl:choose>
												<xsl:when test="contains(s:target, ':')">
												<a>
												<xsl:attribute name="href">
												<xsl:value-of select="$myUrl"/>
												<xsl:value-of select="s:target"/>
												</xsl:attribute>
												<xsl:value-of select="s:target"/>
												</a>
												</xsl:when>
												<xsl:otherwise>
												</xsl:otherwise>
											</xsl:choose>
-->
													<xsl:value-of select="s:target"/>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</tbody>
			</table>
		</div>

		<div id="icg_footer">
			<p>XSLT: icg_relations_inc.xsl<br/> CSS: icg_results.css</p>
		</div>

	</xsl:template>

</xsl:stylesheet>
