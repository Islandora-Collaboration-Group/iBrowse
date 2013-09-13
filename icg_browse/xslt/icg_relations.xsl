<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTarget"/>
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
						<xsl:value-of select="$myCount"/>
					</p>
				</div>
			</xsl:if>
		</div>

		<div id="icg_content">

			<table id="icg_table" class="tablesorter" cellspacing="1">
				<thead>
					<th class="col_100">
						<xsl:text>Count</xsl:text>
					</th>
					<th class="col_250">
						<xsl:text>Relationship</xsl:text>
					</th>
					<th class="col_600">
						<xsl:text>Related to Object</xsl:text>
					</th>
				</thead>
				<tbody>
					<xsl:choose>
						<xsl:when test="contains($myTerm, 'isMemberOfCollection')">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if test="contains(s:relation/@uri, 'isMemberOfCollection')">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">collection_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
											<br/>
											<span style="margin-left:20px;font-size:.8em">
												<xsl:value-of select="substring(s:title, 0, 60)"/>
												<xsl:text>...</xsl:text>
											</span>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($myTerm, 'isMemberOf')">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if
									test="contains(s:relation/@uri, 'isMemberOf') and not(contains(s:relation/@uri, 'isMemberOfCollection'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc"
											>collection2_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
											<br/>
											<span style="margin-left:20px;font-size:.8em">
												<xsl:value-of select="substring(s:title, 0, 60)"/>
												<xsl:text>...</xsl:text>
											</span>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$myTerm = 'has_model'">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if test="contains(s:relation/@uri, 'hasModel')">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">cmodel_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$myTerm = 'service_def'">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<!-- <xsl:sort select="s:k0" data-type="number" order="descending"/> -->
								<xsl:sort select="*[name() = /s:sparql/s:results/s:result/s:k0]"/>
								<xsl:if
									test="contains($myTerm, 'service_def') and not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model')) and not(contains(s:relation/@uri,'ontology'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">services_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($myTerm, 'hasService')">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<!--								<xsl:sort select="s:k0" data-type="number" order="descending"/> -->
								<xsl:sort select="*[name() = /s:sparql/s:results/s:result/s:k0]"/>
								<xsl:if
									test="contains(s:relation/@uri,'hasService') and not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model')) and not(contains(s:relation/@uri,'ontology'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">services_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($myTerm, 'isContractorOf')">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if
									test="contains(s:relation/@uri,'isContractorOf') and not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model')) and not(contains(s:relation/@uri,'ontology'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">rel_other_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype=services_inc&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($myTerm, 'isDeploymentOf')">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if
									test="contains(s:relation/@uri,'isDeploymentOf') and not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model')) and not(contains(s:relation/@uri,'ontology'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">rel_other_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype=services_inc&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$myTerm = 'is_volatile'">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if
									test="contains(s:relation/@uri,'Volatile') and not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model')) and not(contains(s:relation/@uri,'ontology'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">rel_other_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype=services_inc&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>

						<xsl:when test="$myTerm = 'disseminates'">
							<xsl:value-of select="$myTerm"/>
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<xsl:if
									test="contains(s:relation/@uri,'disseminates') and not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model')) and not(contains(s:relation/@uri,'ontology'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">rel_other_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>

						<xsl:when test="$myTerm = 'rel_other'">
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<xsl:sort select="s:k0" data-type="number" order="descending"/>
								<!--								
<xsl:if test="not(contains(s:relation/@uri,'Member')) and not(contains(s:relation/@uri,'Model'))"> 
-->
								<xsl:if test="contains(s:relation/@uri,'islandora')">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTypeInc">rel_other_inc</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:text>Islandora:</xsl:text>
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="/s:sparql/s:results/s:result">
								<!-- xsl:sort select="s:k0" data-type="number" order="descending"/> -->
								<xsl:if
									test="not(contains(s:relation/@uri, 'isMemberOf')) and not(contains(s:relation/@uri, 'isMemberOf'))">
									<tr>
										<xsl:variable name="pid">
											<!-- strip 'info:fedora/' from string -->
											<xsl:value-of
												select="substring-after(s:target/@uri, '/')"/>
										</xsl:variable>
										<xsl:variable name="myTerm">
											<xsl:value-of
												select="substring-before(s:relation/@uri,'#')"/>
											<xsl:text>%23</xsl:text>
											<xsl:value-of
												select="substring-after(s:relation/@uri,'#')"/>
										</xsl:variable>
										<xsl:variable name="myTarget">
											<xsl:value-of select="s:target/@uri"/>
										</xsl:variable>
										<td class="col_100 count">
											<a
												href="../includes/icg_make_query.php?icg_stype=member&amp;icg_sterm={$myTerm}&amp;icg_starget={$myTarget}&amp;icg_server={$myServer}&amp;submit=Submit">
												<xsl:value-of
												select="format-number(s:k0, '###,###')"/>
											</a>
										</td>
										<td class="col_250">
											<xsl:choose>
												<xsl:when test="contains(s:relation/@uri, '#')">
												<xsl:value-of
												select="substring-after(s:relation/@uri, '#')"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="s:relation/@uri"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td class="col_600">
											<xsl:value-of
												select="substring-after(s:target/@uri,'/')"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>

				</tbody>
			</table>

			<div id="icg_footer">
				<p>XSLT: icg_relations.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
