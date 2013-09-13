<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myLabel"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myServer"/>

	<xsl:key name="attrByVal" match="//@*" use="."/>

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
					<p>Ontology name: &lt;<xsl:value-of select="$myTerm"/>&gt;</p>
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

			<div class="icg_headerRow">
				<p class="col_1000">
					<xsl:text>Relationships</xsl:text>
				</p>
			</div>

			<div id="icg_table">
				<ul>
					<xsl:apply-templates select="//@*"/>
				</ul>
			</div>

			<div class="icg_headerRow">
				<xsl:text>&#160;</xsl:text>
			</div>

			<div id="icg_footer">
				<p>XSLT: icg_relations_hamilton.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

	<xsl:template match="//s:relation/@*[generate-id()=generate-id(key('attrByVal', .)[1])]">
		<xsl:variable name="ontology_name">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:if
			test="contains(., $myTerm)">
			<!--		<xsl:if
				test="contains(., 'hamilton')"> -->
			<li>
				<hr/>
				<p class="col_1000">
					<xsl:choose>
						<xsl:when test="contains($ontology_name,'#')">
							<xsl:variable name="ontology_name_url">
								<xsl:value-of select="substring-before($ontology_name,'#')"/>
								<xsl:text>%23</xsl:text>
								<xsl:value-of select="substring-after($ontology_name,'#')"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when
									test="contains($ontology_name, 'ownerID') or contains($ontology_name, 'state') or contains($ontology_name, 'label') or contains($ontology_name, 'createdDate')">
									<a
										href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype=properties&amp;icg_sterm={$ontology_name_url}&amp;submit=Submit">
										<xsl:value-of select="$ontology_name"/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a
										href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype=relations_inc&amp;icg_sterm={$ontology_name_url}&amp;submit=Submit">
										<xsl:value-of select="$ontology_name"/>
									</a>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="myTypeInc">
								<xsl:choose>
									<xsl:when test="contains($ontology_name, 'elements')">
										<xsl:text>properties</xsl:text>
									</xsl:when>
									<xsl:otherwise>find_relationship</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<a
								href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$ontology_name}&amp;submit=Submit">
								<xsl:value-of select="$ontology_name"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</p>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*"/>

</xsl:stylesheet>
